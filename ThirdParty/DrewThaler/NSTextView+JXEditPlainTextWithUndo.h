//
//  NSTextView+JXEditPlainTextWithUndo.h
//  MarkdownLive
//
//  Created by Jan Weiß on 31.08.12. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


@interface NSTextView (EditPlainTextWithUndo)

- (BOOL)setStringJX:(NSString *)string;
- (BOOL)replaceCharactersInRange:(NSRange)range withStringJX:(NSString *)string;
- (BOOL)insertStringJX:(NSString *)string atIndex:(NSUInteger)index;
- (BOOL)insertStringJX:(NSString *)string atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
- (BOOL)insertStringJX:(NSString *)string;

@end
