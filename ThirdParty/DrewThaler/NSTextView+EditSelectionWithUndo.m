//
//  NSTextView+EditSelectionWithUndo.m
//  MarkdownLive
//
//  Created by Jan Weiß on 04.09.12. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import "NSTextView+EditSelectionWithUndo.h"


@implementation NSTextView (EditPlainTextWithUndo)

- (void)setSelectedRangeWithUndo:(NSRange)range;
{
	[self setSelectedRange:range];
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndo:range];
}

- (void)setSelectedRangesWithUndo:(NSArray *)ranges;
{
	[self setSelectedRanges:ranges];
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangesWithUndo:ranges];
}

@end
