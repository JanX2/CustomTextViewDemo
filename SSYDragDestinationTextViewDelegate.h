//
//  SSYDragDestinationTextViewDelegate.h
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol SSYDragDestinationTextViewDelegate

- (BOOL)performDragOperation:(id <NSDraggingInfo>)draggingInfo destination:(NSTextView *)destinationTextView ;

@end
