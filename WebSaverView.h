//
//  WebSaverView.h
//  WebSaver
//
//  Created by Dustin Sallings on 2008/12/11.
//  Copyright (c) 2008, Dustin Sallings <dustin@spy.net>. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <WebKit/WebKit.h>
#import "RSWebView.h"
@interface WebSaverView : ScreenSaverView 
{
    IBOutlet id configSheet;
    IBOutlet NSTextField *urlField0;
    IBOutlet NSTextField *urlField1;
    IBOutlet NSTextField *urlField2;
    IBOutlet NSTextField *urlField3;
    IBOutlet NSSlider *refreshSlider;
    IBOutlet NSTextField *refreshLabel;

    IBOutlet NSButton *userAgentCheckBtn;
    NSString *url[4];
    int refresh;
    NSNumber *WSVUserAgent;
    RSWebView *webview[4];
}
- (NSString *)userAgent;
- (IBAction) changedRefresh:(id) sender;
- (IBAction) closeSheetSave:(id) sender;
- (IBAction) closeSheetCancel:(id) sender;

@end
