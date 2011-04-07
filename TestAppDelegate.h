
#import <UIKit/UIKit.h>

@class TestViewController;

@interface TestAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TestViewController *viewController;

@end
