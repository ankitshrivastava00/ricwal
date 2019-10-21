package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.example.flutterplacesdialog.FlutterPlacesDialogPlugin;
import io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin;
import com.theantimony.googleplacespicker.GooglePlacesPickerPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import in.appyflow.paytm.PaytmPlugin;
import com.hashbnm.razorpayplugin.RazorpayPlugin;
import io.flutter.plugins.share.SharePlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import np.com.sarbagyastha.youtubeplayer.YoutubePlayerPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterPlacesDialogPlugin.registerWith(registry.registrarFor("com.example.flutterplacesdialog.FlutterPlacesDialogPlugin"));
    FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
    GooglePlacesPickerPlugin.registerWith(registry.registrarFor("com.theantimony.googleplacespicker.GooglePlacesPickerPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PaytmPlugin.registerWith(registry.registrarFor("in.appyflow.paytm.PaytmPlugin"));
    RazorpayPlugin.registerWith(registry.registrarFor("com.hashbnm.razorpayplugin.RazorpayPlugin"));
    SharePlugin.registerWith(registry.registrarFor("io.flutter.plugins.share.SharePlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    YoutubePlayerPlugin.registerWith(registry.registrarFor("np.com.sarbagyastha.youtubeplayer.YoutubePlayerPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
