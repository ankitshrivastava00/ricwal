#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"
@import Firebase;
#import <flutter_local_notifications/FlutterLocalNotificationsPlugin.h>
@import GooglePlaces;
@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // Provide the GoogleMaps API key.
    NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"AIzaSyBbALORzgs8kCrfy9PNn3gZ_nqiEJqwmFw"];
    if ([mapsApiKey length] == 0) {
        mapsApiKey = @"AIzaSyBbALORzgs8kCrfy9PNn3gZ_nqiEJqwmFw";
    }
    [GMSServices provideAPIKey:mapsApiKey];
    [GMSPlacesClient provideAPIKey:mapsApiKey];
    [FIRApp configure];
    // cancel old notifications that were scheduled to be periodically shown upon a reinstallation of the app
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"]){
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Notification"];
    }
    // Register Flutter plugins.
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
