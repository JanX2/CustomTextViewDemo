//
//  CustomWindowController.m
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import "CustomWindowController.h"


NSAttributedString * attributedStringForURL(NSURL *aURL, NSDictionary **documentAttributes, NSError **outError) {
	NSDictionary *documentOptions = [NSDictionary dictionary];
	NSError *error;
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:aURL
																		   options:documentOptions
																documentAttributes:documentAttributes
																			 error:&error];
	if (!attributedString) {
		if (outError) {
			*outError = [[error retain] autorelease];
		}
	}
	
	return [attributedString autorelease];
}


@implementation CustomWindowController

- (void)awakeFromNib
{
	[customTextView unregisterDraggedTypes];
	[customTextView registerForDraggedTypes:[NSAttributedString textTypes]];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
				 destination:(SSYDragDestinationTextView *)destination;
{
#if ENABLE_LOGGING
	NSLog(@"\nsender: %@\ndestination: %@", sender, destination);
	
	NSArray *pasteboardItems = [[sender draggingPasteboard] pasteboardItems];
	for (NSPasteboardItem *thisPBItem in pasteboardItems) {
		NSArray *thisPBItemTypes = [thisPBItem types];
		NSMutableDictionary *thisPBItemStringsDict = [NSMutableDictionary dictionaryWithCapacity:[thisPBItemTypes count]];
		for (NSString *thisType in thisPBItemTypes) {
			[thisPBItemStringsDict setValue:[thisPBItem stringForType:thisType] forKey:thisType];
		}
		NSLog(@"%@", thisPBItemStringsDict);
	}
#endif
	
	// Filter out unwelcome destinations
	if (![destination isEqual:customTextView]) {
		return NO;
	}
	
	// Thanks to Kyle Sluder who posted this as “Re: Proper UTI for accepting files dropped on my table view?”
	NSArray *fileURLs =
	[[sender draggingPasteboard]
	 readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
	 options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
										 forKey:NSPasteboardURLReadingFileURLsOnlyKey]];
	
#if ENABLE_LOGGING
	NSLog(@"%@", fileURLs);
#endif
	
	if ([fileURLs count] == 1) {
		NSURL *fileURL = [fileURLs objectAtIndex:0];
		
		NSDictionary *documentAttributes;
		NSError *error;
		NSAttributedString *attributedString = attributedStringForURL(fileURL, &documentAttributes, &error);
		
		if (attributedString == nil) {
			NSLog(@"URL:%@\n%@", fileURL, error);
			return NO;
		}
		
		NSTextStorage *textStorage = [destination textStorage];
		NSTextContainer *textContainer = [destination textContainer];
		NSLayoutManager *layoutManager = [destination layoutManager];
		NSUInteger glyphIndex, charIndex;
		NSRect glyphRect;
		
		NSPoint point = [destination convertPoint:[[destination window] mouseLocationOutsideOfEventStream] fromView:nil];
		point.x -= [destination textContainerOrigin].x;
		point.y -= [destination textContainerOrigin].y;
		// Convert those coordinates to the nearest glyph index
		glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
		
		// Check to see whether the mouse actually lies over the glyph it is nearest to
		glyphRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIndex, 1) inTextContainer:textContainer];
		if (NSPointInRect(point, glyphRect)) {
			// Convert the glyph index to a character index
			charIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];

			[textStorage insertAttributedString:attributedString atIndex:charIndex];
		}
		else {
			[textStorage insertAttributedString:attributedString atIndex:0];
		}


		return YES;
	}
	else {
		// We want single files only!
		return NO;
	}
	
	return NO;
}

@end
