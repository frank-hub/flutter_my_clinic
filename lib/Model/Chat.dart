class Chat{
  final int id;
  final String name;
  final String sender;
  final String message;
  // ignore: non_constant_identifier_names
  final String created_at;

  // ignore: non_constant_identifier_names
  Chat({this.id ,this.name , this.sender,this.message,this.created_at,});

  factory Chat.fromJson(Map<String , dynamic> json){
    return Chat(
        id: json['id'],
        name: json['name'],
        sender: json['sender'],
        message: json['message'],
        created_at: json['created_at'],
    );
  }
}