#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"PushDemoProject";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  
  [UNUserNotificationCenter currentNotificationCenter].delegate = self;
  UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
  [[UNUserNotificationCenter currentNotificationCenter]
   requestAuthorizationWithOptions:authOptions
   completionHandler:^(BOOL granted, NSError * _Nullable error) {
    NSLog(@"DEMO: Permission check");
    if (granted) {
      NSLog(@"DEMO: Permission was granted");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[UIApplication sharedApplication] registerForRemoteNotifications];
//        });
    } else {
      NSLog(@"DEMO: Permission was not granted: %@", error.description);
    }
  }];
  

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
  // Get the content of the received notification
  UNNotificationContent *notificationContent = notification.request.content;
  // Extract the user info of the notification
  NSDictionary *userInfo = notificationContent.userInfo;

  // Braze
  if (@available(iOS 14.0, *)) {
    if (userInfo[@"aps"][@"mutable-content"]) {
      completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner);
    } else {
      completionHandler(UNNotificationPresentationOptionAlert);
    }
  } else {
    completionHandler(UNNotificationPresentationOptionAlert);
  }
}


@end
