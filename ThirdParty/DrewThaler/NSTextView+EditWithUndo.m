//
//  NSTextView+EditWithUndo.m
//  CustomTextViewDemo
//
//  Created by Jan on 04.10.11.
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import "NSTextView+EditWithUndo.h"


@implementation NSTextView (EditWithUndo)

- (void)setSelectedRangeWithUndo:(NSRange)range;
{
	[self setSelectedRange:range];
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndo:range];
}

- (void)setAttributedText:(NSAttributedString *)attributedString;
{
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndo:self.selectedRange];

	if ([self shouldChangeTextInRange:NSMakeRange(0, [[self textStorage] length])
					replacementString:[attributedString string]]) {
		
		[[self textStorage] setAttributedString:attributedString];
		
		[self didChangeText];

		[self setSelectedRangeWithUndo:NSMakeRange(0, 0)];
	}
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
	
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndo:self.selectedRange];

	// Call delegate methods to force undo recording
	if ([self shouldChangeTextInRange:range
					replacementString:stringForDelegate]) {

		[[self textStorage] replaceCharactersInRange:range
								withAttributedString:attributedString];

		[self didChangeText];

		[self setSelectedRangeWithUndo:NSMakeRange(range.location + [attributedString length], 0)];
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

	if (checkIndex && (index == NSNotFound || !(index <= textLength))) {
		index = textLength; // AFTER the last character in textStorage
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