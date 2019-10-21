import 'package:flutter/material.dart';
import 'package:ricwala_application/activity/splash.dart';

class StartScreen extends StatefulWidget{
  @override
  _StartScreenState createState() => _StartScreenState();
}
class _StartScreenState extends State<StartScreen>{
  @override
  Widget build(BuildContext context) {

    final forgotLabel = FlatButton(
      child: Text('Welcome to Ricwal',
        style: TextStyle(color: Colors.green,fontSize: 20.0),
      ),
    );
    final signUpButton = Container(
      child: new SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => splash()));
          },
          padding: EdgeInsets.all(20),
          color: Colors.green,
          child: Text('GET STARTED', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
    Widget middleSection =  new Container (
      child: new Column(
        //  crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            height: 250.0,
            width: double.infinity,
            child: Image.asset('images/slider.png',fit: BoxFit.fitWidth),
          )

         // new

        ],
      ),
      //   ),
    );
    final textLabel = FlatButton(
      child: Text(
        'RICWAL is an Agri-Business E-Commerce Start-up which provides best quality of rice to the customer’s door-step with an affordable price. The main agenda of Ricwal is to make sure that there is no middle men in between the producers and the consumers. So that the customers can get best quality rice at an affordable price. Ricwal has tied up with 100+ major rice industries in the state of Telangana and got associated with many rice brands like Lalitha, Lohitha, Bell, Fortune and 24 Mantra Organic rice brandRicwal also encourages and educates farmers on the production of organic rice which has a great demand in modern society. Ricwal is trying to bring the tremendous work done by the farmers to grow the crop into limelight by projecting them in farmer’s portal and educating them on how to produce good crops with good yield.',
        style: TextStyle(color: Colors.black54,
            fontFamily: 'Roboto:300'),textAlign: TextAlign.justify,
      ),
    );

    Widget body = new SingleChildScrollView(
      child: new Column(
        // This makes each child fill the full width of the screen
        /* crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,*/
        children: <Widget>[
          middleSection,
          SizedBox(height: 5.0),
          forgotLabel,
          textLabel,
          SizedBox(height: 15.0),
          new Container(
            alignment: FractionalOffset.bottomCenter,
            child: signUpButton,
          )
        ],
      ),
    );
    return new Scaffold(
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }
}