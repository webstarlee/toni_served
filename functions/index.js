/*
 * Functions SDK : is required to work with firebase functions.
 * Admin SDK : is required to send Notification using functions.
 */

'use strict'

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


/*
 * 'OnWrite' works as 'addValueEventListener' for android. It will fire the function
 * everytime there is some item added, removed or changed from the provided 'database.ref'
 * 'sendNotification' is the name of the function, which can be changed according to
 * your requirement
 */

exports.orderSend = functions.database.ref('/res_order/{res_id}/{order_id}').onCreate(event => {


  /*
   * You can store values as variables from the 'database.ref'
   * Just like here, I've done for 'user_id' and 'notification'
   */

  const res_id = event.params.res_id;
  const order_id = event.params.order_id;

  console.log('order notification start');

  /*
   * Stops proceeding to the rest of the function if the entry is deleted from database.
   * If you want to work with what should happen when an entry is deleted, you can replace the
   * line from "return console.log.... "
   */

  if(!event.data.val()){

    return console.log('A Notification has been deleted from the database : ', order_id);

  }

  /*
   * 'fromUser' query retreives the ID of the user who sent the notification
   */

  const fromUser = admin.database().ref(`/res_order/${res_id}/${order_id}`).once('value');

  return fromUser.then(fromUserResult => {

    const from_user_id = fromUserResult.val().table_number;

    console.log('notification order from : ', from_user_id);

    /*
     * The we run two queries at a time using Firebase 'Promise'.
     * One to get the name of the user who sent the notification
     * another one to get the devicetoken to the device we want to send notification to
     */

    // const userQuery = admin.database().ref(`Users/${from_user_id}/name`).once('value');
    const deviceToken = admin.database().ref(`/res_list/${res_id}/device_token`).once('value');

    return Promise.all([deviceToken]).then(result => {

      const token_id = result[0].val();

      /*
       * We are creating a 'payload' to create a notification to be sent.
       */

       return admin.database().ref(`device_badge/${res_id}`).once('value', (snapshot) => {

       	var string_badgenumber = snapshot.val();

       	var currentbadgenumber = parseInt(string_badgenumber) + 1;

       	var badgeNumber = currentbadgenumber.toString();

	    admin.database().ref(`device_badge/${res_id}`).set(badgeNumber);

       	console.log(`this badge number is ${badgeNumber}`);

	      const payload = {
	        notification: {
	          title : "NY BESTÄLLNINGSBEGÄRAN",
	          body: "NY BESTÄLLNINGSBEGÄRAN",
	          sound: "default",
	          badge: `${badgeNumber}`
	        }
	      };

	      /*
	       * Then using admin.messaging() we are sending the payload notification to the token_id of
	       * the device we retreived.
	       */

	      return admin.messaging().sendToDevice(token_id, payload).then(response => {

	        console.log('This was the notification Feature');

	      });
	  });

    });

  });

});

exports.reservationSend = functions.database.ref('/res_reservation/{res_id}/{reservation_id}').onCreate(event => {


  /*
   * You can store values as variables from the 'database.ref'
   * Just like here, I've done for 'user_id' and 'notification'
   */

  const res_id = event.params.res_id;
  const reservation_id = event.params.reservation_id;

  console.log('new reservation notification start');

  /*
   * Stops proceeding to the rest of the function if the entry is deleted from database.
   * If you want to work with what should happen when an entry is deleted, you can replace the
   * line from "return console.log.... "
   */

  if(!event.data.val()){

    return console.log('A Notification has been deleted from the database : ', reservation_id);

  }

  /*
   * 'fromUser' query retreives the ID of the user who sent the notification
   */

  const fromUser = admin.database().ref(`/res_reservation/${res_id}/${reservation_id}`).once('value');

  return fromUser.then(fromUserResult => {

  	const from_user = fromUserResult.val().name;
    /*
     * The we run two queries at a time using Firebase 'Promise'.
     * One to get the name of the user who sent the notification
     * another one to get the devicetoken to the device we want to send notification to
     */

    // const userQuery = admin.database().ref(`Users/${from_user_id}/name`).once('value');
    const deviceToken = admin.database().ref(`/res_list/${res_id}/device_token`).once('value');

    return Promise.all([deviceToken]).then(result => {

      const token_id = result[0].val();

      /*
       * We are creating a 'payload' to create a notification to be sent.
       */

       return admin.database().ref(`device_badge/${res_id}`).once('value', (snapshot) => {

       	var string_badgenumber = snapshot.val();

       	var currentbadgenumber = parseInt(string_badgenumber) + 1;

       	var badgeNumber = currentbadgenumber.toString();

	    admin.database().ref(`device_badge/${res_id}`).set(badgeNumber);

       	console.log(`this badge number is ${badgeNumber}`);

	      const payload = {
	        notification: {
	          title : "NNY FÖRFRÅGAN OM BORDSBOKNING",
	          body: "NY FÖRFRÅGAN OM BORDSBOKNING",
	          sound: "default",
	          badge: `${badgeNumber}`
	        }
	      };

	      /*
	       * Then using admin.messaging() we are sending the payload notification to the token_id of
	       * the device we retreived.
	       */

	      return admin.messaging().sendToDevice(token_id, payload).then(response => {

	        console.log('This was the notification Feature');

	      });
	  });

    });

  });

});

