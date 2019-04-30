package com.example.beamstutorial

import android.os.AsyncTask
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Base64
import android.util.Log
import com.pusher.pushnotifications.BeamsCallback
import com.pusher.pushnotifications.PushNotifications;
import com.pusher.pushnotifications.PusherCallbackError
import com.pusher.pushnotifications.auth.AuthData
import com.pusher.pushnotifications.auth.AuthDataGetter
import com.pusher.pushnotifications.auth.BeamsTokenProvider

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // replace this instance ID with your own
        val instanceId = "28b93e66-286e-44d5-8486-8ac14ce18d91"
        PushNotifications.start(getApplicationContext(), instanceId)

        // Interests
        PushNotifications.addDeviceInterest("apples")

        // Authenticated user
        RegisterMeWithPusher().execute()
    }

    class RegisterMeWithPusher : AsyncTask<Void, Void, Void>() {
        override fun doInBackground(vararg params: Void): Void? {

            // hardcoding the username and password both here and on the server
            val username = "Mary"
            val password = "mypassword"
            val text = "$username:$password"
            val data = text.toByteArray()
            val base64 = Base64.encodeToString(data, Base64.NO_WRAP)

            // get the token from the server
            val serverUrl = "http://10.0.2.2:8888/token"
            val tokenProvider = BeamsTokenProvider(
                serverUrl,
                object: AuthDataGetter {
                    override fun getAuthData(): AuthData {
                        return AuthData(
                            headers = hashMapOf(
                                "Authorization" to "Basic $base64"
                            )
                        )
                    }
                }
            )

            // send the token to Pusher
            PushNotifications.setUserId(
                username,
                tokenProvider,
                object : BeamsCallback<Void, PusherCallbackError> {
                    override fun onFailure(error: PusherCallbackError) {
                        Log.e("BeamsAuth",
                            "Could not login to Beams: ${error.message}");
                    }
                    override fun onSuccess(vararg values: Void) {
                        Log.i("BeamsAuth", "Beams login success");
                    }
                }
            )

            return null
        }
    }
}
