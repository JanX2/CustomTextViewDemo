//
//  NSTextView+EditWithUndo.h
//  CustomTextViewDemo
//
//  Created by Jan on 04.10.11.
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import <Foundation/Foundation.h>


@interface NSTextView (EditWithUndo)

- (BOOL)setAttributedText:(NSAttributedString *)attributedString;
- (BOOL)replaceCharactersInRange:(NSRange)range withAttributedText:(NSAttributedString *)attributedString;
- (BOOL)insertAttributedText:(NSAttributedString *)attributedString atIndex:(NSUInteger)index;
- (BOOL)insertAttributedText:(NSAttributedString *)attributedString atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
- (BOOL)insertAttributedText:(NSAttributedString *)attributedString;
- (BOOL)insertText:(NSString *)string withAttributes:(NSDictionary *)attr;

@end
