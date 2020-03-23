const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firebase = require('firebase-admin');
let FieldValue = require('firebase-admin').firestore.FieldValue;
admin.initializeApp();
const fire = admin.firestore();

exports.deleteChain = functions.https.onCall((data, response) => {
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

exports.createChain = functions.https.onCall((data, response) => {
    console.log("FUCK");
    const fire1 = admin.firestore();
    const chainData = data.chainData;
    const chainID = chainData.chainUUID;
    const firstPost = data.firstPost;
    const userID = data.userID;
    const postID = firstPost.uuid;
    const birthdate = Date.parse(chainData.birthDate);
    const deathdate = Date.parse(chainData.deathDate);
    const postDate = Date.parse(firstPost.Time);

    chainData.birthDate = birthdate;
    chainData.deathDate = deathdate;
    firstPost.Time = postDate;

    const allChainRef = fire1.collection("chains").doc(chainID);
    const allChainPostRef = fire1.collection("chains").doc(chainID).collection("posts").doc(postID);
    const userCurrChainsRef = fire1.collection("users").doc(userID).collection("currentChains").doc(chainID);
    
    console.log(chainData);
    try{
        allChainRef.set(chainData); 
        allChainPostRef.set(firstPost);
        userCurrChainsRef.set(chainData); 
        return {"message":"success!"}
    }catch(error){
        console.log(error.toString());
        return {"message":"failed!"}
    }
})

exports.helloWorld = functions.https.onCall(async (data, response) => {
    console.log("FUCK");
    const fire1 = admin.firestore();
    const chainData = data.chainData;
    const chainID = chainData.chainUUID;
    const firstPost = data.firstPost;
    const userID = data.userID;
    const postID = firstPost.uuid;

    const birthTime = Date.parse(chainData.birthDate);
    const deathTime = Date.parse(chainData.deathDate);
    const postTime = Date.parse(firstPost.Time);

    console.log(birthTime, deathTime, postTime, chainData);

    birthSeconds = parseInt(birthTime / 1000, 10);
    deathSeconds = parseInt(deathTime / 1000, 10);
    postSeconds = parseInt(postTime / 1000, 10);

    console.log(birthSeconds, deathSeconds, postSeconds);

    const birthdate = new firebase.firestore.Timestamp(birthSeconds, 0);
    const deathdate = new firebase.firestore.Timestamp(deathSeconds, 0);
    const postdate = new firebase.firestore.Timestamp(postSeconds, 0);

    console.log(birthdate, deathdate, postdate);

    chainData.birthDate = birthdate;
    chainData.deathDate = deathdate;
    firstPost.Time = postdate;

    const allChainRef = fire1.collection("chains").doc(chainID);
    const allChainPostRef = fire1.collection("chains").doc(chainID).collection("posts").doc(postID);
    const userCurrChainsRef = fire1.collection("users").doc(userID).collection("currentChains").doc(chainID);
    


    console.log(chainData);
    try{
        await allChainRef.set(chainData); 
        await allChainPostRef.set(firstPost);
        await userCurrChainsRef.set(chainData); 
        return {"message":"success!"}
    }catch(error){
        console.error(error.toString());
        return {"message":"failed!"}
    }
})
