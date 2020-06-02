# ShareACab

An app for sharing cab with college students

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/devclub-iitd/ShareACab/graphs/commit-activity)
[![issues](https://img.shields.io/github/issues/devclub-iitd/ShareACab)](https://github.com/devclub-iitd/ShareACab/issues)
[![license](https://img.shields.io/github/license/devclub-iitd/ShareACab)](https://github.com/devclub-iitd/ShareACab)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg)](#)

## Description
Usually, after exams or when the mid-sem break begins, there is a large surge of people going back to their respective hometown by air/railways. This journey involves an initial travel where the person takes a cab to the IGI Airport or the New Delhi Railway station. A lot of times, people are forced to travel solo, if there isn't anyone he/she knows traveling at a similar time. Also, this leads to shortage of cabs nearby and increase in waiting time. Had there been a student of IIT-D with whom the cab could have been shared, the fares would also be split and the waiting time will also reduce. Another thing is that girls prefer not to travel alone in Cabs in Delhi, so that problem will also be solved by this app.  

## Directory Layout
```go
 ShareACab
   +--- README, LICENSE // basic information
   +--- assets  // contains all assets like images for project
   |
   +--- lib
        +--- models
          +--- alltrips.dart // (WILL BE REMOVED LATER)
          +--- requestdetails.dart // Request Model
          +--- user.dart // User Model
        +--- screens
          +--- authenticate
            +--- authenticate.dart // for toggling between sign in and register
            +--- forgotpass.dart // forgot password screen
            +--- register.dart // register user screen
            +--- sign_in.dart // sign in screen
            +--- verified_email_check.dart // check if user verified screen
          +--- chatscreen // handles the chating section
            +--- chat_database
              +--- chatservices.dart
              +--- database.dart
            +--- chat_widgets
              +--- chat_bubbles.dart
              +--- chat_tile.dart
              +--- chat_users_list.dart
              +--- message.dart
              +--- new_message.dart
            +--- chat_screen.dart
          +--- groupdetailscreen // handles the screen when user clicks on a card on dashboard
            +--- appbar.dart // group details page appbar
            +--- groupdetails.dart // group details page
          +--- groupscreen // handles the screen when user is in a cab/group
            +--- group.dart // shows the current group details
          +--- notifications // handles notification screen
            +--- notifications.dart
          +--- profile
            +--- userprofile.dart // handles user profile screen
          +--- requests // handles the requests of users screen
            +--- createrequests.dart
            +--- myrequests.dart
            +--- requestslist.dart
          +--- createtrip.dart // the screen for creating a new group
          +--- dashboard.dart // handles dashboard
          +--- edituserdetails.dart // handles edit user details page
          +--- filter.dart // handles filter service
          +--- messages.dart // messages screen
          +--- rootscreen.dart // handles navigation services
          +--- settings.dart // settings page to set dark mode
          +--- tripslist.dart // displays the list of trips on dashboard
          +--- wrapper.dart // handles the routing when a user is logged in
        +--- services
          +--- auth.dart // handles all authentication related services
          +--- database.dart // the PRIMARY database service which handles everything
          +--- trips.dart // for calling a function purposes
        +--- shared
          +--- constants.dart // the constant files
          +--- loading.dart // the loading screen
        +--- main.dart
   |
   +--- functions  // Firebase Functions Folder: automatically run backend code in response to events
   |               // triggered by Firebase features and HTTPS requests
   |
   +--- etc
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.


- Make sure that pedantic version is `1.9` and run `flutter analyze`
- Add Screenshots or gif of UI workflow in PR comments
- **Formatting**  
  - Make sure to format code before generating PR. 
  - If on android studio, select all using CTRL + A and then formatting can be done using CTRL+ALT+L.  
  - Make sure hard wrap is set to 900 while formatting.  
  - <img width="637" alt="Screenshot 2020-05-20 at 11 02 17 AM" src="https://user-images.githubusercontent.com/31121102/82408535-67bf2a80-9a89-11ea-80d9-361f72c8b8b4.png">
  - If you are on vs code, check this for changing hard wrapping. https://stackoverflow.com/questions/59456452/how-to-change-vs-code-line-auto-wrap-column-when-formatting-dart-files
  - Check this for more info about formatting. https://flutter.dev/docs/development/tools/formatting

## License
[MIT](https://choosealicense.com/licenses/mit/)