exports.orderServe = functions.database.ref('/res_order/{res_id}/{order_id}/state').onUpdate(event => {


  /*
   * You can store values as variables from the 'database.ref'
   * Just like here, I've done for 'user_id' and 'notification'
   */

  const res_id = event.params.res_id;
  const order_id = event.params.order_id;

  console.log('order serve notification serve start');

  /*
   * Stops proceeding to the rest of the function if the entry is deleted from database.
   * If you want to work with what should happen when an entry is deleted, you can replace the
   * line from "return console.log.... "
   */

  if(!event.data.val()){

    return console.log('A Notification has been deleted from the database : ', order_id);

  }

  /*
   * 'fromUser' query retreives the ID of the user who sent the notification
   */

  const fromUser = admin.database().ref(`/res_order/${res_id}/${order_id}`).once('value');

  return fromUser.then(fromUserResult => {

	const served_type = fromUserResult.val().state;
	const guest_uid = fromUserResult.val().guest_uuid

	var sered_to = "";
	if(served_type == "served")
	{
		sered_to = "ÄR PÅVÄG";
	}
	else if(served_type == "picked")
	{
		sered_to = "HÄMTAS SJÄLV";
	}

	const fromres = admin.database().ref(`/res_list/${res_id}`).once('value');

	return fromres.then(fromResResult => {

		const res_name = fromResResult.val().name.toUpperCase();
	    /*
	     * The we run two queries at a time using Firebase 'Promise'.
	     * One to get the name of the user who sent the notification
	     * another one to get the devicetoken to the device we want to send notification to
	     */

	    // const userQuery = admin.database().ref(`Users/${from_user_id}/name`).once('value');
	    const deviceToken = admin.database().ref(`/res_order/${res_id}/${order_id}/guest_token`).once('value');

	    return Promise.all([deviceToken]).then(result => {

	      const token_id = result[0].val();

	      /*
	       * We are creating a 'payload' to create a notification to be sent.
	       */

	       return admin.database().ref(`device_badge/${guest_uid}`).once('value', (snapshot) => {

	       	var string_badgenumber = snapshot.val();

	       	var currentbadgenumber = parseInt(string_badgenumber) + 1;

	       	var badgeNumber = currentbadgenumber.toString();

	       	admin.database().ref(`device_badge/${guest_uid}`).set(badgeNumber);

       		console.log(`this badge number is ${badgeNumber}`);

		      const payload = {
		        notification: {
		          title : "BESTÄLLNING ÄR FÄRDIG",
		          body: `${sered_to}`,
		          sound: "default",
		          badge: `${badgeNumber}`
		        }
		      };

		      /*
		       * Then using admin.messaging() we are sending the payload notification to the token_id of
		       * the device we retreived.
		       */

		      return admin.messaging().sendToDevice(token_id, payload).then(response => {

		        console.log('This was the notification Feature');

		      });
		  });

	    });
	});

  });

});

exports.reservationServe = functions.database.ref('/res_reservation/{res_id}/{reservation_id}/state').onUpdate(event => {

	console.log('reservation serve notification start');

	const res_id = event.params.res_id;
	const reservation_id = event.params.reservation_id;

	/*
	* 'fromUser' query retreives the ID of the user who sent the notification
	*/

	const fromUser = admin.database().ref(`/res_reservation/${res_id}/${reservation_id}`).once('value');

	return fromUser.then(fromUserResult => {

		const served_type = fromUserResult.val().state;
		const guest_uid = fromUserResult.val().guest_uuid

		var served_to = "NULL";
		if(served_type == "accept")
		{
			served_to = "ACCEPTERAD";
		}
		else if(served_type == "reject")
		{
			served_to = "AVVISADE";
		}

		const fromres = admin.database().ref(`/res_list/${res_id}`).once('value');

		return fromres.then(fromResResult => {

			const res_name = fromResResult.val().name.toUpperCase();
		    /*
		     * The we run two queries at a time using Firebase 'Promise'.
		     * One to get the name of the user who sent the notification
		     * another one to get the devicetoken to the device we want to send notification to
		     */

		    // const userQuery = admin.database().ref(`Users/${from_user_id}/name`).once('value');
		    const deviceToken = admin.database().ref(`/res_reservation/${res_id}/${reservation_id}/guest_token`).once('value');

		    return Promise.all([deviceToken]).then(result => {

		      const token_id = result[0].val();

		      /*
		       * We are creating a 'payload' to create a notification to be sent.
		       */

		       return admin.database().ref(`device_badge/${guest_uid}`).once('value', (snapshot) => {

		       	var string_badgenumber = snapshot.val();

		       	var currentbadgenumber = parseInt(string_badgenumber) + 1;

		       	var badgeNumber = currentbadgenumber.toString();

		       	admin.database().ref(`device_badge/${guest_uid}`).set(badgeNumber);

		   		console.log(`this badge number is ${badgeNumber}`);

			      const payload = {
			        notification: {
			          title : "BOKNING ÄR KLAR",
			          body: `${served_to}`,
			          sound: "default",
			          badge: `${badgeNumber}`
			        }
			      };

			      /*
			       * Then using admin.messaging() we are sending the payload notification to the token_id of
			       * the device we retreived.
			       */

					return admin.messaging().sendToDevice(token_id, payload).then(response => {

					console.log('This was the notification Feature');

					});
			  	});

		    });
		});

	});

});

