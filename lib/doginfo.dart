class Doggoinfodata {
  final String name;
  final String image;
 
 
  Doggoinfodata(this.name, this.image);
 
 factory Doggoinfodata.fromMap(Map<String, dynamic> json) {
   return Doggoinfodata(
    json['name'],
    /*json['price'],*/
    json['image'],
    

   );
    
  }

  
}