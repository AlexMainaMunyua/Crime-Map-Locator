class UserInfo {
  String? userName;
  String? userEmail;

  UserInfo({this.userEmail, this.userName});

  UserInfo.fromMap(Map data) {
    userName = data['userName'];
    userEmail = data['UserEmail'];
  }
}

class CrimeLocation {
  final String? latitude;
  final String? longitude;
  final int? reportNumber;
  final String? img;

  CrimeLocation({this.latitude, this.longitude, this.reportNumber, this.img});

  factory CrimeLocation.fromMap(Map data) {
    return CrimeLocation(
      latitude: data['latitude']?? '',
      longitude: data['longitude']?? '',
      reportNumber: data['reportNumber']?? '',
      img: data['img'] ?? 'default.png',
    );
  }
}
