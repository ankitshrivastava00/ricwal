//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <connectivity/ConnectivityPlugin.h>
#import <firebase_messaging/FirebaseMessagingPlugin.h>
#import <flutter_local_notifications/FlutterLocalNotificationsPlugin.h>
#import <flutter_places_dialog/FlutterPlacesDialogPlugin.h>
#import <fluttertoast/FluttertoastPlugin.h>
#import <google_places_picker/GooglePlacesPickerPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <paytm/PaytmPlugin.h>
#import <razorpay_plugin/RazorpayPlugin.h>
#import <share/SharePlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <sqflite/SqflitePlugin.h>
#import <youtube_player/YoutubePlayerPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTConnectivityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTConnectivityPlugin"]];
  [FLTFirebaseMessagingPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseMessagingPlugin"]];
  [FlutterLocalNotificationsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterLocalNotificationsPlugin"]];
  [FlutterPlacesDialogPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterPlacesDialogPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [GooglePlacesPickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"GooglePlacesPickerPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PaytmPlugin registerWithRegistrar:[registry registrarForPlugin:@"PaytmPlugin"]];
  [RazorpayPlugin registerWithRegistrar:[registry registrarForPlugin:@"RazorpayPlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [YoutubePlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"YoutubePlayerPlugin"]];
}

@end
