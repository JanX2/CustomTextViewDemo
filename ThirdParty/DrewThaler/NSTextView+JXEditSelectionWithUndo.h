//
//  NSTextView+JXEditSelectionWithUndo.h
//  MarkdownLive
//
//  Created by Jan Weiß on 31.08.12. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


@interface NSTextView (EditSelectionWithUndo)

- (void)setSelectedRangeWithUndoJX:(NSRange)range;
- (void)setSelectedRangesWithUndoJX:(NSArray *)ranges;

@end
