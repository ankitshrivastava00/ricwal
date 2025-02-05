import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:paytm/paytm.dart';
import 'package:razorpay_plugin/razorpay_plugin.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:razorpay_plugin/razorpay_plugin.dart';
import 'package:ricwala_application/comman/Connectivity.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/fragment/ThankYou.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CheckOutPgae extends StatefulWidget {
  String total, discount, paid,coupncode,productid,productname,productprice,productquantity;
  CheckOutPgae(this.total, this.discount, this.paid,this.coupncode,this.productid,this.productname,this.productprice
      ,this.productquantity);

  @override
  CheckOutPgaeState createState() => CheckOutPgaeState();

}

class CheckOutPgaeState extends State<CheckOutPgae> {
  TextEditingController em = new TextEditingController();
  TextEditingController land = new TextEditingController();
  TextEditingController pin = new TextEditingController();
   String radiovalue = "",address="",checksum="";
  String reply;
  DBProvider db ;


  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    _add();
  }

  Future  checkout(_context) async {

    if(em.text.isEmpty){
      Fluttertoast.showToast(
          msg: "Please Enter Address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }else if(land.text.isEmpty){
      Fluttertoast.showToast(
          msg: "Please Enter lanmark",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }else if(pin.text.isEmpty){
      Fluttertoast.showToast(
          msg: "Please Enter Pincode",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }else{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map map = {
        "userid": '${prefs.getString('_id').toString()}',
        "coupancode": '${widget.coupncode}',
        "totalamount": '${widget.total}',
        "discountamount": '${widget.discount}',
        "paidamount": '${widget.paid}',
        "address": '${em.text}',
        "landmark": '${land.text}',
        "pincode": '${pin.text}',
        "paymentmode": '${radiovalue}',
        "productid": '${widget.productid}',
        "productname": '${widget.productname}',
        "productPrice": '${widget.productprice}',
        // "productQuantity": '[${widget.productquantity}]',
      };
      placeOrder(Constants.PLACEORDR_URL, map, _context);
    }

   }

  Future<String> placeOrder(String url, Map jsonMap, _context) async {
    try {
      CustomProgressLoader.showLoader(_context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['response'].toString();

      CustomProgressLoader.cancelLoader(_context);

      if (status == "success") {
        DBProvider.db.deleteAll();
        setState(() {});
        Fluttertoast.showToast(
            msg: "Order Placed Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pushReplacement(
            _context,
            new MaterialPageRoute(
                builder: (BuildContext context) => ThankYou()));
      }
    }
    /*else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: "Please check your internet connection....!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        // ToastWrap.showToast("Please check your internet connection....!");
        // return response;
      }
    }*/
    catch (e) {
      CustomProgressLoader.cancelLoader(context);
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return reply;
    }
  }


  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index){
      return rand.nextInt(33)+89;
    }
    );
  }

  void testingCheckSum(double amount,_context) async {
    var uniq = _randomString(10);

    var url = 'https://us-central1-mrdishant-4819c.cloudfunctions.net/generateCheckSum';
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    //Please use your parameters here
    //CHANNEL_ID etc provided to you by paytm

    final response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "mid": "ParloS79006455919746",
      "CHANNEL_ID": "WAP",
      'INDUSTRY_TYPE_ID': 'Retail',
      'WEBSITE': 'APPSTAGING',
      'PAYTM_MERCHANT_KEY': '380W#7mf&_SpEgsy',
      'TXN_AMOUNT': amount.toString(),
      'ORDER_ID': orderId,
      'CUST_ID': '122',
    });

    //for Testing(Stagging) use this

    //https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=

    //https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=

    String callBackUrl = 'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=' +
            orderId;

    print("Response :" + response.body);

    var paytmResponse = Paytm.startPaytmPayment(
        true,
        "ParloS79006455919746",
        orderId,
        "122",
        "WAP",
        amount.toString(),
        'APPSTAGING',
        callBackUrl,
        'Retail',
        response.body);

    paytmResponse.then((value) {
      setState(() {
        if(value["STATUS"] == "TXN_SUCCESS"){
          Fluttertoast.showToast(
              msg: "Payment Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
            checkout(context);
        }else{
          Fluttertoast.showToast(
              msg: "Payment Cancel",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    });

  }


  startPayment(double amount, _context) async {
    var uniq = _randomString(10);
    //   var isConnect = await ConnectionDetector.isConnected();
    double finalTotal = amount * 100.0;
    Map<String, dynamic> options = new Map();
    options.putIfAbsent("name", () => "Ricwal");
    options.putIfAbsent(
        "image", () => "https://www.73lines.com/web/image/12427");
    options.putIfAbsent("description", () => "Order Id : ${uniq}");
    options.putIfAbsent("amount", () => "${finalTotal}");
    //  options.putIfAbsent("amount", () => "${finalTotal}");
    options.putIfAbsent("email", () => "ankit.shrivastava00@gmail.com");
    options.putIfAbsent("contact", () => "9713172282");
    //Must be a valid HTML color.
    options.putIfAbsent("theme", () => "#FF0000");
    //Notes -- OPTIONAL
    Map<String, String> notes = new Map();
    notes.putIfAbsent('key', () => "value");
    notes.putIfAbsent('randomInfo', () => "haha");
    options.putIfAbsent("notes", () => notes);
    options.putIfAbsent("api_key", () => "rzp_live_jvB6dYPSWVYnEp");
    Map<dynamic, dynamic> paymentResponse = new Map();
    paymentResponse = await Razorpay.showPaymentForm(options);
    print("response $paymentResponse");
    String code = paymentResponse['code'];
    String message = paymentResponse['message'];
    if (code == '0') {
      Fluttertoast.showToast(
          msg: "Payment Cancel",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Payment Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      checkout(context);
    }

    /*  }else{
      Fluttertoast.showToast(
          msg: "Please check your internet connection....!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }*/
  }


  void generateCheckSum(double amount,_context, String oid) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String callBackUrl = 'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID='+oid;

    var paytmResponse = Paytm.startPaytmPayment(
        false,
        "RaFOBK52746125419588",
         oid,
        "${prefs.getString('_id').toString()}",
        "WAP",
        amount.toString(),
        'DEFAULT',
        callBackUrl,
        'Retail',
        checksum);


    paytmResponse.then((value) {
      setState(() {
        Fluttertoast.showToast(
            msg: value.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);      });
    });

  /*  paytmResponse.then((value) {
      Fluttertoast.showToast(
          msg: value.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        if(value["STATUS"] == "TXN_SUCCESS"){
          Fluttertoast.showToast(
              msg: "Payment Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          checkout(context);
        }else{
          Fluttertoast.showToast(
              msg: "Payment Cancel",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    });*/

  }


  Future<String> apiCallForUserProfile(String url, Map jsonMap) async {
    CustomProgressLoader.showLoader(context);
 //   var isConnect = await ConnectionDetector.isConnected();
  //  if (isConnect) {
      try {
        HttpClient httpClient = new HttpClient();
        HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.add(utf8.encode(json.encode(jsonMap)));
        HttpClientResponse response = await request.close();
        // todo - you should check the response.statusCode
        reply = await response.transform(utf8.decoder).join();
        httpClient.close();
        Map data = json.decode(reply);
        String status = data['response'];

        print('RESPONCE_DATA : '+status);
        CustomProgressLoader.cancelLoader(context);
//sh95467091
        if (status == "success") {
          DBProvider.db.deleteAll();
          Fluttertoast.showToast(
              msg: "Order Succesfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pushReplacement(context
              ,new MaterialPageRoute(builder: (BuildContext context) => ThankYou()));
          return reply;
        } else   if (status == "unsuccess") {
          Fluttertoast.showToast(
              msg: "Incorrect Mobile And Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          return reply;
        } else {
          Fluttertoast.showToast(
              msg: "Incorrect Mobile And Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          return  reply;
        }

      } catch (e) {
        print(e);
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        return reply;
      }

   /* } else {
      CustomProgressLoader.cancelLoader(context);
      Fluttertoast.showToast(
          msg: "Please check your internet connection....!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return reply;
    }*/
  }


  Future<String>findChecksum(String url, Map jsonMap,String oid) async {
    try {
      CustomProgressLoader.showLoader(context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['status'].toString();
      CustomProgressLoader.cancelLoader(context);
      double pd = double.parse('${widget.paid}');

      if(status == "success"){
        setState(() {
          checksum = data['checksum'].toString();
          Fluttertoast.showToast(
              msg: checksum,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          generateCheckSum(pd, context,oid);
        });
      }
    }
    /*else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: "Please check your internet connection....!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        // ToastWrap.showToast("Please check your internet connection....!");
        // return response;
      }
    }*/
    catch (e) {
      CustomProgressLoader.cancelLoader(context);
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return reply;
    }
  }


  Future<String> add(String url, Map jsonMap) async {
    try {
      CustomProgressLoader.showLoader(context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['status'].toString();
      CustomProgressLoader.cancelLoader(context);

      if (status == "200") {
        var details=data['result'];
        String address = details['address'].toString();
        String landmark = details['landmark'].toString();
        String pincode = details['pincode'].toString();
        em.text = address;
        land.text = landmark ;
        pin.text = pincode ;
      } else {
        Fluttertoast.showToast(
            msg: "Try Again Some Thing Is Wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    catch (e) {
      CustomProgressLoader.cancelLoader(context);
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return reply;
    }
  }


 Future _add() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   Map map = {"id": prefs.getString('_id').toString()};
   add(Constants.ADDRESS_URL, map);
 }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text("Check Out"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
                alignment: Alignment.topLeft,
                child: new Text(
                  'Your Bill :',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                 ),
              ),
              new Container(
                  child: new Card(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Total Amount :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 50.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            "Rs."
                            '${widget.total}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.green,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Discount Amount :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 50.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            "Rs."
                            '${widget.discount}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.green,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Paid Amount :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 50.0, 5.0),
                          alignment: Alignment.topLeft,
                          child: new Text("Rs."
                             '${widget.paid}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.green,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 2.0, 50.0, 2.0),
                alignment: Alignment.topLeft,
                child: new Text(
                  "Enter Address",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 10.0),
                child: new TextField(
                  controller: em,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Address For Delievery',
                    labelStyle:
                        theme.textTheme.caption.copyWith(color: Colors.green),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 10.0),
                child: new TextField(
                  controller: land,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Landmark',
                    labelStyle:
                    theme.textTheme.caption.copyWith(color: Colors.green),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 10.0),
                child: new TextField(
                  controller: pin,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    labelStyle:
                    theme.textTheme.caption.copyWith(color: Colors.green),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 2.0, 20.0, 2.0),
                alignment: Alignment.topLeft,
                child: new Text(
                  "Select Payment mode",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                alignment: Alignment.topLeft,
               child: RadioButtonGroup(
                   labels: <String>[
                     "Cash On Delievery",
                     "Online Via Razorpay",
                     "Online Via Paytm"
                   ],
                   onSelected: (String selected) => radiovalue = selected
               ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 0.0),
                child: new Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.green,
                  child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      onPressed: () async {
                        if(radiovalue == "Cash On Delievery"){
                          checkout(context);
                        }else if(radiovalue == "Online Via Razorpay"){
                          double pd = double.parse('${widget.paid}');
                          startPayment(pd,context);
                        }else if(radiovalue == "Online Via Paytm"){
                         /* SharedPreferences prefs = await SharedPreferences.getInstance();
                          String orderId = DateTime.now().millisecondsSinceEpoch.toString();
                          Map map = {
                            "orderid": orderId,
                            "custid":prefs.getString('_id').toString(),
                            "mobile": '8962582883',
                            "email":'sonimadhuri10@gmail.com',
                            "amount":'${widget.paid}'
                          };
                          findChecksum(Constants.CHECKSUM_URL, map,orderId);
                          */


                          double pd = double.parse('${widget.paid}');
                          testingCheckSum(pd,context);
                        }else{
                          Fluttertoast.showToast(
                              msg: "Please fill are requirements",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Text(
                        "Place Order",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}