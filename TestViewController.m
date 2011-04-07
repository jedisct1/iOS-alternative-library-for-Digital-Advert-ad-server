
#import "TestViewController.h"

@implementation TestViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void) enableAds
{
    CGRect adFrame = CGRectMake(0, self.view.frame.size.height - kADS_MINI_BANNER_HEIGHT,
                                self.view.frame.size.width, kADS_MINI_BANNER_HEIGHT);
    simpleAdView = [[SimpleAdView alloc] initWithFrame: adFrame];    
    simpleAdView.controller = self;
    [self.view addSubview: simpleAdView];
    
//    
// In order to switch to a pageId, just call: [simpleAdView load: @"xxxx"]
//
        
    [simpleAdView release];
}

- (void)viewDidLoad
{
    [self enableAds];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
