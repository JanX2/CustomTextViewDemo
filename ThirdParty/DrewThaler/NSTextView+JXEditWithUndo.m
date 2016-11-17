//
//  NSTextView+JXEditWithUndo.m
//  CustomTextViewDemo
//
//  Created by Jan on 04.10.11.
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import "NSTextView+JXEditWithUndo.h"

#import "NSTextView+JXEditSelectionWithUndo.h"

@implementation NSTextView (EditWithUndo)

- (BOOL)setTextJX:(NSAttributedString *)attributedString;
{
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndoJX:self.selectedRange];

	if ([self shouldChangeTextInRange:NSMakeRange(0, [[self textStorage] length])
					replacementString:[attributedString string]]) {
		
		[[self textStorage] setAttributedString:attributedString];
		
		[self didChangeText];

		[self setSelectedRangeWithUndoJX:NSMakeRange(0, 0)];
		
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)replaceCharactersInRange:(NSRange)range withTextJX:(NSAttributedString *)attributedString;
{
	NSString *insertingText = [attributedString string];
	NSString *selectedText = [[self string] substringWithRange:range];
	NSString *stringForDelegate = insertingText;
	
	// If only attributes are changing, pass nil.
	if ([insertingText isEqualToString:selectedText]) {
		stringForDelegate = nil;
	}
	
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndoJX:self.selectedRange];

	// Call delegate methods to force undo recording
	if ([self shouldChangeTextInRange:range
					replacementString:stringForDelegate]) {

		[[self textStorage] replaceCharactersInRange:range
								withAttributedString:attributedString];

		[self didChangeText];

		[self setSelectedRangeWithUndoJX:NSMakeRange(range.location + [attributedString length], 0)];
		
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)insertTextJX:(NSAttributedString *)attributedString atIndex:(NSUInteger)index;
{
	NSRange range = NSMakeRange(index, 0);
	return [self replaceCharactersInRange:range withTextJX:attributedString];
}

- (BOOL)insertTextJX:(NSAttributedString *)attributedString atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
{
	NSTextStorage *textStorage = [self textStorage];
	NSUInteger textLength = [textStorage length];

	if (checkIndex && (index == NSNotFound || !(index <= textLength))) {
		index = textLength; // AFTER the last character in textStorage
	}
	
	return [self insertTextJX:attributedString atIndex:index];
}

- (BOOL)insertTextJX:(NSAttributedString *)attributedString;
{
	NSRange range = [self selectedRange];
	return [self replaceCharactersInRange:range withTextJX:attributedString];
}

- (BOOL)insertStringJX:(NSString *)string withAttributes:(NSDictionary *)attr;
{
	BOOL success = NO;
	NSAttributedString *astring =
	[[NSAttributedString alloc] initWithString:string
									attributes:attr];
	success = [self insertTextJX:astring];
	[astring release];
	
	return success;
}

@end
