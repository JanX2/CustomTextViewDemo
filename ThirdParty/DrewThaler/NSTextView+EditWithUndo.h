//
//  NSTextView+EditWithUndo.h
//  CustomTextViewDemo
//
//  Created by Jan on 04.10.11.
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import <Foundation/Foundation.h>


@interface NSTextView (EditWithUndo)

- (void)replaceCharactersInRange:(NSRange)range withAttributedText:(NSAttributedString *)attributedString;
- (void)insertAttributedText:(NSAttributedString *)attributedString atIndex:(NSUInteger)index;
- (void)insertAttributedText:(NSAttributedString *)attributedString atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
- (void)insertAttributedText:(NSAttributedString *)attributedString;
- (void)insertText:(NSString *)string withAttributes:(NSDictionary *)attr;

@end
