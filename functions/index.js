const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();


exports.myFunction = functions.firestore.document('chatroom/{chatroomid}').onUpdate(async (change, context) => {
    var users = [];
    var tokens = [];
    const newValue = change.after.data();
    users = newValue.users;
    var docId = change.after.id;
    var i = 0;
    while (i < users.length) {
        var userDetails = await admin.firestore().collection('userdetails').doc(users[i]).get();
        tokens.push(userDetails.data.device_token);
    }
    exports.chatFunction = functions.firestore.collection('chatroom').doc(docId).collection('chats/{chatsId}').onCreate((snapshot, context) => {
        var payload = {
            notification: {
                title: snapshot.data().username,
                body: snapshot.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        }
        try {
            const response = await admin.messaging().sendToDevice(tokens, payload);
            console.log('Notfication sent successfully');
        } catch (err) {
            console.log('Error sending Notification');
        }
    });
})