exports.callStaff = functions.database.ref('/res_staff_call/{res_id}/{staffcall_id}').onCreate(event => {


  /*
   * You can store values as variables from the 'database.ref'
   * Just like here, I've done for 'user_id' and 'notification'
   */

  const res_id = event.params.res_id;
  const staffcall_id = event.params.staffcall_id;

  console.log('notification order start');

  /*
   * Stops proceeding to the rest of the function if the entry is deleted from database.
   * If you want to work with what should happen when an entry is deleted, you can replace the
   * line from "return console.log.... "
   */

  if(!event.data.val()){

    return console.log('A Notification has been deleted from the database : ', staffcall_id);

  }

  /*
   * 'fromUser' query retreives the ID of the user who sent the notification
   */

  const fromUser = admin.database().ref(`/res_staff_call/${res_id}/${staffcall_id}`).once('value');

  return fromUser.then(fromUserResult => {

    const from_user_id = fromUserResult.val().table_number;

    console.log('notification order from : ', from_user_id);

    /*
     * The we run two queries at a time using Firebase 'Promise'.
     * One to get the name of the user who sent the notification
     * another one to get the devicetoken to the device we want to send notification to
     */

    // const userQuery = admin.database().ref(`Users/${from_user_id}/name`).once('value');
    const deviceToken = admin.database().ref(`/res_list/${res_id}/device_token`).once('value');

    return Promise.all([deviceToken]).then(result => {

      const token_id = result[0].val();

      /*
       * We are creating a 'payload' to create a notification to be sent.
       */

       return admin.database().ref(`device_badge/${res_id}`).once('value', (snapshot) => {

       	var string_badgenumber = snapshot.val();

       	var currentbadgenumber = parseInt(string_badgenumber) + 1;

       	var badgeNumber = currentbadgenumber.toString();

	    admin.database().ref(`device_badge/${res_id}`).set(badgeNumber);

       	console.log(`this badge number is ${badgeNumber}`);

	      const payload = {
	        notification: {
	          title : "PERSONAL RINGAR",
	          body: `PERSONAL RINGAR FRÅN TABELLNUMMER : ${from_user_id}`,
	          sound: "default",
	          badge: `${badgeNumber}`
	        }
	      };

	      /*
	       * Then using admin.messaging() we are sending the payload notification to the token_id of
	       * the device we retreived.
	       */

	      return admin.messaging().sendToDevice(token_id, payload).then(response => {

	        console.log('This was the notification Feature');

	      });
	  });

    });

  });

});

exports.feedback = functions.database.ref('/res_feedback/{res_id}/{feedback_id}').onCreate(event => {


  /*
   * You can store values as variables from the 'database.ref'
   * Just like here, I've done for 'user_id' and 'notification'
   */

  const res_id = event.params.res_id;
  const feedback_id = event.params.feedback_id;

  console.log('notification order start');

    /*
     * The we run two queries at a time using Firebase 'Promise'.
     * One to get the name of the user who sent the notification
     * another one to get the devicetoken to the device we want to send notification to
     */

    // const userQuery = admin.database().ref(`Users/${from_user_id}/name`).once('value');
    const deviceToken = admin.database().ref(`/res_list/${res_id}/device_token`).once('value');

    return Promise.all([deviceToken]).then(result => {

      const token_id = result[0].val();

      /*
       * We are creating a 'payload' to create a notification to be sent.
       */

       return admin.database().ref(`device_badge/${res_id}`).once('value', (snapshot) => {

       	var string_badgenumber = snapshot.val();

       	var currentbadgenumber = parseInt(string_badgenumber) + 1;

       	var badgeNumber = currentbadgenumber.toString();

	    admin.database().ref(`device_badge/${res_id}`).set(badgeNumber);

       	console.log(`this badge number is ${badgeNumber}`);

	      const payload = {
	        notification: {
	          title : "NYA ÅTERKOPPLING",
	          body: "MOTTAGEN NYA ÅTERKOPPLING",
	          sound: "default",
	          badge: `${badgeNumber}`
	        }
	      };

	      /*
	       * Then using admin.messaging() we are sending the payload notification to the token_id of
	       * the device we retreived.
	       */

	      return admin.messaging().sendToDevice(token_id, payload).then(response => {

	        console.log('This was the notification Feature');

	      });
	  });
   });

});
