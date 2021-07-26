class UserInformation {
  String? userName;
  String? userEmail;

  UserInformation({this.userEmail, this.userName});

  factory UserInformation.fromMap(Map data) {
    return UserInformation(
      userName: data['userName'] ?? "",
      userEmail: data['userEmail'] ?? "",
    );
  }

  factory UserInformation.initialData() {
     return UserInformation(
      userName: "user name",
      userEmail: "email@gmail.com",
    );
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
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      reportNumber: data['reportNumber'] ?? '',
      img: data['img'] ?? 'default.png',
    );
  }
}
