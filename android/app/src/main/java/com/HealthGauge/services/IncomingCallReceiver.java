package com.HealthGauge.services;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.HealthGauge.utils.ITelephony;


public class IncomingCallReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {

        ITelephony telephonyService;
        try {
            String state = intent.getStringExtra(TelephonyManager.EXTRA_STATE);
            String number = intent.getExtras().getString(TelephonyManager.EXTRA_INCOMING_NUMBER);

            if(state.equalsIgnoreCase(TelephonyManager.EXTRA_STATE_RINGING)){
 
                Intent msgrcv = new Intent("Msg");
                msgrcv.putExtra("package", "com.luutinhit.secureincomingcall");
                msgrcv.putExtra("title", "Call");
                msgrcv.putExtra("text", "ABC");
                LocalBroadcastManager.getInstance(context).sendBroadcast(msgrcv);
                TelephonyManager tmgr = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
                MyPhoneStateListener PhoneListener = new MyPhoneStateListener();
                tmgr.listen(PhoneListener, PhoneStateListener.LISTEN_CALL_STATE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private class MyPhoneStateListener extends PhoneStateListener {
        public void onCallStateChanged(int state, String incomingNumber) {
            if (state == 1) {
                String msg = "New Phone Call Event. Incoming Number: " + incomingNumber;
            }
        }
    }
}