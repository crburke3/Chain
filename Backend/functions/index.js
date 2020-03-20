const functions = require('firebase-functions');
const admin = require('firebase-admin');
let FieldValue = require('firebase-admin').firestore.FieldValue;
admin.initializeApp();
chainFuncs = require("./ChainFunctions");

exports.deleteChain = functions.https.onCall((data, response) => {
    const fire = admin.firestore();
    let chainID = data.chain;
    let userID = data.user;
    console.log(chainID, userID);
    console.log(data);

    const allChainRef = fire.collection("chains").doc(chainID);
    const userCurrChainsRef = fire.collection("users").doc(userID).collection("currentChains").doc(chainID);
    const userFeedRef = fire.collection("users").doc(userID).collection("feed").doc(chainID);

    try{
        const fuck = allChainRef.delete();
        console.log(fuck);
        userCurrChainsRef.delete();
        userFeedRef.delete();
        return {"message":"success!"}
    }catch(error){
        console.error(error.toString());
        return {"message":"failed!"}
    }

})

async function deleteIt(){

}