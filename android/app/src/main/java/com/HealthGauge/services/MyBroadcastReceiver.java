package com.HealthGauge.services;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.HealthGauge.utils.Constants;
import com.HealthGauge.utils.PrefUtils;
import com.zjw.zhbraceletsdk.application.ZhbraceletApplication;
import com.zjw.zhbraceletsdk.service.ZhBraceletService;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;

public class MyBroadcastReceiver extends BroadcastReceiver {
    String TAG = getClass().getName();
    ArrayList<String> stringList = new ArrayList<>();
    private String id = "";
    private PrefUtils prefUtils;
    private Calendar  endTime;

    @Override
    public void onReceive(Context context, Intent intent) {
        prefUtils = new PrefUtils(context);
        ArrayList<String> days = null;
        Calendar calendar = Calendar.getInstance();
        if (intent.getStringArrayListExtra("map") != null) {
            days = intent.getStringArrayListExtra("map");
        }
        if (intent.getStringExtra("id") != null) {
            id = intent.getStringExtra("id");
        }
         if (intent.getIntExtra("endHour",-1) != -1 && intent.getIntExtra("endMinute",-1) != -1) {
            int hour = intent.getIntExtra("endHour",-1);
            int minute = intent.getIntExtra("endMinute",-1);
            endTime = Calendar.getInstance();
            endTime.set(Calendar.HOUR_OF_DAY, hour);
            endTime.set(Calendar.MINUTE, minute);
            endTime.set(Calendar.SECOND, 0);
        }
        Log.e(TAG, "onReceive: id" + id +"  endTime = "+endTime.toString());

        ZhBraceletService mBleService = ZhbraceletApplication.getZhBraceletService();
        if (mBleService != null) {
            String value = prefUtils.getString(Constants.PREF_ALARM_IDS);
            if (value != null && !value.isEmpty()) {
                stringList = new ArrayList<String>(Arrays.asList(value.split(",")));
            }
            if (stringList.contains(id) && ( days == null || days.size() == 0 || days.contains("" + calendar.get(Calendar.DAY_OF_WEEK) + ""))) {
                if(calendar.compareTo(endTime)<=0) {
                    mBleService.findDevice();
                }
            }

        }
    }
}