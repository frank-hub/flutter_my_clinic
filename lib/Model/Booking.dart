class Booking{
  final int id;
  final String name;
  final String phone;
  final String email;
  final String illness;
  final String start;
  final int status;
//  'name','location','date','thumbnail','description'
  Booking({this.id ,this.name , this.phone,this.email,this.illness,this.start,this.status});

  factory Booking.fromJson(Map<String , dynamic> json){
    return Booking(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        illness: json['illness'],
        start: json['start'],
        status: json['status']
    );
  }
}