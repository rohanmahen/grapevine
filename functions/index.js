const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// send notification to universal topic when new events are added to the firestore events collection
exports.newPublicEventsAddedNotification = functions.firestore.document('events/{eventId}').onCreate((snap, context) => {
    const payload = {
        notification: {
            title: "New Events have been added to your feed! 🕺",
            body: "👀 Click to see Who's In",
            sound: 'default'
        }
    };
    return admin.messaging().sendToTopic('universal', payload);
});


// send notificaition to user when their potentialCircles field is not empty
exports.newPotentialCirclesAddedNotification = functions.firestore.document('users/{userId}').onUpdate((change, context) => {
    console.log("Invited Circles Notification Function Called");

    // get tokens from user document
    const tokens = change.after.data().userTokens;
    // log
    console.log("Tokens: ", tokens);

    // get potentialCircles from user document
    const potentialCircles = change.after.data().potentialCircles;
    console.log("Potential Circles: ", potentialCircles);

    // if potential circles is not empty, send notification
    if (potentialCircles.length > 0) {

        // try to send notification
        try {

            const payload = {
                notification: {
                    title: 'You have been invited to join a new circle!',
                    body: "Accept the invitation to join!",
                    sound: 'default'
                }
            };

            return admin.messaging().sendToDevice(tokens, payload);
        } catch (error) {
            console.log(error);
        }
    }
    // else do
    else {
        console.log("No new potential circles to notify user about");
        return null;
    }
});


// send notification to user when their circle is invited to an event
exports.newEventInvitationNotification = functions.firestore.document('events/{eventId}').onCreate((snap, context) => {

    // log everything
    console.log("New Event Invitation Notification Function Called");
    const db = admin.firestore();
    // log  
    console.log("Event ID: ", context.params.eventId);

    // get user id from context
    const userId = context.auth.uid;
    //log
    console.log("User ID: ", userId);
    const eventCircles = set(snap.data().invitedCircles);
    //log
    console.log("Event Circles: ", eventCircles);
    const eventType = snap.data().eventType;
    // log
    console.log("Event Type: ", eventType);

    //
    const userCircles = db.collection('users').doc(userId).get().then((doc) => {
        if (doc.exists) {
            console.log("User Circles: ", userCircles);
            return set(doc.data().userCircles);

        } else {
            return null;
        }
    });


    const userTokens = db.collection('users').doc(userId).get().then((doc) => {
        if (doc.exists) {
            console.log(userTokens);
            return doc.data().userTokens;
        } else {
            return null;
        }
    });

    // get intersection of eventCircles and userCircles
    const intersection = userCircles.intersection(eventCircles);

    // if intersection is not empty, send notification
    if (intersection.length > 0) {
        try {
            const payload = {
                notification: {
                    // title is your circle has been invited to a new eventType event
                    title: `Your circle has been invited to a new ${eventType} event!`,
                    body: "Click to see the details",
                    sound: 'default'
                }
            };

            // send a notification to every topic in the intersection
            intersection.forEach((circle) => {
                admin.messaging().sendToTopic(circle, payload);
            });
        } catch (error) {
            console.log(error);
        }
    } // else do    
    else {
        // log
        console.log("No new event invitations to notify user about");
        return null;
    }
});


// send notification to user if their circle is empty every 24 hours
exports.noCirclesNotification = functions.pubsub.schedule('every 24 hours').onRun((context) => {


    const db = admin.firestore();

    // get user id from context
    const userId = context.auth.uid;
    // get user tokens from
    const userTokens = db.collection('users').doc(userId).get().then((doc) => {
        if (doc.exists) {
            return doc.data().userTokens;
        } else {
            return null;
        }

    });

    // get
    const userCircles = db.collection('users').doc(userId).get().then((doc) => {
        if (doc.exists) {
            return doc.data().userCircles;
        } else {
            return null;
        }
    });

    // if userCircles is empty, send notification
    if (userCircles.length == 0) {
        const payload = {
            notification: {
                title: 'You havent joined or created any circles... yet!',
                body: "Click to join or create a circle and improve your feed!",
                sound: 'default'
            }
        };

        return admin.messaging().sendToDevice(userTokens, payload);
    } // else do    
    else {
        return null;
    }
});

// notification to prompt user to create an event every week 
exports.makeNewEventNotification = functions.pubsub.schedule('every 7 days').onRun((context) => {
    const payload = {
        notification: {
            title: 'You havent created an Event in a while!',
            body: "Click to create an Event and improve your feed!",
            sound: 'default'
        }
    };

    return admin.messaging().sendToTopic("universal", payload);
});

