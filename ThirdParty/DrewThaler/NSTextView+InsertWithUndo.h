//
//  NSTextView+InsertWithUndo.h
//  CustomTextViewDemo
//
//  Created by Jan on 04.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTextView (InsertWithUndo)

- (void)insertAttributedText:(NSAttributedString *)astring;
- (void)insertText:(NSString *)string withAttributes:(NSDictionary *)attr;

@end
