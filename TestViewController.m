
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
// In order to set the current pageId, just call: [simpleAdView load: @"xxxx"]
//
        
    [simpleAdView release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame: [[UIScreen mainScreen] bounds]];
    [super viewDidAppear: animated];
}

- (void)viewDidLoad
{
    [self.view setFrame: [[UIScreen mainScreen] bounds]];
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
