package com.HealthGauge.app;


import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;

import androidx.multidex.MultiDex;

import com.HealthGauge.e66.ConnectEvent;
import com.zjw.zhbraceletsdk.application.ZhbraceletApplication;
import com.zjw.zhbraceletsdk.service.ZhBraceletService;

import com.yucheng.ycbtsdk.Response.BleConnectResponse;
import com.yucheng.ycbtsdk.YCBTClient;

import org.greenrobot.eventbus.EventBus;

public class  MyApplication extends ZhbraceletApplication {

    private static MyApplication instance = null;

    public static MyApplication getInstance() {
        return instance;
    }

    public void onCreate() {
        super.onCreate();

        String currentProcessName = getCurProcessName(this);

        if ("com.HealthGauge".equals(currentProcessName)) {

            Log.e("device","...onCreate.....");

            instance = this;
            YCBTClient.initClient(this,true);
            YCBTClient.registerBleStateChange(bleConnectResponse);


        }
    }

    protected void attachBaseContext(Context base)
    {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    final BleConnectResponse bleConnectResponse = new BleConnectResponse() {
        @Override
        public void onConnectResponse(int var1) {

            Log.e("device", "...connect..state....." + var1);

            if (var1 == 0) {
                EventBus.getDefault().post(new ConnectEvent());
            }
        }
    };

    /**
     * 需要重写
     *Need to rewrite
     * @param context
     */
    public void openBleService(Context context) {
        Intent intent = new Intent(context, ZhBraceletService.class);
        context.bindService(intent, mServiceConnection, Context.BIND_AUTO_CREATE);
    }

    /**
     * 需要重写
     *Need to rewrite
     */
    public ServiceConnection mServiceConnection = new ServiceConnection() {

        @Override
        public void onServiceDisconnected(ComponentName name) {
            ZhbraceletApplication.setZhBraceletService(null);


        }

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {


            ZhbraceletApplication.setZhBraceletService(((ZhBraceletService.LocalBinder) service).getService());


        }
    };

    private String getCurProcessName(Context context) {
        int pid = android.os.Process.myPid();
        ActivityManager mActivityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningAppProcessInfo appProcess : mActivityManager.getRunningAppProcesses()) {
            if (appProcess.pid == pid) {
                return appProcess.processName;
            }
        }
        return null;
    }

}
