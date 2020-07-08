# ShareACab

An app for sharing cab with college students

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/devclub-iitd/ShareACab/graphs/commit-activity)
[![issues](https://img.shields.io/github/issues/devclub-iitd/ShareACab)](https://github.com/devclub-iitd/ShareACab/issues)
[![license](https://img.shields.io/github/license/devclub-iitd/ShareACab)](https://github.com/devclub-iitd/ShareACab)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg)](#)

## Description
Usually, after exams or when the mid-sem break begins, there is a large surge of people going back to their respective hometown by air/railways. This journey involves an initial travel where the person takes a cab to the IGI Airport or the New Delhi Railway station. A lot of times, people are forced to travel solo, if there isn't anyone he/she knows traveling at a similar time. Also, this leads to shortage of cabs nearby and increase in waiting time. Had there been a student of IIT-D with whom the cab could have been shared, the fares would also be split and the waiting time will also reduce. Another thing is that girls prefer not to travel alone in Cabs in Delhi, so that problem will also be solved by this app.  

## Screenshots:

|                                                    Dark Theme Dashboard.                                                     |                                                     Group Details Page.                                                     |                                                      Destination Trip                                                       |                                                Light theme login and logout                                                 |
| :--------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------: |
| <img src="https://user-images.githubusercontent.com/52427677/84919163-31ec8080-b0df-11ea-927d-673bc64845a5.jpeg" width=200/> | <img src="https://user-images.githubusercontent.com/22472045/84910976-30b65600-b0d5-11ea-8d9d-230c4c2bcbf1.gif" width=200/> | <img src="https://user-images.githubusercontent.com/22472045/84910892-12e8f100-b0d5-11ea-91fc-89cfd4e6805f.gif" width=200/> | <img src="https://user-images.githubusercontent.com/52520071/84898326-b2ea4e80-b0c4-11ea-9517-d1bf5a7ccb8d.gif" width=200/> |

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
            +--- ended_group_details.dart // group details page for ended rides
            +--- groupdetails.dart // group details page
          +--- groupscreen // handles the screen when user is in a cab/group
            +--- group.dart // shows the current group details
          +--- notifications // handles notification screen
            +--- services
              +--- database.dart // handles database for notifications
              +--- notifservice.dart // service file for calling database functions relevant to notifications
            +--- widgets
              +--- notifslist.dart // displays list of notifications
              +--- notiftile.dart // UI for notification tile
            +--- notifications.dart // notification page
          +--- profile
            +--- userprofile.dart // handles user profile screen
          +--- requests // handles the requests of users screen
            +--- createrequests.dart // Will be deleted during cleanup
            +--- myrequests.dart // displays Ended rides
            +--- requestslist.dart // Will be deleted during cleanup
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
          +--- loading.dart // the loading screen
        +--- main.dart
   |
   +--- functions  // Firebase Functions Folder: automatically run backend code in response to events
   |               // triggered by Firebase features and HTTPS requests
   |
   +--- etc
```

## What's working:

* [x] Authentication
  
  * Sign up/Sign in using email and   password. The user also needs to verify their email ID before logging in. Also given an option to reset password.
  * Frontend/Backend by @kshitijalwadhi
  
* [x] Curved Navbar
  
  * Curved Navbar to navigate between various screens
  * UI and dummy screens implemented by @Deepanshu-Rohilla
  * Logic by @kshitijalwadhi

* [x] Dashboard

  * Displaying the list of ongoing cabs/groups here. If the user taps on a card, the user is navigated to a screen which shows an overview of the group. On the group page, if the person clicks on join now, he's added to that group and is navigated to a screen where the details of the group are shown. There is also a floating action button which can be used in two ways, if the person is currently not in a group, by clicking the button he can create a new one, whereas if the user is already in a group, the button navigates him/her to the group details page. There is also an option to leave the group in the group details page. The admin of the group can also edit the details of the group.
  * UI by @Ishaan21
  * Backend/Logic by @kshitijalwadhi
  
* [x] Ended Rides
  
  * Displays completed rides of the user. 
  * The user can tap on the cards to view the details.
  * Implemented by @kshitijalwadhi

* [x] Settings
  
  * Currently has the ability to switch to dark mode and also report bugs.
  * Implemented by @kshitijalwadhi

* [x] Chatting Functionality
  
  * Whenever a group is created, a chatbox is also created where the members of that group can chat amongst each other.
  * UI by @Ishaan21 and @Deepanshu-Rohilla
  * Backend/logic by @Ishaan21

* [x] Profile Page
  
  * Displaying the user details on this page and also an option to edit them on the navbar.
  * UI by @Deepanshu-Rohilla and @kshitijalwadhi
  * Backend/Logic by @kshitijalwadhi

* [x] Filter Page

  * Rides on the dashboard can be filtered according to destination and privacy setting.

* [x] Request only groups
  
  * There is also a facility to create private groups which require an invite to be sent to the admin of the group and the admin needs to accept that invitation to allow the user to get in the group. This invite will be present in the Notifications screen and can be accepted/declined from there itself.

## Bugs:

* You tell us.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Check [CONTRIBUTING.md](https://github.com/devclub-iitd/ShareACab/blob/master/CONTRIBUTING.md) for contribution rules

## License
[MIT](https://choosealicense.com/licenses/mit/)
