//
//  CustomWindowController.m
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import "CustomWindowController.h"

#import "NSTextView+InsertWithUndo.h"


#if !defined(MAX_OF_CONST_AND_DIFF)
// Determines the maximum of two expressions:
// The first is a constant (first parameter) while the second expression is
// the difference between the second and third parameter.  The way this is
// calculated prevents integer overflow in the result of the difference.
#define MAX_OF_CONST_AND_DIFF(A,B,C)  ((B) <= (C) ? (A) : (B) - (C) + (A))
#endif


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
		NSUInteger charIndex = [destination dragTargetCharIndex];

		if (charIndex == NSNotFound) {
			charIndex = MAX_OF_CONST_AND_DIFF(0, [textStorage length], 1); // Last character in textStorage
		}

		[destination insertAttributedText:attributedString atIndex:charIndex];

		return YES;
	}
	else {
		// We want single files only!
		return NO;
	}
	
	return NO;
}

@end
