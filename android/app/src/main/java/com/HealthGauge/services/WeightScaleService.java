package com.HealthGauge.services;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import aicare.net.cn.iweightlibrary.bleprofile.BleProfileServiceReadyActivity;
import aicare.net.cn.iweightlibrary.entity.AlgorithmInfo;
import aicare.net.cn.iweightlibrary.entity.BodyFatData;
import aicare.net.cn.iweightlibrary.entity.BroadData;
import aicare.net.cn.iweightlibrary.entity.DecimalInfo;
import aicare.net.cn.iweightlibrary.entity.WeightData;
import aicare.net.cn.iweightlibrary.wby.WBYService;

public class WeightScaleService extends Service {

    /** indicates how to behave if the service is killed */
    int mStartMode;

    /** interface for clients that bind */
    IBinder mBinder;

    /** indicates whether onRebind should be used */
    boolean mAllowRebind;

    MyWeightScale myWeightScale;

    /** Called when the service is being created. */
    @Override
    public void onCreate() {
        myWeightScale = new MyWeightScale();
        Log.i("TAG", "onCreate: ");
    }

    /** The service is starting, due to a call to startService() */
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return mStartMode;
    }

    /** A client is binding to the service with bindService() */
    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    /** Called when all clients have unbound with unbindService() */
    @Override
    public boolean onUnbind(Intent intent) {
        return mAllowRebind;
    }

    /** Called when a client is binding to the service with bindService()*/
    @Override
    public void onRebind(Intent intent) {

    }

    /** Called when The service is no longer used and is being destroyed */
    @Override
    public void onDestroy() {

    }
}

class MyWeightScale extends BleProfileServiceReadyActivity {

    public MyWeightScale() {
        try {
            startScan();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onError(String s, int i) {

    }

    @Override
    protected void onGetWeightData(WeightData weightData) {

    }

    @Override
    protected void onGetSettingStatus(int i) {

    }

    @Override
    protected void onGetResult(int i, String s) {

    }

    @Override
    protected void onGetFatData(boolean b, BodyFatData bodyFatData) {

    }

    @Override
    protected void onGetDecimalInfo(DecimalInfo decimalInfo) {

    }

    @Override
    protected void onGetAlgorithmInfo(AlgorithmInfo algorithmInfo) {

    }

    @Override
    protected void onServiceBinded(WBYService.WBYBinder wbyBinder) {

    }

    @Override
    protected void onServiceUnbinded() {

    }

    @Override
    protected void getAicareDevice(BroadData broadData) {

    }
}