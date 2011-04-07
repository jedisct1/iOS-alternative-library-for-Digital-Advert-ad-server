
#import "SimpleAdView.h"
#import "ASIHTTPRequest.h"
#import "URINSStringAdditions.h"

#define kADIT_BASE_URL @"http://adit.ldmobile.net/getInventory.php"

@implementation SimpleAdView

@synthesize controller;

- (void) miniBannerTouched: (UIButton *) button {
	[initialTimer invalidate];
	[UIView beginAnimations: nil context: nil];	
	if (initialTimer != nil) {
		[UIView setAnimationDuration: 1.5F];
	} else {
		[UIView setAnimationDuration: 0.5F];
	}
	initialTimer = nil;
	if (isExtended == NO) {
		self.frame = CGRectMake(miniFrame.origin.x, miniFrame.origin.y - kADS_EXTENDED_BANNER_HEIGHT, miniFrame.size.width, miniFrame.size.height + kADS_EXTENDED_BANNER_HEIGHT);
		isExtended = YES;
	} else {
		self.frame = miniFrame;
		isExtended = NO;
	}
	[UIView commitAnimations];
}

- (void) extendedBannerTouched: (UIButton *) button {
	if (currentAd == nil || currentAd.redirectionUrl == nil) {
		NSLog(@"No redirection");
		return;
	}
	SimpleAdWebViewController *adWebViewController = [[SimpleAdWebViewController alloc] initWithNibName: @"SimpleAdWebViewController" bundle: [NSBundle mainBundle]];
	adWebViewController.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
	adWebViewController.wantsFullScreenLayout = YES;
	adWebViewController.hidesBottomBarWhenPushed = YES;

	NSURL *uri = [[NSURL alloc] initWithString: currentAd.redirectionUrl];	
	adWebViewController.uri = uri;
	[uri release];
	[controller presentModalViewController: adWebViewController animated: YES];
	[adWebViewController release];
}

- (void) initialDown {
	if (isExtended == YES) {
		[self miniBannerTouched: nil];
	}
	initialTimer = nil;
}

- (void) switchToAd: (SimpleAd *) ad {
	if (ad == nil || ad.bannerId == nil || ad.bannerImage == nil || ad.extendedBannerImage == nil) {
		return;
	}
	if (currentAd == nil) {	
		[bannerButton setImage: ad.bannerImage forState: UIControlStateNormal];
		[bannerButton setImage: ad.bannerImage forState: UIControlStateHighlighted];
		[extendedBannerButton setImage: ad.extendedBannerImage forState: UIControlStateNormal];
	} else {
		if ([currentAd.bannerUrl isEqualToString: ad.bannerUrl] != 0 &&
			[currentAd.extendedBannerUrl isEqualToString: ad.extendedBannerUrl] != 0 &&
			[currentAd.redirectionUrl isEqualToString: ad.redirectionUrl] != 0) {
			return;
		}
		UIButton *newBannerButton = [UIButton buttonWithType: UIButtonTypeCustom];
		newBannerButton.frame = bannerButton.frame;
		newBannerButton.opaque = YES;
		newBannerButton.alpha = bannerButton.alpha;
		UIButton *newExtendedBannerButton = [UIButton buttonWithType: UIButtonTypeCustom];
		newExtendedBannerButton.frame = extendedBannerButton.frame;
		newExtendedBannerButton.opaque = YES;
		newExtendedBannerButton.alpha = extendedBannerButton.alpha;
		[newBannerButton setImage: ad.bannerImage forState: UIControlStateNormal];
		[newBannerButton setImage: ad.bannerImage forState: UIControlStateHighlighted];
		[newExtendedBannerButton setImage: ad.extendedBannerImage forState: UIControlStateNormal];
		[UIView beginAnimations: nil context: nil];
		[UIView setAnimationDuration: 2.0];
		[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView: self cache: TRUE];
		[bannerButton removeFromSuperview];
		[self addSubview: newBannerButton];	
		[extendedBannerButton removeFromSuperview];
		[self addSubview: newExtendedBannerButton];
		bannerButton = newBannerButton;
		extendedBannerButton = newExtendedBannerButton;
		[UIView commitAnimations];
		[bannerButton addTarget: self action: @selector(miniBannerTouched:) forControlEvents: UIControlEventTouchDown];
		[extendedBannerButton addTarget: self action: @selector(extendedBannerTouched:) forControlEvents: UIControlEventTouchUpInside];
		[currentAd release];        
	}
	currentAd = ad;
	currentAd = [ad retain];
}

