//
//  CustomWindowController.m
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//  Copyright 2011 geheimwerk.de. All rights reserved.
//

#import "CustomWindowController.h"

@implementation CustomWindowController

- (void)awakeFromNib
{
	[customTextView unregisterDraggedTypes];
	[customTextView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]]; 
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
				 destination:(SSYDragDestinationTextView *)destination;
{
	NSLog(@"\nsender: %@\ndestination: %@", sender, destination);
	
	NSArray *pasteboardItems = [[sender draggingPasteboard] pasteboardItems];
	for (NSPasteboardItem *thisPBItem in pasteboardItems) {
		NSArray *thisPBItemTypes = [thisPBItem types];
		NSMutableDictionary *thisPBItemStringsDict = [NSMutableDictionary dictionaryWithCapacity:[thisPBItemTypes count]];
		for (NSString *thisType in thisPBItemTypes) {
			[thisPBItemStringsDict setValue:[thisPBItem stringForType:thisType] forKey:thisType];
		}
		NSLog(@"%@", thisPBItemStringsDict);
	}

	return YES;
}

@end
