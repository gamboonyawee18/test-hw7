import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http; 
import 'doginfo.dart'; 

void main() => runApp(MyApp(products: fetchProducts())); 

List< Doggoinfodata> parseProducts(String responseBody) { 
   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>(); 
   return parsed.map<Doggoinfodata>((json) =>  Doggoinfodata.fromMap(json)).toList(); 
} 
Future<List<Doggoinfodata>> fetchProducts() async { 
   final response = await http.get('http://192.168.221.1:8080/doggodata.json'); 
   if (response.statusCode == 200) { 
      return parseProducts(response.body); 
   } else { 
      throw Exception('Unable to fetch products from the REST API'); 
   } 
}
class MyApp extends StatelessWidget {
   final Future<List<Doggoinfodata>> products; 
   MyApp({Key key, this.products}) : super(key: key); 
   
   // This widget is the root of your application. 
   @override 
   Widget build(BuildContext context) {
      return MaterialApp(
         title: 'Flutter Demo', 
         theme: ThemeData( 
            primarySwatch: Colors.blue, 
         ), 
         home: MyHomePage(title: 'Product Navigation demo home page', products: products), 
      ); 
   }
}
class MyHomePage extends StatelessWidget { 
   final String title; 
   final Future<List<Doggoinfodata>> products; 
   MyHomePage({Key key, this.title, this.products}) : super(key: key); 
   
   // final items = Product.getProducts();
   @override 
   Widget build(BuildContext context) { 
      return Scaffold(
         appBar: AppBar(title: Text("Product Navigation")), 
         body: Center(
            child: FutureBuilder<List<Doggoinfodata>>(
               future: products, builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error); 
                  return snapshot.hasData ? ProductBoxList(items: snapshot.data) 
                  
                  // return the ListView widget : 
                  : Center(child: CircularProgressIndicator()); 
               },
            ),
         )
      );
   }
}
class ProductBoxList extends StatelessWidget {
   final List<Doggoinfodata> items; 
   ProductBoxList({Key key, this.items}); 
   
   @override 
   Widget build(BuildContext context) {
      return ListView.builder(
         itemCount: items.length, 
         itemBuilder: (context, index) { 
            return GestureDetector( 
               child: ProductBox(item: items[index]), 
               onTap: () { 
                  Navigator.push(
                     context, MaterialPageRoute( 
                        builder: (context) => ProductPage(item: items[index]), 
                     ), 
                  ); 
               }, 
            ); 
         }, 
      ); 
   } 
} 
class ProductPage extends StatelessWidget { 
   ProductPage({Key key, this.item}) : super(key: key); 
   final Doggoinfodata item; 
   @override 
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(title: Text(this.item.name),), 
         body: Center( 
            child: Container(
               padding: EdgeInsets.all(0), 
               child: Column( 
                  mainAxisAlignment: MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: <Widget>[
                     Image.asset("assets/images/" + this.item.image), 
                     Expanded( 
                        child: Container( 
                           padding: EdgeInsets.all(5), 
                           child: Column( 
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                              children: <Widget>[ 
                                 Text(this.item.name, style: 
                                    TextStyle(fontWeight: FontWeight.bold)), 
                                 Text(this.item.name), 
                                // Text("Price: " + this.item.price.toString()), 
                                 RatingBox(), 
                              ], 
                           )
                        )
                     ) 
                  ]
               ), 
            ), 
         ), 
      ); 
   } 
}
class RatingBox extends StatefulWidget { 
   @override 
   _RatingBoxState createState() =>_RatingBoxState(); 
} 
class _RatingBoxState extends State<RatingBox> { 
   int _rating = 0; 
   void _setRatingAsOne() {
      setState(() { 
         _rating = 1; 
      }); 
   }
   void _setRatingAsTwo() {
      setState(() {
         _rating = 2; 
      }); 
   }
   void _setRatingAsThree() { 
      setState(() {
         _rating = 3; 
      }); 
   }
   Widget build(BuildContext context) {
      double _size = 20; 
      print(_rating); 
      return Row(
         mainAxisAlignment: MainAxisAlignment.end, 
         crossAxisAlignment: CrossAxisAlignment.end, 
         mainAxisSize: MainAxisSize.max, 
         
         children: <Widget>[
            Container(
               padding: EdgeInsets.all(0), 
               child: IconButton( 
                  icon: (
                     _rating >= 1 
                     ? Icon(Icons.star, size: _size,) 
                     : Icon(Icons.star_border, size: _size,)
                  ), 
                  color: Colors.red[500], onPressed: _setRatingAsOne, iconSize: _size, 
               ), 
            ), 
            Container(
               padding: EdgeInsets.all(0), 
               child: IconButton(
                  icon: (
                     _rating >= 2 
                     ? Icon(Icons.star, size: _size,) 
                     : Icon(Icons.star_border, size: _size, )
                  ), 
                  color: Colors.red[500], 
                  onPressed: _setRatingAsTwo, 
                  iconSize: _size, 
               ), 
            ), 
            Container(
               padding: EdgeInsets.all(0), 
               child: IconButton(
                  icon: (
                     _rating >= 3 ? 
                     Icon(Icons.star, size: _size,)
                     : Icon(Icons.star_border, size: _size,)
                  ), 
                  color: Colors.red[500], 
                  onPressed: _setRatingAsThree, 
                  iconSize: _size, 
               ), 
            ), 
         ], 
      ); 
   } 
}
class ProductBox extends StatelessWidget {
   ProductBox({Key key, this.item}) : super(key: key); 
   final Doggoinfodata item; 
   
   Widget build(BuildContext context) {
      return Container(
         padding: EdgeInsets.all(2), height: 140, 
         child: Card(
            child: Row( 
               mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
               children: <Widget>[
                  Image.asset("assets/images/" + this.item.image), 
                  Expanded( 
                     child: Container( 
                        padding: EdgeInsets.all(5), 
                        child: Column( 
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                           children: <Widget>[ 
                              Text(this.item.name, style:TextStyle(fontWeight: FontWeight.bold)), 
                              Text(this.item.name), 
                             // Text("Price: " + this.item.price.toString()), 
                              RatingBox(), 
                           ], 
                        )
                     )
                  )
               ]
            ), 
         )
      ); 
   } 
}