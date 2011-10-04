//
//  NSTextView+EditWithUndo.m
//  CustomTextViewDemo
//
//  Created by Jan on 04.10.11.
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import "NSTextView+EditWithUndo.h"


#if !defined(MAX_OF_CONST_AND_DIFF)
// Determines the maximum of two expressions:
// The first is a constant (first parameter) while the second expression is
// the difference between the second and third parameter.  The way this is
// calculated prevents integer overflow in the result of the difference.
#define MAX_OF_CONST_AND_DIFF(A,B,C)  ((B) <= (C) ? (A) : (B) - (C) + (A))
#endif


@implementation NSTextView (EditWithUndo)

- (void)setAttributedText:(NSAttributedString *)attributedString;
{
	[self replaceCharactersInRange:NSMakeRange(0, [[self textStorage] length]) withAttributedText:attributedString];
}

- (void)replaceCharactersInRange:(NSRange)range withAttributedText:(NSAttributedString *)attributedString;
{
	NSString *insertingText = [attributedString string];
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
								withAttributedString:attributedString];
		[self setSelectedRange:NSMakeRange(range.location + [attributedString length], 0)];
		[self didChangeText];
	}	
}

- (void)insertAttributedText:(NSAttributedString *)attributedString atIndex:(NSUInteger)index;
{
	NSRange range = NSMakeRange(index, 0);
	[self replaceCharactersInRange:range withAttributedText:attributedString];
}

- (void)insertAttributedText:(NSAttributedString *)attributedString atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
{
	NSTextStorage *textStorage = [self textStorage];
	NSUInteger textLength = [textStorage length];

	if (checkIndex && (index == NSNotFound || !(index < textLength))) {
		index = MAX_OF_CONST_AND_DIFF(0, textLength, 1); // Last character in textStorage
	}
	
	[self insertAttributedText:attributedString atIndex:index];
}

- (void)insertAttributedText:(NSAttributedString *)attributedString;
{
	NSRange range = [self selectedRange];
	[self replaceCharactersInRange:range withAttributedText:attributedString];
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