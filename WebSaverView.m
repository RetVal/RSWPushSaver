//
//  WebSaverView.m
//  WebSaver
//
//  Created by Dustin Sallings on 2008/12/11.
//  Copyright (c) 2008, Dustin Sallings <dustin@spy.net>. All rights reserved.
//

//
//  WebSaverView.m
//  RSPWebSaver
//
//  Re-Developed by RetVal on 2013/4/11.
//  Copyright (c) 2013, RetVal. All rights reserved.
//

#import "WebSaverView.h"
@implementation WebSaverView
- (NSString *)userAgent
{
    switch ([WSVUserAgent integerValue])
    {
        case 1:
            return @"Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3";
        default:
            break;
    }
    return @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.25 (KHTML, like Gecko) Version/6.0 Safari/536.25";
}
- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self)
    {
    	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.retval.RSWPushSaver"];
        [defaults registerDefaults:@{@"url0": @"http://www.pingwest.com",
                                     @"url1": @"http://www.weibo.com",
                                     @"url2": @"http://www.baidu.com",
                                     @"url3": @"http://3g.163.com/touch/",
                                     @"refresh":[NSNumber numberWithInt:0],
                                     @"userAgent":[NSNumber numberWithInt:0]}];
        url[0] = [defaults valueForKey: @"url0"];
        url[1] = [defaults valueForKey: @"url1"];
        url[2] = [defaults valueForKey: @"url2"];
        url[3] = [defaults valueForKey: @"url3"];
        WSVUserAgent = [defaults valueForKey:@"userAgent"];
        refresh = [defaults integerForKey: @"refresh"];
        NSRect screenBounds = [[NSScreen mainScreen] frame];
        NSLog(@"visibleFrame is %@", NSStringFromRect(screenBounds));
        NSPoint centerPoint = NSMakePoint(NSMidX(screenBounds), NSMidY(screenBounds));
        NSLog(@"center point is %@", NSStringFromPoint(centerPoint));
        NSRect frame0 = NSMakeRect(0, 0, centerPoint.x, centerPoint.y);
        webview[0] = [[RSWebView alloc] initWithFrame:frame0 frameName:@"main" groupName:@"main"];
        NSRect frame1 = NSMakeRect(0, centerPoint.y, centerPoint.x, centerPoint.y);
        webview[1] = [[RSWebView alloc] initWithFrame:frame1 frameName:@"main" groupName:@"main"];
        
        NSRect frame2 = NSMakeRect(centerPoint.x, 0, centerPoint.x, centerPoint.y);
        webview[2] = [[RSWebView alloc] initWithFrame:frame2 frameName:@"main" groupName:@"main"];
        NSRect frame3 = NSMakeRect(centerPoint.x, centerPoint.y, centerPoint.x, centerPoint.y);
        webview[3] = [[RSWebView alloc] initWithFrame:frame3 frameName:@"main" groupName:@"main"];
        
        for (int idx = 0; idx < 4; ++idx)
        {
            [self addSubview:webview[idx]];
        }

        NSLog(@"Setting animation interval to %d", refresh);
        if(refresh > 0) {
            [self setAnimationTimeInterval: refresh];
        } else {
            // Arbitrarily large magic number.
            [self setAnimationTimeInterval: 2<<24];
        }
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
    
    for (int idx = 0; idx < 4; ++idx) {
        NSLog(@"%d webview frame is %@", idx, NSStringFromRect([webview[idx] frame]));
        [[webview[idx] mainFrame] loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:url[idx]]]];
    }
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
}

- (void)animateOneFrame
{
    [webview[0] reload:self];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

// Display the configuration sheet for the user to choose their settings
- (NSWindow*)configureSheet
{
	// if we haven't loaded our configure sheet, load the nib named MyScreenSaver.nib
	if (!configSheet) {
		[NSBundle loadNibNamed:@"WebSaver" owner:self];
    }

    [urlField0 setStringValue:url[0]];
    [urlField1 setStringValue:url[1]];
    [urlField2 setStringValue:url[2]];
    [urlField3 setStringValue:url[3]];
    
    [refreshSlider setIntValue:refresh];
    [self changedRefresh: refreshSlider];
    [userAgentCheckBtn setState:[WSVUserAgent integerValue] ? NSOnState : NSOffState ];
	return configSheet;
}

// Called when the user clicked the SAVE button
- (IBAction) closeSheetSave:(id) sender
{
    // get the defaults
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.retval.RSWPushSaver"];
	
	// write the defaults
    url[0] = [urlField0 stringValue];
    url[1] = [urlField1 stringValue];
    url[2] = [urlField2 stringValue];
    url[3] = [urlField3 stringValue];
	[defaults setValue:url[0] forKey:@"url0"];
    [defaults setValue:url[1] forKey:@"url1"];
    [defaults setValue:url[2] forKey:@"url2"];
    [defaults setValue:url[3] forKey:@"url3"];
    [defaults setInteger:[refreshSlider intValue] forKey:@"refresh"];
    if (userAgentCheckBtn.state == NSOffState)
        [defaults setValue: WSVUserAgent = [NSNumber numberWithInt:0] forKey:@"userAgent"];
    else
        [defaults setValue: WSVUserAgent = [NSNumber numberWithInt:1] forKey:@"userAgent"];
	// synchronize
    [defaults synchronize];

	// end the sheet
    [NSApp endSheet:configSheet];
}

// Called when th user clicked the CANCEL button
- (IBAction) closeSheetCancel:(id) sender
{
	// nothing to configure
    [NSApp endSheet:configSheet];
}

- (IBAction) changedRefresh:(id) sender
{
    refresh = [refreshSlider intValue];
    if(refresh == 0) {
        [refreshLabel setStringValue: @"Never"];
    } else {
        [refreshLabel setStringValue: [NSString stringWithFormat:@"%d s", refresh]];
    }
}

- (RSWebView *)_webViewHandlerDispatchWithEvent:(NSEvent *)event
{
    NSPoint point = [NSEvent mouseLocation];
    for (int idx = 0; idx < 4; idx++)
    {
        if (NSPointInRect(point, [webview[idx] frame]))
        {
            NSLog(@"webview number is %d", idx);
            return webview[idx];
        }
    }
    NSLog(@"webview is nil.");
    return nil;
}

- (void)touchesBeganWithEvent:(NSEvent *)event
{
    NSLog(@"%@,%@", NSStringFromSelector(_cmd), event);
    [[self _webViewHandlerDispatchWithEvent:event] touchesBeganWithEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event
{
    NSLog(@"%@,%@", NSStringFromSelector(_cmd), event);
    [[self _webViewHandlerDispatchWithEvent:event] touchesMovedWithEvent:event];
}

- (void)touchesEndedWithEvent:(NSEvent *)event
{
    NSLog(@"%@,%@", NSStringFromSelector(_cmd), event);
    [[self _webViewHandlerDispatchWithEvent:event] touchesEndedWithEvent:event];
}

- (void)touchesCancelledWithEvent:(NSEvent *)event
{
    NSLog(@"%@,%@", NSStringFromSelector(_cmd), event);
    [[self _webViewHandlerDispatchWithEvent:event] touchesCancelledWithEvent:event];
}

- (void)keyUp:(NSEvent *)theEvent
{
}

- (void)keyDown:(NSEvent *)theEvent
{
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    ;
}


- (void)scrollWheel:(NSEvent *)theEvent
{
    [webview[0] scrollWheel:theEvent];
}
@end
