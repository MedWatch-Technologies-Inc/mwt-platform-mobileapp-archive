package com.HealthGauge.acitivity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;

import com.HealthGauge.R;
import com.HealthGauge.utils.Constants;
import com.HealthGauge.utils.weightScale.OnConfigureWeightScale;
import com.google.firebase.appindexing.Action;
import com.google.firebase.appindexing.FirebaseUserActions;
import com.google.firebase.appindexing.builders.AssistActionBuilder;

import java.util.HashMap;

import aicare.net.cn.iweightlibrary.AiFitSDK;
import aicare.net.cn.iweightlibrary.bleprofile.BleProfileServiceReadyActivity;
import aicare.net.cn.iweightlibrary.entity.AlgorithmInfo;
import aicare.net.cn.iweightlibrary.entity.BM09Data;
import aicare.net.cn.iweightlibrary.entity.BM15Data;
import aicare.net.cn.iweightlibrary.entity.BodyFatData;
import aicare.net.cn.iweightlibrary.entity.BroadData;
import aicare.net.cn.iweightlibrary.entity.DecimalInfo;
import aicare.net.cn.iweightlibrary.entity.User;
import aicare.net.cn.iweightlibrary.entity.WeightData;
import aicare.net.cn.iweightlibrary.utils.AicareBleConfig;
import aicare.net.cn.iweightlibrary.utils.L;
import aicare.net.cn.iweightlibrary.wby.WBYService;
import cn.net.aicare.MoreFatData;
import io.flutter.plugin.common.MethodChannel;

import static java.text.DateFormat.getDateTimeInstance;


public class ScanWeightScaleScreen extends BleProfileServiceReadyActivity implements OnConfigureWeightScale{
    String TAG = getClass().getSimpleName();

     WBYService.WBYBinder selectedDevice;

    FrameLayout frameLayout;

    MethodChannel flutterChannel;

    User user = new User(1, 2, 28, 170, 768, 551);

    byte unit = AicareBleConfig.UNIT_KG;

    static  OnConfigureWeightScale onConfigureWeightScale;
    private final BroadData.AddressComparator comparator = new BroadData.AddressComparator();



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test);
        onConfigureWeightScale = this;


        frameLayout = findViewById(R.id.frameLayout);
        frameLayout.setVisibility(View.GONE);

        //initialize weight scale sdk
        AiFitSDK.getInstance().init(this);

        //initiate google fit permission variables
