
#import "SimpleAdWebViewController.h"

@implementation SimpleAdWebViewController

@synthesize webView;
@synthesize activityIndicator;
@synthesize uri;

- (void)viewDidLoad {
    [super viewDidLoad];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: uri];
	[webView loadRequest: request];
	[request release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	webView.delegate = nil;	
	[webView release];
	webView = nil;
	[activityIndicator release];
	activityIndicator = nil;	
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	UIApplication *app = [UIApplication sharedApplication];
	SEL appSelector = NSSelectorFromString(@"setStatusBarHidden:withAnimation:");
	BOOL hide = YES;
	BOOL anim = YES;
	
	if (![app respondsToSelector:appSelector]) {
		appSelector = NSSelectorFromString(@"setStatusBarHidden:animated:");
	}
	
	if ([app respondsToSelector:appSelector]) {
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[app methodSignatureForSelector:appSelector]];
		[invocation setSelector:appSelector];
		[invocation setArgument:(void *)&hide atIndex:2];
		[invocation setArgument:(void *)&anim atIndex:3];
		[invocation invokeWithTarget:app];
	}
	
	[super viewWillAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	UIApplication *app = [UIApplication sharedApplication];
	
	webView.delegate = nil;

	SEL appSelector = NSSelectorFromString(@"setStatusBarHidden:withAnimation:");
	BOOL hide = NO;
	BOOL anim = YES;
	
	if (![app respondsToSelector:appSelector]) {
		appSelector = NSSelectorFromString(@"setStatusBarHidden:animated:");
	}
	
	if ([app respondsToSelector:appSelector]) {
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[app methodSignatureForSelector:appSelector]];
		[invocation setSelector:appSelector];
		[invocation setArgument:(void *)&hide atIndex:2];
		[invocation setArgument:(void *)&anim atIndex:3];
		[invocation invokeWithTarget:app];
	}
	
	[super viewWillDisappear: animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear: animated];
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction) doneButtonPushed {
	[self dismissModalViewControllerAnimated: YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
	activityIndicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	activityIndicator.hidden = YES;
}

@end
