### UI Flow:

1. Splash a login/signup screen when someone opens the app for the first time. It should have 2 buttons
    1. Login for existing users
    2. Signup for new users
    3. Login via email/phone (this needs to be explored more): On login button click
        ```dart
        if (textfield has emailId) then
        Ask for password and login
        ```
        ```dart
        if (textfield has phoneNumber) then
        Ask for otp and login
        ```
    4. While signing a user up, the following fields should be there:
        1. Name
        2. Kerberos email ID 
        check for iitd id using regex
        3. Password (DOESNT NEED TO BE KERBEROS PASSWORD)
        make sure it is alteast 4 characters long and not empty
        4. Contact Number
        make sure it is string of length 10, then store +91.entered string in variable
        5. Hostel
        give drop down all the hostels
        6. Sex
        radio box of Male/Female
        First register a user with email and pass, if everything success at front end, get it's userid
        First check phone otp, if we pass then link that phone with this user
        We send a verification email to the email ID given
        letting the user see dashboard that email has been verified (Add a separate screen for this)
2. On successful login:
There should be four pages that can be accessed from the hamburger menu (can do a bottom navbar as well)
    ```dart
    a) Dashboard
    b) Your requests
    c) Notifications
    d) Messages (Needs to be decided if working on chat-box [cab specific] or simple message exchange)
    e) Log out
    ```

    1. Dashboard:
    On the top, there should be a drop down filter type thing through which we can filter the ongoing cabs. The filters need to be decided, the obvious ones are destination and date, we can also add the time interval too.
    Also on the top right side, give a button for new requests if one wants to create one on his own.
    On the dashboard itself, we display the ongoing/scheduled cabs which can be filtered and display some basic information on the cards (Destination, Time-range, number of members). If we are doing the invite only/ open to all thing, we can show a lock icon on top right of every card to indicate invite only. Need to think if we need a click on card to open a new page about the cab or not. If we do, we can do this that a user can directly select if this particular cab suits him or not and enter the cab. If he presses the button to do so, open a new window and take the input of Times as mentioned below. 
    If the user decides to add his own request, we open another page and take the following inputs from him:
        ```dart
        a) Destination (A drop down menu for now)
        b) Start Time
        c) End Time
        d) Threshold Time
        e) destination after reaching the terminal
        f) Max number of people in group allowed as per user. (This the person will decide on basis of how much luggage he is carrying, like he will set this at 2 if he has some big bags or will set at 3 for normal travel).
        g) Number of friends already accompanying (0,1)
        ```
        The purpose of these start, end, threshold times is mentioned in the logic for backend section.
        If the user increases the count of friends, we also need to take some input from user, maybe an email ID? or something like that. (Need to think on this).
        take max no in group, like 4,5,6

     2. Your requests
        Show the requests(listing) made by user in cards. Should have ongoing or ended label on them.
        When clicked, take them to details of cab page.
        That details page should have the following schema:
        1. Show the destination on top.
        2. Show the time to destination in minutes by fetching from google API. like 38 minutes to destination in current traffic. 
        3. The current time range (explained in backend portion)
        4. The members till now and their contact info.
        5. Also give an option to leave cab and if the user clicks this, remove his listing(explained in backend portion).
        and inc a counter cancelled rides
    3. Notifications
    House all the notifications here.
    Like, a new person has joined the cab and the updated timings are T1 to T2.
    4. Messages
    Need to think on this.
    if working on chat-box [cab specific] or simple message exchange.
    5. Profile Page
    Show the details of the user and let him edit it if required.
    6. Logout (Can be clubbed in Profile Page)
    A simple logout button that takes confirmation and logs user out.