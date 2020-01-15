const functions = require('firebase-functions');
const admin = require('firebase-admin');
let FieldValue = require('firebase-admin').firestore.FieldValue;
admin.initializeApp();
//const stripe = require('stripe')(functions.config().stripe.token);
//const stripe = require('stripe')("sk_test_I3Dnqd88cs0C8kCH3V42QL3800wiWtA8Ok");
//const currency = functions.config().stripe.currency || 'USD';
//const currency = 'USD';

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
});

exports.postLiked = functions.firestore.document('/chains/{chainID}/posts/{postID}').onCreate(async (snap, context) => {
    const data = snap.data();
    const postID = context.params.postID;
    const chainID = context.params.chainID;
    console.log({data});
});

exports.addFriend = functions.https.onRequest((request, response) => {
    const data = snap.data();
    const mainUser = data.mainUser; //Should be the main users phone number
    const addedUser = data.addedUser; //the user that is being added to mains friend list: phone number
    console.log(`${ mainUser } is adding a friend: ${addedUser}...`);

    const fire = admin.firestore();
    const mainUserRef = fire.collection('/users').doc(mainUser).collection("friends").doc(addedUser);
    const addedUserRef = fire.collection('/users').doc(addedUser).collection("friends").doc(mainUser);
    try{
        await mainUserRef.set({"user" : addedUser}, {merge: true});
        await addedUserRef.set({"user" : mainUser}, {merge: true});
        return {"Message" : "Success!"};
    }catch(error){
        console.error(error);
        return {"Message":error};
    }
})

exports.appendChain = functions.https.onRequest((request, response) => {

})