//        googleAuthentication();

        //redirect to main activity to start flutter activity
        try {
            if(flutterChannel == null) {
                String url = null;
                Intent appLinkIntent = getIntent();
                if (appLinkIntent != null) {
                    Uri appLinkData = appLinkIntent.getData();
                    if (appLinkData != null) {
                        url = appLinkData.toString();
                    }
                }

                Intent intent = new Intent(ScanWeightScaleScreen.this, MainActivity.class);
                intent.putExtra(Constants.dynamicLinkUrl, url);
                startActivity(intent);
            }
            else{
                handleIntent();
                finish();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private static final String ACTION_TOKEN_EXTRA =
            "actions.fulfillment.extra.ACTION_TOKEN";

    void notifyActionStatus(String status) {
        String actionToken = getIntent().getStringExtra(ACTION_TOKEN_EXTRA);
        final Action action = new AssistActionBuilder()
                .setActionToken(actionToken)
                .setActionStatus(status)
                .build();
        FirebaseUserActions.getInstance(ScanWeightScaleScreen.this).end(action);
    }

    /*// On Action success
    notifyActionStatus(Action.Builder.STATUS_TYPE_COMPLETED);

    // On Action failed
    notifyActionStatus(Action.Builder.STATUS_TYPE_FAILED);*/

    void handleIntent() {
        try {
            String url = null;
            Intent intent = getIntent();

               Uri appLinkData = intent.getData();
               if(appLinkData != null) {
                   notifyActionStatus(Action.Builder.STATUS_TYPE_COMPLETED);
                    url = appLinkData.toString();
                }


            if (url != null) {
                Uri uri = Uri.parse(url);
                String path = uri.getPath();
                if (path != null && path.contains("features")) {
                    String queryValue = uri.getQueryParameter("featureName");
                    String methodName = "";
                    switch (queryValue) {
                        case "Start Measurement":
                            methodName = "Take Measurement";
                            break;
                        case "Stop Measurement":
                            methodName = "Stop Measurement";
                            break;
                    }
                    if(queryValue.toLowerCase().trim().contains("tell health gauge".trim())){
                        methodName = "Tell Health Gauge";
                    }

                    if(!methodName.trim().isEmpty()) {
                        String finalMethodName = methodName;
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if(flutterChannel != null) {
                                    flutterChannel.invokeMethod("onGetMeasurementQuery", finalMethodName);
                                }
                            }
                        });
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            notifyActionStatus(Action.Builder.STATUS_TYPE_FAILED);
        }
    }


    @Override
    protected void onError(String s, int i) {
        Log.e(TAG, "onError: " + s);
    }

    @Override
    protected void onGetWeightData(WeightData weightData) {
        try {
            HashMap<String, Object> hashMap = new HashMap<String, Object>();


            user.setAdc(weightData.getAdc());
//            user.setAdc(700);

            hashMap.put("cmdType", weightData.getCmdType());
            hashMap.put("temp", weightData.getTemp());
            hashMap.put("adc", weightData.getAdc());
//            hashMap.put("adc", 700);
            hashMap.put("algorithmType", weightData.getAlgorithmType());
            hashMap.put("unitType", weightData.getUnitType());
            hashMap.put("deviceType", weightData.getDeviceType());


            BodyFatData bm15BodyFatData = AicareBleConfig.getBM15BodyFatData(weightData, user.getSex(), user.getAge(), user.getHeight());
            hashMap.put("date", bm15BodyFatData.getDate());
            hashMap.put("time", bm15BodyFatData.getTime());
//            hashMap.put("weightsum", AicareBleConfig.getWeight(weightData.getWeight(), unit, weightData.getDecimalInfo()));
            hashMap.put("weightsum", AicareBleConfig.getWeight(weightData.getWeight(), AicareBleConfig.UNIT_KG, weightData.getDecimalInfo()));
            hashMap.put("BMI", bm15BodyFatData.getBmi());//BMI
            hashMap.put("fatRate", bm15BodyFatData.getBfr());// bodyfatRate
            hashMap.put("muscle", bm15BodyFatData.getRom());//muscle rate
            hashMap.put("boneMass", bm15BodyFatData.getBm());//boneMass
            hashMap.put("subcutaneousFat", bm15BodyFatData.getSfr());//subcutaneousFat rate
            hashMap.put("BMR", bm15BodyFatData.getBmr());//BMR
            hashMap.put("proteinRate", bm15BodyFatData.getPp());//proteinRate
            hashMap.put("visceralFat", bm15BodyFatData.getUvi());//visceralFat rate
            hashMap.put("moisture", bm15BodyFatData.getVwc());//moisture
            hashMap.put("bodyAge", bm15BodyFatData.getBodyAge());//physicalAge

            MoreFatData moreFatData = AicareBleConfig.getMoreFatData(user.getSex(), user.getHeight(), user.getWeight(),bm15BodyFatData.getBfr(),bm15BodyFatData.getRom(),bm15BodyFatData.getPp());
            hashMap.put("fatlevel", getFatLevelValue(moreFatData.getFatLevel()));//fatlevel
            hashMap.put("fatMass", moreFatData.getFat());//fatMass
            hashMap.put("muscleMass", moreFatData.getMuscleMass());//muscleMass
            hashMap.put("proteinMass", moreFatData.getProtein());//proteinMass
            hashMap.put("standardWeight", moreFatData.getStandardWeight());//standardWeight
            hashMap.put("weightControl", moreFatData.getControlWeight());//weightControl
            hashMap.put("weightWithoutFat", moreFatData.getRemoveFatWeight());//weightWithoutFat


            hashMap.put("number", bm15BodyFatData.getNumber());
            hashMap.put("sex", bm15BodyFatData.getSex());
            hashMap.put("physicalAge", bm15BodyFatData.getAge());
            hashMap.put("height", bm15BodyFatData.getHeight());
            hashMap.put("adc", bm15BodyFatData.getAdc());
//            hashMap.put("adc", 700);


            hashMap.put("SourceDecimal", weightData.getDecimalInfo().getSourceDecimal());
            hashMap.put("KgDecimal", weightData.getDecimalInfo().getKgDecimal());
            hashMap.put("LbDecimal", weightData.getDecimalInfo().getLbDecimal());
            hashMap.put("StDecimal", weightData.getDecimalInfo().getStDecimal());
            hashMap.put("KgGraduation", weightData.getDecimalInfo().getKgGraduation());
            hashMap.put("LbGraduation", weightData.getDecimalInfo().getLbGraduation());

            Log.i(TAG, "onGetWeightData: " + hashMap.toString());

            if (flutterChannel != null) {
                try {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            flutterChannel.invokeMethod("onGetWeightScaleData", hashMap);
                        }
                    });
                } catch (Exception e) {
                    Log.e(TAG, "onGetWeightData: ",e );
                    e.printStackTrace();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    int getFatLevelValue(MoreFatData.FatLevel data){
        switch (data){
            case UNDER:
                return  4;
            case THIN:
                return  2;
            case NORMAL:
                return  1;
            case OVER:
                return  3;
            case FAT:
                return  5;
        }
        return  0;
    }

    @Override
    protected void onGetSettingStatus(int i) {
        Log.i(TAG, "onGetSettingStatus: " + i);
        L.e(TAG, "SettingStatus = " + i);
        switch (i) {
            case AicareBleConfig.SettingStatus.NORMAL:
                try {
                    runOnUiThread(() -> flutterChannel.invokeMethod("onDeviceConnected",2));
                } catch (Exception e) {
                    Log.e(TAG, "onGetWeightData: ",e );
                    e.printStackTrace();
                }
                break;
            case AicareBleConfig.SettingStatus.LOW_POWER:
                try {
                    runOnUiThread(() -> flutterChannel.invokeMethod("onDeviceConnected",5));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case AicareBleConfig.SettingStatus.SET_TIME_SUCCESS:
                try {
                    runOnUiThread(() -> flutterChannel.invokeMethod("onDeviceConnected",2));
                } catch (Exception e) {
                    Log.e(TAG, "onGetWeightData: ",e );
                    e.printStackTrace();
                }
                showSnackBar("NORMAL");
                break;
            case AicareBleConfig.SettingStatus.SET_UNIT_SUCCESS:
                try {
                    runOnUiThread(() -> flutterChannel.invokeMethod("onDeviceConnected",2));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case AicareBleConfig.SettingStatus.ADC_MEASURED_ING:
                try {
                    runOnUiThread(() -> flutterChannel.invokeMethod("onDeviceConnected",3));
                } catch (Exception e) {
                    Log.e(TAG, "onGetWeightData: ",e );
                    e.printStackTrace();
                }
                showSnackBar("NORMAL");
                break;
            case AicareBleConfig.SettingStatus.ADC_ERROR:
                try {
                    runOnUiThread(() -> flutterChannel.invokeMethod("onDeviceConnected",7));
                } catch (Exception e) {
                    Log.e(TAG, "onGetWeightData: ",e );
                    e.printStackTrace();
                }
//                showSnackBar("NORMAL");
                break;
        }
    }

    private void showSnackBar(String str) {
//        Toast.makeText(this, "" + str, Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onGetResult(int i, String s) {
        Log.i(TAG, "onGetResult: " + s);

    }

    @Override
    protected void onGetFatData(boolean b, BodyFatData bodyFatData) {
        HashMap<String, Object> hashMap = new HashMap<String, Object>();

        Log.i(TAG, "onGetFatData: " + bodyFatData.toString());
        hashMap.put("date", bodyFatData.getDate());
        hashMap.put("time", bodyFatData.getTime());
//        hashMap.put("weightsum", AicareBleConfig.getWeight(bodyFatData.getWeight(), unit, bodyFatData.getDecimalInfo()));
        hashMap.put("weightsum", AicareBleConfig.getWeight(bodyFatData.getWeight(), AicareBleConfig.UNIT_KG, bodyFatData.getDecimalInfo()));
        hashMap.put("BMI", bodyFatData.getBmi());//BMI
        hashMap.put("fatRate", bodyFatData.getBfr());// bodyfatRate
        hashMap.put("muscle", bodyFatData.getRom());//muscle rate
        hashMap.put("boneMass", bodyFatData.getBm());//boneMass
        hashMap.put("subcutaneousFat", bodyFatData.getSfr());//subcutaneousFat rate
        hashMap.put("BMR", bodyFatData.getBmr());//BMR
        hashMap.put("proteinRate", bodyFatData.getPp());//proteinRate
        hashMap.put("visceralFat", bodyFatData.getUvi());//visceralFat rate
        hashMap.put("moisture", bodyFatData.getVwc());//moisture
        hashMap.put("bodyAge", bodyFatData.getBodyAge());//physicalAge

        MoreFatData moreFatData = AicareBleConfig.getMoreFatData(user.getSex(), user.getHeight(), bodyFatData.getWeight(),bodyFatData.getBfr(),bodyFatData.getRom(),bodyFatData.getPp());
        hashMap.put("fatlevel", getFatLevelValue(moreFatData.getFatLevel()));//fatlevel
        hashMap.put("fatMass", moreFatData.getFat());//fatMass
        hashMap.put("muscleMass", moreFatData.getMuscleMass());//muscleMass
        hashMap.put("proteinMass", moreFatData.getProtein());//proteinMass
        hashMap.put("standardWeight", moreFatData.getStandardWeight());//standardWeight
        hashMap.put("weightControl", moreFatData.getControlWeight());//weightControl
        hashMap.put("weightWithoutFat", moreFatData.getRemoveFatWeight());//weightWithoutFat


        hashMap.put("number", bodyFatData.getNumber());
        hashMap.put("sex", bodyFatData.getSex());
        hashMap.put("physicalAge", bodyFatData.getAge());
        hashMap.put("height", bodyFatData.getHeight());
        hashMap.put("adc", bodyFatData.getAdc());
//        hashMap.put("adc", 700);


        hashMap.put("SourceDecimal", bodyFatData.getDecimalInfo().getSourceDecimal());
        hashMap.put("KgDecimal", bodyFatData.getDecimalInfo().getKgDecimal());
        hashMap.put("LbDecimal", bodyFatData.getDecimalInfo().getLbDecimal());
        hashMap.put("StDecimal", bodyFatData.getDecimalInfo().getStDecimal());
        hashMap.put("KgGraduation", bodyFatData.getDecimalInfo().getKgGraduation());
        hashMap.put("LbGraduation", bodyFatData.getDecimalInfo().getLbGraduation());

        Log.i(TAG, "onGetFatData: " + hashMap.toString());

        if (flutterChannel != null) {
            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        flutterChannel.invokeMethod("onGetWeightScaleData", hashMap);
                    }
                });
            } catch (Exception e) {
                Log.e(TAG, "onGetWeightData: ",e );
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void onGetDecimalInfo(DecimalInfo decimalInfo) {
        Log.i(TAG, "onGetDecimalInfo: " + decimalInfo.toString());
    }

    @Override
    protected void onGetAlgorithmInfo(AlgorithmInfo algorithmInfo) {
        Log.i(TAG, "onGetAlgorithmInfo: ");
    }


    @Override
    protected void onServiceBinded(WBYService.WBYBinder wbyBinder) {
        Log.i(TAG, "onServiceBinded: ");
        selectedDevice = wbyBinder;
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("address",selectedDevice.getDeviceAddress());
        hashMap.put("name",selectedDevice.getDeviceName());
        hashMap.put("isWeightScaleDevice",true);
        hashMap.put("status",1);
        if (flutterChannel != null) {
            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        flutterChannel.invokeMethod("onDeviceConnected",1);
                    }
                });
            } catch (Exception e) {
                Log.e(TAG, "onGetWeightData: ",e );
                e.printStackTrace();
            }
        }
        if(selectedDevice != null) {
            selectedDevice.syncUnit(this.unit);
        }
    }

    @Override
    protected void onServiceUnbinded() {
        Log.i(TAG, "onServiceUnbinded: ");
        selectedDevice = null;
    }

    @Override
    protected void getAicareDevice(BroadData broadData) {
        Log.i(TAG, "getAicareDevice: ");
        if (broadData != null) {

            comparator.address = broadData.getAddress();

            stopScan();
            startConnect(broadData.getAddress());

            if (broadData.getDeviceType() == AicareBleConfig.BM_09) {
                if (broadData.getSpecificData() != null) {
                    BM09Data data = AicareBleConfig.getBm09Data(broadData.getAddress(), broadData.getSpecificData());
                    Log.i(TAG, "getAicareDevice: " + data.toString());
                } else if (broadData.getDeviceType() == AicareBleConfig.BM_15) {
                    if (broadData.getSpecificData() != null) {
                        BM15Data data = AicareBleConfig.getBm15Data(broadData.getAddress(), broadData.getSpecificData());
                        Log.i(TAG, "getAicareDevice: " + data.toString());
                    }
                } else {
                    if (broadData.getSpecificData() != null) {
                        WeightData weightData = AicareBleConfig.getWeightData(broadData.getSpecificData());
                        Log.i(TAG, "getAicareDevice: " + weightData.toString());

                    }
                }

            }
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    @Override
    public void initialiseChannel(MethodChannel channel) {
        flutterChannel  = channel;
    }

    @Override
    public void onStartScanning() {
        try {
            startScan();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onStopScanning() {
        try {
            stopScan();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetUserInformation(User user) {
        this.user = user;
        if(selectedDevice != null) {
            selectedDevice.syncUser(this.user);
        }
    }

    @Override
    public void onSetUnit(int unit) {
        try {
            this.unit = AicareBleConfig.UNIT_KG;
            if(unit == 1){
                this.unit = AicareBleConfig.UNIT_LB;
            }
            if(selectedDevice != null) {
                selectedDevice.syncUnit(this.unit);
                selectedDevice.syncUser(this.user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDisconnect() {
        try {
            if(selectedDevice != null) {
                selectedDevice.disconnect();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}