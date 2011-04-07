
#import "SimpleAdWebViewController.h"

@implementation SimpleAdWebViewController

@synthesize webView;
@synthesize activityIndicator;
@synthesize uri;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(doneButtonPushed) name: @"ext_url_load" object: nil];
    webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: uri];
	[webView loadRequest: request];
	[request release];
}

- (void)forceClose {
	[[NSNotificationCenter defaultCenter] postNotificationName: @"ext_url_load" object: nil];	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"> %s %@", __FUNCTION__, [error localizedDescription]);
	activityIndicator.hidden = YES;
	[NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector:@selector(forceClose) userInfo: nil repeats: NO];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[aRequest URL] absoluteString];
	NSMutableArray *components = [[[requestString componentsSeparatedByString:@":"] mutableCopy] autorelease];
	
	if ([components count] <= 1) {
		return YES;
	}
	NSString *protocol = (NSString *)[[components objectAtIndex:0] copy];
	[components removeObjectAtIndex:0];
	[protocol autorelease];
    
	if (([protocol caseInsensitiveCompare: @"http"] == NSOrderedSame ||
		 [protocol caseInsensitiveCompare: @"https"] == NSOrderedSame)) {
		return YES;
	}
    activityIndicator.hidden = YES;
	[[UIApplication sharedApplication] openURL: aRequest.URL];
	
	[NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector:@selector(forceClose) userInfo: nil repeats: NO];
	
	return NO;    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
	activityIndicator.hidden = YES;
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

@end
