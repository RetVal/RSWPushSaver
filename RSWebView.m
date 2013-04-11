//
//  RSWebView.m
//  RSWPushSaver
//
//  Created by RetVal on 4/10/13.
//
//

#import "RSWebView.h"
#import "WebSaverView.h"
@implementation RSWebView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (WebFrame *)mainFrame
{
    WebSaverView *superView = (WebSaverView *)[self superview];
    [self setCustomUserAgent: [superView userAgent]];
    return [super mainFrame];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [super drawRect:dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
}

- (void)keyDown:(NSEvent *)theEvent
{
    [super keyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent
{
    [super keyUp:theEvent];
}
- (void)touchesBeganWithEvent:(NSEvent *)event
{
    [super touchesBeganWithEvent:event];
}
- (void)touchesMovedWithEvent:(NSEvent *)event
{
    [super touchesMovedWithEvent:event];
}
- (void)touchesEndedWithEvent:(NSEvent *)event
{
    [super touchesEndedWithEvent:event];
}
- (void)touchesCancelledWithEvent:(NSEvent *)event
{
    [super touchesCancelledWithEvent:event];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
}
@end
