const functions = require('firebase-functions');
const admin = require('firebase-admin');
let FieldValue = require('firebase-admin').firestore.FieldValue;

exports.deleteChain = () => functions.https.onRequest((data, response) => {
    let chainID = request.chain;
    let userID = request.user;

    const allChainRef = fire.collection("/chains").doc(chainID);
    const userCurrChainsRef = fire.collection("/users").doc(userID).collection("currentChains").doc(chainID);
    const userFeedRef = fire.collection("/users").doc(userID).collection("feed").doc(chainID);

    try{
        let deleteDoc1 = allChainRef.delete();
        let deleteDoc2 = userCurrChainsRef.delete();
        let deleteDoc3 = userFeedRef.delete();
        return {"message":"success!"}
    }catch(error){
        console.error(error.toString());
        return {"message":"failed!"}
    }

})

exports.fuck = functions.firestore.document('/chains/{chainID}/posts/{postID}').onCreate(async (snap, context) => {

})