- (void) activateAd: (SimpleAd *) ad {
	if (currentAd == ad || ![ad.pageId isEqualToString: wantedPageId] || [currentAd.pageId isEqualToString:wantedPageId]) {
		return;
	}
	if (currentAd != nil) {
		[self switchToAd: ad];
		return;
	}
	if (ad.bannerId == nil || ad.bannerImage == nil || ad.extendedBannerImage == nil || ad.redirectionUrl == nil) {
		return;
	}
	self.clipsToBounds = YES;	
	bannerButton = [UIButton buttonWithType: UIButtonTypeCustom];	
	bannerButton.frame = CGRectMake(0.0F, 0.0F, self.frame.size.width, kADS_MINI_BANNER_HEIGHT);
	bannerButton.opaque = YES;
	bannerButton.alpha = 0.0F;	
	extendedBannerButton = [UIButton buttonWithType: UIButtonTypeCustom];
	extendedBannerButton.frame = CGRectMake(0.0F, kADS_MINI_BANNER_HEIGHT, self.frame.size.width, kADS_EXTENDED_BANNER_HEIGHT);
	extendedBannerButton.opaque = YES;
	extendedBannerButton.alpha = 0.0F;
	[self switchToAd: ad];
	[self addSubview: bannerButton];
	[self addSubview: extendedBannerButton];
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:1.0F];
	self.frame = CGRectMake(miniFrame.origin.x, miniFrame.origin.y - kADS_EXTENDED_BANNER_HEIGHT, miniFrame.size.width, miniFrame.size.height + kADS_EXTENDED_BANNER_HEIGHT);
	[UIView setAnimationDuration:3.0F];
	bannerButton.alpha = 1.0F;
	[UIView setAnimationDuration:2.0F];
	extendedBannerButton.alpha = 1.0F;	
	[UIView commitAnimations];
	[bannerButton addTarget: self action: @selector(miniBannerTouched:) forControlEvents: UIControlEventTouchDown];
	[extendedBannerButton addTarget: self action: @selector(extendedBannerTouched:) forControlEvents: UIControlEventTouchUpInside];
	isExtended = YES;
	initialTimer = [NSTimer scheduledTimerWithTimeInterval: 4.0F target: self selector: @selector(initialDown) userInfo: nil repeats: NO];
}

- (void) delayedActivateAd: (NSTimer *) timer {
	activateAdTimer = nil;
	[self activateAd: timer.userInfo];
}

- (void) bannerLoadDone: (ASIHTTPRequest *) request {
	SimpleAd *ad = (SimpleAd *) request.userInfo;
	ad.bannerImage = [[UIImage alloc] initWithData: [request responseData]];
	if (ad.bannerImage != nil && ad.extendedBannerImage != nil) {
		[self activateAd: ad];
	}
}

- (void) extendedBannerLoadDone: (ASIHTTPRequest *) request {
	SimpleAd *ad = (SimpleAd *) request.userInfo;
	UIImage *image = [[UIImage alloc] initWithData: [request responseData]];
	ad.extendedBannerImage = image;
	if (ad.bannerImage != nil && ad.extendedBannerImage != nil) {
		[self activateAd: ad];
	}
}

- (void) bannersLoaded: (ASINetworkQueue *) queue {

}

