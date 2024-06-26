class Offer {
  final int id;
  final String toolName;
  final String toolDescription;
  final String price;
  final String dateStart;
  final String dateFinish;
  final String ownerName;
  final String phoneNumber;
  final String lat;
  final String lng;
  final String img;

  Offer({
    required this.id,
    required this.toolName,
    required this.toolDescription,
    required this.price,
    required this.dateStart,
    required this.dateFinish,
    required this.ownerName,
    required this.phoneNumber,
    required this.lng,
    required this.lat,
    required this.img,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        id: json['id'],
        toolName: json['tool_name'],
        toolDescription: json['tool_description'],
        lat: json['lat'],
        lng: json['lng'],
        price: json['price'],
        dateStart: json['date_start'],
        dateFinish: json['date_finish'],
        ownerName: json['owner_name'],
        phoneNumber: json['phone_number'],
        img: json['img']
    );
  }
}