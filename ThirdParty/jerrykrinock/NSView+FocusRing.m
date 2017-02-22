#import "NSView+FocusRing.h"

@implementation NSView (FocusRing)

// The code is originally from:
// http://www.cocoabuilder.com/archive/message/cocoa/2003/4/7/88648
- (void)drawFocusRing;
{
	[[NSColor keyboardFocusIndicatorColor] set];
	NSRect rect = self.visibleRect;
	[NSGraphicsContext saveGraphicsState];
	NSSetFocusRingStyle(NSFocusRingOnly);
	NSFrameRect(rect);
	[NSGraphicsContext restoreGraphicsState];
}

@end
