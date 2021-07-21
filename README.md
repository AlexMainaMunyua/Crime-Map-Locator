# crime_map

An application that will allow users to view and add areas reported with crimes to a crime map.
## Roadmap/TODOs
- The application has two screens.
    - A map that displays all the reported crime-prone areas
    - A screen that will allow a user to add a place to a crime map.
- The application has two models classes.
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
    - If a region has less than 5 reports it is marked with a green maps marker. If a region has more than 5 but less than 20 it is marked with an orange maps marker. If a region has more than 20 reports it is marked with a red maps marker.
- When crime reporting one can upload images of crime. These can then be viewed when user clicks on crime spot on map.
- If file upload is not an image, display an error.
- **Testing is not required but it is highly recommended**.

## Installation.

## Technologies Used.

## App Permission
- Access to Storage
- Access to camera
- Internet access
- Access to location

## Connect with me

[<img height="30" src="https://img.shields.io/badge/linkedin-0077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" />][LinkedIn]
[<img height="30" src="https://img.shields.io/badge/twitter-1DA1F2.svg?&style=for-the-badge&logo=twitter&logoColor=white" />][twitter]

[linkedIn]: https://www.linkedin.com/in/alex-maina/
[twitter]: https://twitter.com/RonaldoMaina