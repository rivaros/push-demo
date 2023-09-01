#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>

@implementation AppDelegate

- (NSData *)dataFromHexString:(NSString *)hexString {
    NSCharacterSet *hexCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
    NSString *cleanedHexString = [[hexString componentsSeparatedByCharactersInSet:[hexCharacterSet invertedSet]] componentsJoinedByString:@""];

    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:cleanedHexString.length / 2];
    for (int i = 0; i < cleanedHexString.length; i += 2) {
        NSString *byteString = [cleanedHexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [NSScanner scannerWithString:byteString];
        unsigned int byteValue;
        [scanner scanHexInt:&byteValue];
        [data appendBytes:&byteValue length:1];
    }

    return data;
}

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
      dispatch_async(dispatch_get_main_queue(), ^{
          [application registerForRemoteNotifications];
      });
    } else {
      NSLog(@"DEMO: Permission was not granted: %@", error.description);
    }
  }];
  
//  NSMutableDictionary *modifiedLaunchOptions = [NSMutableDictionary dictionaryWithDictionary:launchOptions];
//  if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
//    NSDictionary *pushContent = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (pushContent[@"react-deep-link"] || pushContent[@"ab_uri"]) {
//      NSString *initialURL = pushContent[@"react-deep-link"] ? pushContent[@"react-deep-link"] : pushContent[@"ab_uri"];
//      if (!launchOptions[UIApplicationLaunchOptionsURLKey]) {
//        modifiedLaunchOptions[UIApplicationLaunchOptionsURLKey] = [NSURL URLWithString:initialURL];
//      }
//    }
//  }
  

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


// Conversion function
- (void)application:(UIApplication *)application
  didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  const unsigned char *tokenBytes = (const unsigned char*)[deviceToken bytes];
  NSMutableString *hexToken = [NSMutableString stringWithCapacity:(deviceToken.length * 2)];
  
  for (NSUInteger i = 0; i < deviceToken.length; i++) {
      [hexToken appendFormat:@"%02x", tokenBytes[i]];
  }
  NSLog(@"Demo: registered token: %@", hexToken);
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

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
  // Get the content of the received notification
  UNNotificationContent *notificationContent = response.notification.request.content;
  // Extract the user info of the notification
  NSDictionary *userInfo = notificationContent.userInfo;

  if (userInfo[@"CIO"]) {
    NSLog(@"CIO push taped");
  }

  if (userInfo[@"ab"]) {
    NSLog(@"Braze push taped");
  }

  completionHandler();
}


@end
