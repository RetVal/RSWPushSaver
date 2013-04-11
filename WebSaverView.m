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

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self)
    {
    	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.retval.RSWPushSaver"];
        [defaults registerDefaults:@{@"url": @"http://www.weibo.com", @"refresh":[NSNumber numberWithInt:0]}];
        url = [defaults valueForKey: @"url"];
        refresh = [defaults integerForKey: @"refresh"];
        webview = [[RSWebView alloc] initWithFrame:[self bounds] frameName:@"main" groupName:@"main"];
        [self addSubview:webview];

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
    
    [[webview mainFrame] loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:url]]];
    
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
    [webview reload:self];
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

    [urlField setStringValue:url];
    [refreshSlider setIntValue:refresh];
    [self changedRefresh: refreshSlider];

	return configSheet;
}

// Called when the user clicked the SAVE button
- (IBAction) closeSheetSave:(id) sender
{
    // get the defaults
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.retval.RSWPushSaver"];
	
	// write the defaults
    url = [urlField stringValue];
	[defaults setValue:url forKey:@"url"];
    [defaults setInteger:[refreshSlider intValue] forKey:@"refresh"];
	
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
    [webview scrollWheel:theEvent];
}
@end
