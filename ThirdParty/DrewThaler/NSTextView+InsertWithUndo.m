//
//  NSTextView+InsertWithUndo.m
//  CustomTextViewDemo
//
//  Created by Jan on 04.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import "NSTextView+InsertWithUndo.h"


@implementation NSTextView (InsertWithUndo)

- (void)insertAttributedText:(NSAttributedString *)astring;
{
	NSRange range = [self selectedRange];
	NSString *insertingText = [astring string];
	NSString *selectedText = [[self string] substringWithRange:range];
	NSString *stringForDelegate = insertingText;
	
	// If only attributes are changing, pass nil.
	if ([insertingText isEqualToString:selectedText]) {
		stringForDelegate = nil;
	}
	
	// Call delegate methods to force undo recording
	if ([self shouldChangeTextInRange:range
					replacementString:stringForDelegate]) {
		[[self textStorage] replaceCharactersInRange:range
								withAttributedString:astring];
		[self setSelectedRange:NSMakeRange(range.location + [astring length], 0)];
		[self didChangeText];
	}
}

- (void)insertText:(NSString *)string withAttributes:(NSDictionary *)attr;
{
	NSAttributedString *astring =
	[[NSAttributedString alloc] initWithString:string
									attributes:attr];
	[self insertAttributedText:astring];
	[astring release];
}

@end