import 'dart:convert';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/comman/spinner_input.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/model/Photo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'MyCart.dart';

class productInfo extends StatefulWidget {
  String id, name, category, description, price,catCount;
  productInfo(this.name, this.category, this.description, this.price, this.id,this.catCount);
  DBProvider db;


  @override
  productInfoState createState() => productInfoState();
}

class productInfoState extends State<productInfo> {
  String reply;
  double spinner;
  double total = 0;
  int count =0;
  List<String> list = [];
  var isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(()  {
      Map map = {"id": '${widget.id}'};
      apiRequest(Constants.GETIMAGE, map);
     // _fetchData();
    });

    setState(() {
      spinner = double.parse('${widget.catCount}');
    });

    total = double.tryParse('${widget.price}');
    cartCount();
  }

  cartCount() async {
    var cartitem =  await DBProvider.db.getCount();
    setState(()  {
      count =  cartitem;
    });
  }

/*
  _fetchData() async {
    setState(() {
      //isLoading = true;
    });
    final response =
    await http.get("https://blasanka.github.io/watch-ads/lib/data/ads.json");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Photo.fromJson(data))
          .toList();
      setState(() {
        // isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }
*/


  Future<String> apiRequest(String url, Map jsonMap) async {
    try {
      setState(() {
        isLoading = true;
      });
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);

      for (var word in data['images']) {
        String image = word["imageUrl"].toString();
        setState(() {
          list.add(image);
        });
      }

      setState(() {
        isLoading = false;
      });
    }

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



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
        actions: <Widget>[
          Center
            (child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: InkResponse(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(
                            builder:(BuildContext context) =>
                            new Cart('','','','','0')
                        )
                    );
                    },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
              Positioned(
                child: Container(
                  child: Text('${count}'),
                  // child: Text((DBP.length > 0) ? model.cartListing.length.toString() : "",textAlign: TextAlign.center,style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: isLoading ? Center(
              child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 0.0),
                child:
                CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                  strokeWidth: 5.0,
                  semanticsLabel: 'is Loading',),
              )
          ): Center(
        child: Container(
          child: Column(
            children: <Widget>[
             // isLoading ? Center(child: CircularProgressIndicator(),):
              new SizedBox(
                height: 170.0,
                width: double.infinity,
                child: CarouselSlider(
                    items:list.map(
                          (url) {
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child: Image.network(
                             url,
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ),
                        );
                      },
                    ).toList() /*[1,2,3].map((i) {
                      return new Builder(
                        builder: (BuildContext context) {
                          return new Container(
                            width: MediaQuery.of(context).size.width,
                            margin: new EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: new BoxDecoration(
                                color: Colors.amber
                            ),
                            child: Image.network(
                              list[i].imageUrl,
                              fit: BoxFit.cover,
                              height: 40.0,
                              width: 40.0,
                            ),
                          );
                        },
                      );
                    }).toList()*/,
                    height: 400.0,
                    autoPlay: true
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
                alignment: Alignment.center,
                child: new Text('${widget.description}',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.justify),
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Name :',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        '${widget.name}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Company :',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        '${widget.category}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Price :',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.center,
                      child: new Text(
                        'Rs. '
                        '${widget.price}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Quantity :',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      new Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0,0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: SpinnerInput(
                            spinnerValue: spinner,
                            minValue: 1,
                            maxValue: 200,
                            minusButton: SpinnerButtonStyle(
                                color: Colors.green, height: 30.0, width: 30.0),
                            plusButton: SpinnerButtonStyle(
                                color: Colors.green, height: 30.0, width: 30.0),
                            onChange: (newValue) {
                              setState(() {
                                spinner = newValue;
                                total = double.tryParse('${widget.price}') * spinner;
                              });
                            },
                          ),
                          //   margin: EdgeInsets.only(left:8.0),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          height: 60.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300], width: 1.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      child: Text(
                        "Total Amount",
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                    Text("Rs. ${total}",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                    //  Text("Rs. ${total}",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              /*  ScopedModelDescendant<AppModel>(
                    builder: (context,child,model){*/
              RaisedButton(
                color: Colors.deepOrange,
                onPressed: () {
                  DBProvider.db.FinalClient('${widget.id}', '${widget.name}',
                      spinner.toString(), total.toString(), '${widget.category}','${widget.description}');
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    cartCount();
                  });
                },
                child: Text(
                  "Add To Cart",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //          },
              //      )
            ],
          )),
    );
  }
}
