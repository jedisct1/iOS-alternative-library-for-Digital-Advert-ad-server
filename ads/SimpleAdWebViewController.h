//
//  SimpleAdWebViewController.h
//  simpleAdView
//
//  Created by Frank Denis on 29/01/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SimpleAdWebViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;
	NSURL *uri;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSURL *uri;

- (IBAction) doneButtonPushed;

@end
