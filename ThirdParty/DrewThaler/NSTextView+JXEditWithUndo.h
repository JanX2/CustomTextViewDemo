//
//  NSTextView+JXEditWithUndo.h
//  CustomTextViewDemo
//
//  Created by Jan Weiß on 04.10.11. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface NSTextView (EditWithUndo)

- (BOOL)setTextJX:(NSAttributedString *)attributedString;
- (BOOL)deleteCharactersInRangeJX:(NSRange)range;
- (BOOL)replaceCharactersInRange:(NSRange)range withTextJX:(NSAttributedString *)attributedString;
- (BOOL)insertTextJX:(NSAttributedString *)attributedString atIndex:(NSUInteger)index;
- (BOOL)insertTextJX:(NSAttributedString *)attributedString atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
- (BOOL)insertTextJX:(NSAttributedString *)attributedString;
- (BOOL)insertStringJX:(NSString *)string withAttributes:(NSDictionary *)attr;

@end
