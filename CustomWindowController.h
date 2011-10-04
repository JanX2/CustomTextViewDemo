//
//  CustomWindowController.h
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//

#import <Cocoa/Cocoa.h>

#import "SSYDragDestinationTextView.h"
#import "SSYDragDestinationTextViewDelegate.h"

@interface CustomWindowController : NSWindowController <SSYDragDestinationTextViewDelegate> {
	IBOutlet SSYDragDestinationTextView *	customTextView;

	NSURL *		lastFileURL;
	NSInteger	droppedFileProcessingType;
}

@property (nonatomic, retain) NSURL *lastFileURL;
@property (nonatomic, assign) NSInteger droppedFileProcessingType;

@end
