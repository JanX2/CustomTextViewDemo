//
//  CustomWindowController.m
//  CustomTextViewDemo
//
//  Created by Jan on 02.10.11.
//

#import "CustomWindowController.h"

#import "NSTextView+JXEditWithUndo.h"


NSAttributedString * attributedStringForURL(NSURL *aURL, NSDictionary **documentAttributes, NSError **outError) {
	NSDictionary *documentOptions = [NSDictionary dictionary];
	NSError *error;
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:aURL
																		   options:documentOptions
																documentAttributes:documentAttributes
																			 error:&error];
	if (!attributedString) {
		if (outError) {
			*outError = [[error retain] autorelease];
		}
	}
	
	return [attributedString autorelease];
}


@implementation CustomWindowController

@synthesize lastFileURL;
@synthesize droppedFileProcessingType;

- (id)init
{
	if (self = [super init]) {
		lastFileURL = nil;
		droppedFileProcessingType = 2;
	}
	
	return self;
}

- (void)dealloc
{
	self.lastFileURL = nil;

	[super dealloc];
}

- (void)awakeFromNib
{
	[customTextView unregisterDraggedTypes];
	[customTextView registerForDraggedTypes:[NSAttributedString textTypes]];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
				 destination:(SSYDragDestinationTextView *)destination;
{
#if ENABLE_LOGGING
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
#endif
	
	// Filter out unwelcome destinations
	if (![destination isEqual:customTextView]) {
		return NO;
	}
	
	// Thanks to Kyle Sluder who posted this as “Re: Proper UTI for accepting files dropped on my table view?”
	NSArray *fileURLs =
	[[sender draggingPasteboard]
	 readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
	 options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
										 forKey:NSPasteboardURLReadingFileURLsOnlyKey]];
	
#if ENABLE_LOGGING
	NSLog(@"%@", fileURLs);
#endif
	
	if ([fileURLs count] == 1) {
		self.lastFileURL = [fileURLs objectAtIndex:0];
		
		NSDictionary *documentAttributes;
		NSError *error;
		NSAttributedString *attributedString = attributedStringForURL(self.lastFileURL, &documentAttributes, &error);
		
		if (attributedString == nil) {
			NSWindow *myWindow = [self window];
			
			if ((myWindow != nil) && [myWindow isVisible]) {
				[self presentError:error 
					modalForWindow:myWindow 
						  delegate:self 
				didPresentSelector:@selector(didPresentErrorWithRecovery:contextInfo:) 
					   contextInfo:NULL];
			}
			else {
				[self presentError:error];
			}

			return NO;
		}
		
		NSUndoManager *undoManager = [[self window] undoManager];

		if (droppedFileProcessingType == 1) { // Insert
			[undoManager setActionName:NSLocalizedString(@"Insert Text from File", @"Undo menu insert text string, without the 'Undo'")];

			NSUInteger charIndex = [destination dragTargetCharIndex];
			
			[destination insertTextJX:attributedString atIndex:charIndex checkIndex:YES];
		}
		else if (droppedFileProcessingType == 2) { // Replace
			[undoManager setActionName:NSLocalizedString(@"Replace with Text File", @"Undo menu replace text string, without the 'Undo'")];

			[destination setTextJX:attributedString];
		}
		else {
			return NO;
		}

		return YES;
	}
	else {
		// We want single files only!
		return NO;
	}
	
	return NO;
}

- (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void  *)contextInfo
{
	// We ignore error recovery for now.
	return;
}

@end
