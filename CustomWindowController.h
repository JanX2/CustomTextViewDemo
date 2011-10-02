//
//  CustomWindowController.h
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SSYDragDestinationTextView.h"
#import "SSYDragDestinationTextViewDelegate.h"

@interface CustomWindowController : NSWindowController <SSYDragDestinationTextViewDelegate> {
	IBOutlet SSYDragDestinationTextView *	customTextView;
}

@end
