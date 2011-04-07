
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
