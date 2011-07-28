

#import "DemoAppDelegate.h"
#import "DemoViewController.h"


@implementation DemoAppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  
  DemoViewController *vc = [[[DemoViewController alloc] init] autorelease];
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
  
  self.window.rootViewController = navigationController;
  [self.window makeKeyAndVisible];
  
  return YES;
}


- (void)dealloc
{
  [window release];
  [navigationController release];
  [super dealloc];
}

@end