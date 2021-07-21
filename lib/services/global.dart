import 'package:crime_map/services/service.dart';

// Static global state. Immutabel services that do not care about build context.
class Global {
  //App Data
  static final String? title = 'Crime App';

  //Data Models
  static final Map models = {
    UserInfo: (data) => UserInfo.fromMap(data),
    CrimeLocation: (data) => CrimeLocation.fromMap(data),
  };

  // Firestore reference for writes.
  static final UserData<UserInfo> userInfo =
      UserData<UserInfo>(collection: 'user');

  static final Collection<CrimeLocation> crimeLocation =
      Collection<CrimeLocation>(path: 'crimeLocation');
}
