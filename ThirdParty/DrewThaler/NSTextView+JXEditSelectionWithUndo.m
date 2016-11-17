//
//  NSTextView+JXEditSelectionWithUndo.m
//  MarkdownLive
//
//  Created by Jan Weiß on 04.09.12. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

// Based on DrewThaler’s post at https://web.archive.org/web/20111013161254/http://cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import "NSTextView+JXEditSelectionWithUndo.h"


@implementation NSTextView (EditPlainTextWithUndo)

- (void)setSelectedRangeWithUndoJX:(NSRange)range;
{
	[self setSelectedRange:range];
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndoJX:range];
}

- (void)setSelectedRangesWithUndoJX:(NSArray *)ranges;
{
	[self setSelectedRanges:ranges];
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangesWithUndoJX:ranges];
}

@end
