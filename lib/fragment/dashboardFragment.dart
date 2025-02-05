import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:google_places_picker/google_places_picker.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:google_places_picker/google_places_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/comman/LocationData.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/fragment/ProductInfo.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';

class dashboardFragment extends StatefulWidget {
  @override
  dashboardFragmentState createState() => dashboardFragmentState();
}

class dashboardFragmentState extends State<dashboardFragment> {
  String reply = "", status = "";
  String val;
  var isLoading = false;
  String _placeName = 'Your Location';
  PlaceDetails _place, _destinationPlace = null;
  PlaceDetails place, placeDestination;
  List<Product_model> lis = List();
  List<NetworkImage> imglist = List();
  DBProvider db;
  TextEditingController count = TextEditingController();
  Drawer home;
  int _itemCount = 1;
  var currentLocation = LocationData;
  String pickUpLocation = "Enter Location";
  bool pickUpBool = true;
  String idnew;
  String id;
  String user_id,user_wishstatus;



  Icon _affectedByStateChange = new Icon(
    Icons.favorite_border,
    color: Colors.green,
  );

  /*void colourrr() {
    if (user_wishstatus == "1") {
      setState(() {
        _affectedByStateChange = new Icon(Icons.favorite, color: Colors.green);
      });
    } else if (user_wishstatus == "0") {
      setState(() {
        _affectedByStateChange = new Icon(Icons.favorite_border, color: Colors.green);
      });
    }
  }*/

  @override
  void initState()  {
    super.initState();
    val;
    user_wishstatus;
    _affectedByStateChange;
 // colourrr();
    idnew;
    getSharesddata();

    FlutterPlacesDialog.setGoogleApiKey(
        "AIzaSyBEwxjE4AxdBSQHseBvJ03xv4rfPpwBRFQ");
    //  FlutterPlacesDialog.setGoogleApiKey("AIzaSyCVHyHfg8USjCuVztU-x6VAQo9UdFVZ88Y");
    //  FlutterPlacesDialog.setGoogleApiKey("AIzaSyCnrQ33dccN8jKIZx9JfQzhDpv-1bfuqL0");

    /*PluginGooglePlacePicker.initialize(
      androidApiKey: "AIzaSyCVHyHfg8USjCuVztU-x6VAQo9UdFVZ88Y",
      iosApiKey: "AIzaSyAZTopQP2kWlFcc99FIct88thJLP_O4PVA",
    );*/
  }
  getSharesddata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id =prefs.getString('_id').toString();
      user_wishstatus = prefs.getString('wishstatus').toString();

      print("userid"+user_id);
    });
    Map map = {"page": '${_itemCount}',
      "user_id": '${user_id}'};
    apiRequest(Constants.PRODUCTLIST_URL, map);

  }

  /*_showAutocomplete() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    var place = await PluginGooglePlacePicker.showAutocomplete(mode: PlaceAutocompleteMode.MODE_FULLSCREEN);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;
    setState(() {
      _placeName = pickUpLocation;
      pickUpLocation = '${place.name}, ${place.address}';
     // G_Latitude =place.latitude;
      //G_Longitude =place.longitude;
    });
  }*/

  void increment() {
    setState(() => _itemCount = _itemCount + 1);
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    try {
      setState(() {
        isLoading = true;
      });
      // CustomProgressLoader.showLoader(context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      // if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['details'].toString();

      //   CustomProgressLoader.cancelLoader(context);

      for (var word in data['data']) {
        id = word["_id"].toString();
        String name = word["product_name"].toString();
        String company = word["company_name"].toString();
        String image = word["image"].toString();
        String description = word["description"].toString();
        String status = word["stock_status"].toString();
        String category = word["category"].toString();
        String quantity = word["quantity"].toString();
        String price = word["price"].toString();
        String unit = word["unit"].toString();
        String wishstatus = word["status"].toString();



          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            prefs.setString('wishstatus', wishstatus);

          });

        if (wishstatus == "1") {
          setState(() {
            _affectedByStateChange = new Icon(Icons.favorite, color: Colors.green);
          });
        } else if (wishstatus == "0") {
          setState(() {
            _affectedByStateChange = new Icon(Icons.favorite_border, color: Colors.green);
          });
        }


        setState(() {
          lis.add(Product_model(id, image, name, company, description, category,
              quantity, status, price, unit, wishstatus));
        });
      }
