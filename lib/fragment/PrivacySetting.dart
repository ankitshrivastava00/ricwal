import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/activity/drawer.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySetting extends StatefulWidget {
  @override
  PrivacySettingState createState() => PrivacySettingState();
}

class PrivacySettingState extends State<PrivacySetting> {

  Future<bool> _onBackPressed() {

    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => HomePage(0)));
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new WillPopScope(
        onWillPop: _onBackPressed,
    child: Scaffold(
        body: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20,),
                Text('PRIVACY PLOCY',
                  style: TextStyle(fontSize: 25, color: Colors.green),
                  textAlign: TextAlign.center,),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green)
                        ),
                        width: 50,

                      ),
                      SizedBox(width: 5),
                      Text('OUR POLICY', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green)
                        ),
                        width: 50,
                      ),
                    ]
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'This privacy policy discloses the privacy practices for www.ricwal.com This privacy policy applies solely to information collected by this web site. It will notify you of the following: What personally identifiable information is collected from you through the web site, how it is used and with whom it may be shared. What choices are available to you regarding the use of your data. The security procedures in place to protect the misuse of your information. How you can correct any inaccuracies in the information. Information Collection, Use, and Sharing We are the sole owners of the information collected on this site. We only have access to/collect information that you voluntarily give us via email or other direct contact from you. We will not sell or rent this information to anyone. We will use your information to respond to you, regarding the reason you contacted us. We will not share your information with any third party outside of our organization, other than as necessary to fulfill your request, e.g. to ship an order. Unless you ask us not to, we may contact you via email in the future to tell you about specials, new products or services, or changes to this privacy policy. Your Access to and Control Over Information You may opt out of any future contacts from us at any time. You can do the following at any time by contacting us via the email address or phone number given on our website: • See what data we have about you, if any. • Change/correct any data we have about you. • Have us delete any data we have about you. • Express any concern you have about our use of your data. Security We take precautions to protect your information. When you submit sensitive information via the website, your information is protected both online and offline. Wherever we collect sensitive information (such as credit card data), that information is encrypted and transmitted to us in a secure way. You can verify this by looking for a closed lock icon at the bottom of your web browser, or looking for "https" at the beginning of the address of the web page. While we use encryption to protect sensitive information transmitted online, we also protect your information offline. Only employees who need the information to perform a specific job (for example, billing or customer service) are granted access to personally identifiable information. The computers/servers in which we store personally identifiable information are kept in a secure environment. Updates Our Privacy Policy may change from time to time and all updates will be posted on this page. If you feel that we are not abiding by this privacy policy, you should contact us immediately via telephone at 9591670072 or via email.',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),

                )
              ],
            )

        )

    ));
  }
}
