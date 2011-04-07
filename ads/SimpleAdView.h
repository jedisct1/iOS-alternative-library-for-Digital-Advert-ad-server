
#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "SimpleAd.h"
#import "SimpleAdWebViewController.h"

#define kADS_MINI_BANNER_HEIGHT 20.F
#define kADS_EXTENDED_BANNER_HEIGHT 50.F

@interface SimpleAdView : UIView <NSXMLParserDelegate> {
	ASINetworkQueue *networkQueue;
	NSMutableDictionary *simpleAds;
	UIButton *bannerButton;
	UIButton *extendedBannerButton;
	CGRect miniFrame;
	BOOL isExtended;
	NSTimer *initialTimer;
	NSTimer *activateAdTimer;
	NSTimer *delayedLoadTimer;
	UIViewController *controller;
	SimpleAd *currentAd;
	NSString *wantedPageId;
	NSMutableArray *loadQueue;
}

@property (nonatomic, retain) UIViewController *controller;

- (void) load: (NSString *) pageId;

@end