- (void) XMLLoadDone: (ASIHTTPRequest *) request {
	SimpleAd *ad = (SimpleAd *) request.userInfo;
	NSData *response = [request responseData];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData: response];
	parser.delegate = ad;
	parser.shouldProcessNamespaces = NO;
	parser.shouldReportNamespacePrefixes = NO;
	parser.shouldResolveExternalEntities = NO;
	[parser parse];
	[parser release];
	if (ad.bannerUrl == nil || ad.extendedBannerUrl == nil || ad.redirectionUrl == nil) {
		return;
	}
	ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: ad.bannerUrl]];
	request1.delegate = self;
	request1.userInfo = (id) ad;
	request1.didFinishSelector = @selector(bannerLoadDone:);
	[request1 setQueuePriority: NSOperationQueuePriorityLow]; 
	[networkQueue addOperation: request1];
	ASIHTTPRequest *request2 = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: ad.extendedBannerUrl]];
	request2.delegate = self;
	request2.userInfo = (id) ad;	
	request2.didFinishSelector = @selector(extendedBannerLoadDone:);
	[request2 setQueuePriority: NSOperationQueuePriorityLow];	
	[networkQueue addOperation: request2];
	networkQueue.delegate = self;
	networkQueue.queueDidFinishSelector = @selector(bannersLoaded:);
	[networkQueue setMaxConcurrentOperationCount: 1];
	
	[networkQueue go];
}

- (void) delayedLoad: (NSString *) pageId {
	SimpleAd *ad = [[SimpleAd alloc] init];
	ad.pageId = pageId;
	[simpleAds setValue: ad forKey: pageId];
	[ad release];	
	NSLocale *currentLocale = [NSLocale currentLocale];
	NSString *lang = [currentLocale objectForKey: NSLocaleLanguageCode];
	NSString *country = [currentLocale objectForKey: NSLocaleCountryCode];	
	NSString *rawuri = [[NSString alloc] initWithFormat: kADIT_BASE_URL @"?extended=1&banner_format=auto&register_stats=1&page_id=%@&mob_ua=%@&lang=%@&country=%@", [pageId urlEncode], @"IPHONE", [lang urlEncode], [country urlEncode]];
	NSLog(@"Loading ad: [%@]", rawuri);
	NSURL *url = [[NSURL alloc] initWithString: rawuri];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: url];
	[url release];
	[rawuri release];
	request.delegate = self;
	request.userInfo = (id) ad;
	request.didFinishSelector = @selector(XMLLoadDone:);
	[networkQueue addOperation: request];
	[networkQueue go];	
}

- (void) loadObjectsFromQueue {
	delayedLoadTimer = nil;
	if ([loadQueue count] <= 0U) {
		return;
	}
	NSString *pageId = [loadQueue lastObject];
	[loadQueue removeLastObject];
	[self delayedLoad: pageId];
	[NSTimer scheduledTimerWithTimeInterval: 0.1F target: self selector: @selector(loadObjectsFromQueue) userInfo: nil repeats: NO];
}

- (void) load: (NSString *) pageId {
	wantedPageId = pageId;
	[loadQueue addObject: wantedPageId];
	[delayedLoadTimer invalidate];
	delayedLoadTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0F target: self selector: @selector(loadObjectsFromQueue) userInfo: nil repeats: NO];	

	SimpleAd *ad = [simpleAds objectForKey: pageId];
	if (ad != nil) {		
		[activateAdTimer invalidate];
		activateAdTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0F target: self selector: @selector(delayedActivateAd:) userInfo: ad repeats: NO];
	}
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame: frame])) {
		return nil;
    }
	self.opaque = YES;
	self.backgroundColor = [UIColor clearColor];
	simpleAds = [[NSMutableDictionary alloc] init];
	networkQueue = [[ASINetworkQueue queue] retain];
	networkQueue.shouldCancelAllRequestsOnFailure = NO;
	bannerButton = extendedBannerButton = nil;
	miniFrame = self.frame;
	isExtended = NO;
	initialTimer = nil;
	activateAdTimer = nil;
	delayedLoadTimer = nil;
	currentAd = nil;
	wantedPageId = nil;
	loadQueue = [[NSMutableArray alloc] init];
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	
}

- (void)dealloc {
	[networkQueue cancelAllOperations];
	[networkQueue release];
	networkQueue = nil;
	[simpleAds release];
	simpleAds = nil;
	[initialTimer invalidate];
	initialTimer = nil;
	[activateAdTimer invalidate];
	activateAdTimer = nil;
	[delayedLoadTimer invalidate];
	delayedLoadTimer = nil;
	[loadQueue release];
	loadQueue = nil;
    [super dealloc];
}

@end
