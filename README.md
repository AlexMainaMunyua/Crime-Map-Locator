# crime_map

An application that will allow users to view and add areas reported with crimes to a crime map.

## Getting Started

## Roadmap/TODOs
- The application will have 2 screens
    - One a map that displays all the reported crime-prone areas
    - One screen that will allow a user to add a place to a crime map.
- The models clasess are
    - Users
        - Name.
        - Email.
    - Crime Location
        - Latitude.
        - Longitude.
        - Report_number.
        - Crime images.
- If a location has multiple crime reports then its report_number property is incremented.
- All the data is stored in firebase.
- The application uses firebase google Social Auth to authenticate users to the application.
- All regions will be rated by a number of crime reports.
    - If a region has less than 5 reports it is marked with a green maps marker.If a region has more than 5 but less than 20 it is marked with an orange maps marker.If a region has more than 20 reports it is marked with a red maps marker.
- When crime reporting one can upload images of crime.These can then be viewed when user clicks on crime spot on map.
- If file upload is not an image, display an error.
- Testing is not required but it is highly recommended.





- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# crime_map
