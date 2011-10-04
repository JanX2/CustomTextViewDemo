//
//  CustomWindowController.m
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import "CustomWindowController.h"

#import "NSTextView+EditWithUndo.h"


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

@synthesize lastFileURL;

- (void)dealloc
{
	self.lastFileURL = nil;

	[super dealloc];
}

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
		self.lastFileURL = [fileURLs objectAtIndex:0];
		
		NSDictionary *documentAttributes;
		NSError *error;
		NSAttributedString *attributedString = attributedStringForURL(self.lastFileURL, &documentAttributes, &error);
		
		if (attributedString == nil) {
			NSLog(@"URL:%@\n%@", self.lastFileURL, error);
			return NO;
		}
		
		NSUInteger charIndex = [destination dragTargetCharIndex];

		[destination insertAttributedText:attributedString atIndex:charIndex checkIndex:YES];

		return YES;
	}
	else {
		// We want single files only!
		return NO;
	}
	
	return NO;
}

@end