//var array = data['data'];
      print('RESPONCE_DATA : ' + status);
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }
  }

  _show_Autocomplete() async {
    if (pickUpBool) {
      try {
        setState(() {
          pickUpBool = false;
        });
        place = await FlutterPlacesDialog.getPlacesDialog();
      } on PlatformException {
        place = null;
        setState(() {
          pickUpBool = true;
        });
      }
      if (!mounted) return;
      print("$place");
      setState(() {
        _place = place;
        if (_place == null) {
          pickUpLocation = 'Enter Your Pick Up Location';
          setState(() {
            pickUpBool = true;
          });
        } else {
          pickUpLocation = '${_place.name}, ${_place.address}';
          setState(() {
            _placeName = pickUpLocation;
            pickUpBool = true;
          });
        }
      });
    }
  }

  Future<String> addWishlist(String url, Map jsonMap) async {
    try {
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String message = data['message'].toString();
      String _status = data['status'].toString();
      print('wish_DATA : ' + data.toString());


//var array = data['data'];
      // print('RESPONCE_DATA : ' + status);

      if (message == "success") {
        Fluttertoast.showToast(
            msg: "Successfully Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (message == "Duplicate record") {
        Fluttertoast.showToast(
            msg: "Already Exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

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
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }
  }

  /* Future location() async {
    var location = new Location();
    try {
      currentLocation = (await location.getLocation()) as Type;
    // ignore: non_type_in_catch_clause
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
      }
      currentLocation = null;
    }

    Fluttertoast.showToast(
        msg: currentLocation.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }*/

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    Color _iconColor = Colors.white;
    Color _iconColorred = Colors.red;

    Text txt = Text('',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
            color: Colors.green));

    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.2;
    final double itemWidth = size.width / 2;
    return Scaffold(
        body: new SingleChildScrollView(
      child: Column(
        children: <Widget>[
          new SizedBox(
              height: 170.0,
              width: double.infinity,
              child: new Carousel(
                images: [
                  new NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFtJRVuVD8qNJrdysGx3WjVdJ_usxUtKHCOUwzga-lH5qKT7JsUg'),
                  new NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRi_z67Oi93lZg7hUhtSzbP_03hYOFdckil9EaqIYUge-O15Ot0LQ'),
                  new NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLx6lc69wBhJmWjudTQr_pAaSuZ6RBXy_fXKTPNhQJ_7mO5qhtYQ'),
                  new NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv5zBZffj4cUv84MjIcqRbusWDbEGgV_Cny9SYFPkiZTpqFFw'),
                  new NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC7eNj1-UP7EEMcSoSl3ovHMnTKxCy8TNddtNUE9-wrIacMnOx'),
                  new NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJGKXY1xLpXSFx-o0uvSHZJiE53kbzYMqilG0fPUCdnV1G4lK-'),
                ],
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Colors.green,
                indicatorBgPadding: 5.0,
                dotBgColor: Colors.grey.withOpacity(0.5),
              )),
          new Container(
            child: isLoading
                ? Center(
                    child: new Container(
                    margin: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Colors.green),
                      strokeWidth: 5.0,
                      semanticsLabel: 'is Loading',
                    ),
                  ))
                : GridView.builder(
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (itemWidth / itemHeight)),
                    itemBuilder: (BuildContext context, int index) {
                      idnew = '${lis[index].id}';
                      return Padding(
                        padding: EdgeInsets.all(2.0),
                        child: new GestureDetector(
                          child: Container(
                            child: Container(
                              margin: EdgeInsets.all(2.0),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    new GestureDetector(
                                      onTap: ()  {
                                        _affectedByStateChange = new Icon(
                                          Icons.favorite_border,
                                          color: Colors.green,
                                        );
                                        val = '${lis[index].wishstatus}';

                                        if (val == "1") {
                                          setState(()  {

                                            _affectedByStateChange = new Icon(
                                                Icons.favorite,
                                                color: Colors.green);


                                          });

                                        } else if (val == "0") {
                                          setState(() async {
                                            _affectedByStateChange = new Icon(
                                                Icons.favorite,
                                                color: Colors.green);


                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                .getInstance();
                                            Map map = {
                                              "user_id": '${prefs.getString('_id').toString()}',
                                              "product_id": '${lis[index].id}',
                                              "product_name":
                                              '${lis[index].name}',
                                              "company_name":
                                              '${lis[index].company}',
                                              "image": '${lis[index].image}',
                                              "description":
                                              '${lis[index].description}',
                                              "category":
                                              '${lis[index].category}',
                                              "quantity":
                                              '${lis[index].quantity}',
                                              "unit": '${lis[index].unit}',
                                              "price": '${lis[index].price}'

                                            };

                                            addWishlist(
                                                Constants.WISHLIST_URL, map);
                                          });




                                        }
                                      },
                                      child: new Container(
                                        margin: EdgeInsets.fromLTRB(
                                            100.0, 15.0, 0.0, 0.0),
                                        alignment: Alignment.topRight,
                                        child: _affectedByStateChange,
                                        width: 20.0,
                                        height: 20.0,
                                      ),
                                    ),
                                    new Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 12.0, 0.0, 0.0),
                                      child:
                                          new Image.asset('images/ricecan.jpg'),
                                      width: double.infinity,
                                      height: 120.0,
                                    ),
                                    new Container(
                                      margin: EdgeInsets.fromLTRB(
                                          2.0, 0.0, 2.0, 0.0),
                                      alignment: Alignment.center,
                                      child: new Text(
                                        lis[index].name,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    /* new Row(
                                    children: <Widget>[
                                     new Container(
                                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          'Name :',
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight
                                                  .normal),
                                        ),
                                      ),
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                            lis[index].name,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),*/
                                    new Row(
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              5.0, 0.0, 0.0, 0.0),
                                          alignment: Alignment.topLeft,
                                          child: new Text(
                                            'Brand :',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              30.0, 0.0, 0.0, 0.0),
                                          alignment: Alignment.topLeft,
                                          child: new Text(
                                            lis[index].company,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Container(
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Row(
                                            children: <Widget>[
                                              new Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5.0, 0.0, 0.0, 0.0),
                                                alignment: Alignment.topLeft,
                                                child: new Text(
                                                  'Price :',
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              new Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    33.0, 0.0, 0.0, 0.0),
                                                alignment: Alignment.topLeft,
                                                child: new Text(
                                                  'Rs. ' + lis[index].price,
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          /* new Container(
                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                          alignment: Alignment.topRight,
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new GestureDetector(
                                                onTap: () {
                                                // increment(txt.data);
                                                  DBProvider.db.FinalClient(
                                                      lis[index].id,
                                                      lis[index].name,
                                                      "1",
                                                      lis[index].price,
                                                      lis[index].category);
                                                  setState(() {});
                                                },
                                                child: new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10.0, 3.0, 0.0, 0.0),
                                                  alignment: Alignment.topLeft,
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/plus.png')),
                                                  width: 20.0,
                                                  height: 20.0,
                                                ),
                                              ),
                                              new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5.0, 3.0, 0.0, 0.0),
                                                  child: txt),
                                              new GestureDetector(
                                                onTap: () {
                                                  setState(()=>_itemCount--);                                                  DBProvider.db.FinalDecrement(
                                                      lis[index].id,
                                                      lis[index].name,
                                                      "1",
                                                      lis[index].price,
                                                      lis[index].category);
                                                  setState(() {});
                                                },
                                                child: new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5.0, 3.0, 8.0, .0),
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/minus.png')),
                                                  width: 20.0,
                                                  height: 20.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        productInfo(
                                            lis[index].name,
                                            lis[index].company,
                                            lis[index].description,
                                            lis[index].price,
                                            lis[index].id,
                                            "1")));
                          },
                        ),
                      );
                    },
                    itemCount: lis.length,
                  ),
          ),
          /*  new Container(
                color: Colors.green,
                width: double.infinity,
                height: 40.0,
                child: FlatButton(
                  child: Text("Load More",style: TextStyle(fontSize: 12.0,
                      fontWeight: FontWeight.bold,color: Colors.white),),
                  onPressed: () {
                  //  increment();
                    Map map = {"page": '${++_itemCount}'};
                    apiRequest(Constants.PRODUCTLIST_URL, map);
                    setState(() {

                    });
                  },
                ),
              )*/
        ],
      ),
    ));
  }
}
