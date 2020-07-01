const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);


exports.myFunction = functions.firestore.document('chatroom/{chatroomid}/chats/{chatsId}').onCreate(async (snapshot, context) => {
    var docId;
    var tokens = [];
    var usersChat = [];
    // console.log(usersChat);
    docId = context.params.chatroomid;
    // console.log(docId);
    var roomDetails = await admin.firestore().collection('chatroom').doc(docId).get();
    // console.log(roomDetails);
    usersChat = roomDetails.data().users;
    // console.log(usersChat);
    var i = 0;
    // console.log(snapshot.data().userId);
    while (i < usersChat.length) {
        if(usersChat[i] != snapshot.data().userId){
            var userDetails = await admin.firestore().collection('userdetails').doc(usersChat[i]).get();
            tokens.push(userDetails.data().device_token);
        }
        // console.log('hello');
        // console.log(usersChat.length);
        i++;
    };
    // console.log(tokens);
    var payload = {
        notification: {
            title: snapshot.data().name,
            body: snapshot.data().text,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        }
    }
    try {
        return admin.messaging().sendToDevice(tokens, payload);
        // console.log('Notfication sent successfully');
    } catch (err) {
        console.log('Error sending Notification');
    }
    // return admin.messaging().sendToDevice(tokens, payload);

});




