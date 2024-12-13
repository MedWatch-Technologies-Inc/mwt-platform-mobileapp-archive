package com.HealthGauge.services;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import com.zjw.zhbraceletsdk.application.ZhbraceletApplication;
import com.zjw.zhbraceletsdk.service.ZhBraceletService;

public class AlarmReceiver extends BroadcastReceiver {


    ZhBraceletService mBleService;
    Context context;

    //    E66DataListener e66DataListener;
    private String TAG = "TAG";

    @Override
    public void onReceive(Context context, Intent intent) {
//        Log.e("Tag" , "alarm receiver");

        /*try {
            if(intent != null){
                e66DataListener = (E66DataListener) intent.getSerializableExtra("interface");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
*/
        this.context = context;

        try {
            mBleService = ZhbraceletApplication.getZhBraceletService();
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (mBleService != null) {
            mBleService.syncTime();
        }


        try {
            Intent alarmIntent = new Intent(context, AlarmReceiver.class);
            int flags = 0;
            if (Build.VERSION.SDK_INT >= 31) {
                flags |= PendingIntent.FLAG_IMMUTABLE;
            }
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, alarmIntent, flags);

            AlarmManager manager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            if (manager != null) {
                manager.setInexactRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(), 1000, pendingIntent);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
