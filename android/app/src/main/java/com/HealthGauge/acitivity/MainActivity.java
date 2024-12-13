package com.HealthGauge.acitivity;

import static android.Manifest.permission.ACCESS_FINE_LOCATION;
import static com.HealthGauge.acitivity.ScanWeightScaleScreen.onConfigureWeightScale;
import static com.google.android.gms.fitness.data.DataType.TYPE_HEART_RATE_BPM;
import static com.google.android.gms.fitness.data.DataType.TYPE_WEIGHT;
import static com.google.android.gms.fitness.data.HealthDataTypes.TYPE_BLOOD_PRESSURE;

import android.Manifest;
import android.app.ActivityManager;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.core.app.ActivityCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.HealthGauge.R;
import com.HealthGauge.connection.ConnectionSingleton;
import com.HealthGauge.e66.ConnectEvent;
import com.HealthGauge.e66.E66DataListener;
import com.HealthGauge.models.AlarmModel;
import com.HealthGauge.models.BLEDeviceModel;
import com.HealthGauge.models.CollectECGModel;
import com.HealthGauge.models.DeviceInfoModel;
import com.HealthGauge.models.DeviceModel;
import com.HealthGauge.models.E80AlarmModel;
import com.HealthGauge.models.EcgInfoModel;
import com.HealthGauge.models.HeartInfoModel;
import com.HealthGauge.models.LeadStatusModel;
import com.HealthGauge.models.MotionInfoModel;
import com.HealthGauge.models.OfflineEcgInfoModel;
import com.HealthGauge.models.PpgInfoModel;
import com.HealthGauge.models.SleepDataInfo;
import com.HealthGauge.models.SleepInfoModel;
import com.HealthGauge.models.WoHeartInfoModel;
import com.HealthGauge.services.NotificationService;
import com.HealthGauge.utils.Constants;
import com.HealthGauge.utils.GoogleFitData;
import com.HealthGauge.utils.Utils;
import com.HealthGauge.utils.connections.BLEDeviceScanListener;
import com.HealthGauge.utils.connections.Connections;
import com.HealthGauge.utils.connections.DeviceScanListener;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.fitness.FitnessOptions;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.HealthDataTypes;
import com.google.android.gms.tasks.Task;
import com.yucheng.ycbtsdk.Response.BleConnectResponse;
import com.zjw.zhbraceletsdk.application.ZhbraceletApplication;
import com.zjw.zhbraceletsdk.bean.DeviceInfo;
import com.zjw.zhbraceletsdk.bean.EcgInfo;
import com.zjw.zhbraceletsdk.bean.HeartInfo;
import com.zjw.zhbraceletsdk.bean.MotionInfo;
import com.zjw.zhbraceletsdk.bean.OffLineEcgInfo;
import com.zjw.zhbraceletsdk.bean.PoHeartInfo;
import com.zjw.zhbraceletsdk.bean.PpgInfo;
import com.zjw.zhbraceletsdk.bean.SleepData;
import com.zjw.zhbraceletsdk.bean.SleepInfo;
import com.zjw.zhbraceletsdk.bean.WoHeartInfo;
import com.zjw.zhbraceletsdk.linstener.ConnectorListener;
import com.zjw.zhbraceletsdk.linstener.SimplePerformerListener;
import com.zjw.zhbraceletsdk.service.ZhBraceletService;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import aicare.net.cn.iweightlibrary.entity.User;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


import no.nordicsemi.android.support.v18.scanner.BluetoothLeScannerCompat;
import no.nordicsemi.android.support.v18.scanner.ScanCallback;
import no.nordicsemi.android.support.v18.scanner.ScanResult;
import no.nordicsemi.android.support.v18.scanner.ScanSettings;

public class MainActivity extends FlutterActivity implements DeviceScanListener, E66DataListener, BleConnectResponse, BLEDeviceScanListener {


    private static final String CHANNEL = "com.helthgauge";
    private final String TAG = "Flutter_APP";
    MethodChannel channel;


    Context context = MainActivity.this;
    MethodChannel.Result resultForConnect;
    MethodChannel.Result resultForDisConnect;
    MethodChannel.Result resultForBLEDisConnect;
    MethodCall call;

    MethodCall getAlarmCall;
    MethodChannel.Result getAlarmCallResult;

    MethodCall addAlarmCall;
    MethodChannel.Result addAlarmCallResult;

    MethodCall startModeCall;
    MethodChannel.Result startModeResult;

    MethodCall stopModeCall;
    MethodChannel.Result stopModeResult;

    MethodCall collectHeartRate;
    MethodChannel.Result collectHeartRateResult;

    MethodCall collectECG;
    MethodChannel.Result collectECGResult;


    private Connections connections;
    ArrayList<DeviceModel> deviceModelArrayList = new ArrayList<>();

    private List<BLEDeviceModel> devices = new ArrayList<>();

    long startECGMeasurementTime;
    long startPPGMeasurementTime;

    long endECGMeasurementTime;
    long endPPGMeasurementTime;

    //this is read count of ecg data reading process
    int readCount = 0;


    private MethodChannel.Result resultForReconnect;
    public MethodChannel.Result startMeasurementResult;
    public MethodChannel.Result stopMeasurementResult;

    //region google fit
    private FitnessOptions fitnessOptions;
    private GoogleSignInAccount account;
    private MethodChannel.Result resultForRequestAuth;


    //endregion

    GoogleFitData googleFitData;

    private ConnectorListener mConnectorListener = new ConnectorListener() {

        @Override
        public void onConnect() {

            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (call != null && call.method != null && call.method.equals("connectToDevice")) {
                            if (resultForConnect != null) {
                                resultForConnect.success(true);
                                resultForConnect = null;
                            }
                        }
                    }
                });

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (channel != null) {
                            if (deviceModel != null) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        if (channel != null) {
                                            channel.invokeMethod("onConnectIosDevice", deviceModel.toMap());
                                        }
                                    }
                                });
                            }
                        }
                    }
                });


            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        @Override
        public void onDisconnect() {

            try {
                runOnUiThread(() -> {
                    if (call != null && call.method != null && call.method.equals("disConnectToDevice")) {
                        if (resultForDisConnect != null) {
                            resultForDisConnect.success(false);
                            resultForDisConnect = null;
                        }
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        @Override
        public void onConnectFailed() {
        }
    };

    private final ScanCallback scanCallback = new ScanCallback() {
        @Override
        public void onScanResult(final int callbackType, @NonNull final ScanResult result) {
            // empty
        }

        @Override
        public void onBatchScanResults(final List<ScanResult> results) {
            final int size = devices.size();
            for (final ScanResult result : results) {
                final BluetoothDevice device = result.getDevice();
//                if (!devices.contains(device))
//                    devices.add(device);
            }
//            if (size != devices.size()) {
//                notifyItemRangeInserted(size, devices.size() - size);
//                if (size == 0)
//                    listView.scrollToPosition(0);
//            }
        }

        @Override
        public void onScanFailed(final int errorCode) {
            // empty
        }
    };
    private final Handler handler = new Handler();
    private boolean scanning;

    DeviceModel deviceModel;
    BLEDeviceModel BLEdeviceModel;

    public static final String[] BLUETOOTH_PERMISSIONS_S = {ACCESS_FINE_LOCATION, Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT};
    private static final int REQUEST_CODE_IS_BT_DEVICE_CONNECTED = 1995;
    private static final int REQUEST_CODE_GET_BT_DEVICE_LIST = 1996;
    private static final int REQUEST_CODE_GET_BLE_DEVICE_LIST = 1997;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handleIntent();
    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        if (onConfigureWeightScale != null) {
            onConfigureWeightScale.initialiseChannel(channel);
        }
        handleIntent();
        googleFitData = new GoogleFitData(context, account);

        try {
            startService(new Intent(this, NotificationService.class));
        } catch (Exception e) {
            e.printStackTrace();
        }

        //region notification reading for e66
        LocalBroadcastManager.getInstance(this).registerReceiver(new BroadcastReceiver() {

            @Override
            public void onReceive(Context context, Intent intent) {
                String pack = intent.getStringExtra("package");
                String title = intent.getStringExtra("title");
                String text = intent.getStringExtra("text");
                Log.i(TAG, "onReceive: pack " + pack + " title " + title + " text " + text + "");
                if (channel != null) {
                    HashMap map = new HashMap();
                    map.put("packageName", pack);
                    map.put("title", title);
                    map.put("content", text);

                    try {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                channel.invokeMethod("onReceiveMessage", map);
                            }
                        });
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }, new IntentFilter("Msg"));
        //endregion

        Intent intent = new Intent(MainActivity.this, ZhBraceletService.class);

        try {
            EventBus.getDefault().register(this);
//            startService(new Intent(this, MyBleService.class));
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            //connection class used to do connection utilities
//            connections = new Connections(this, mConnectorListener, mPerformerListener, this, MainActivity.this, this);
            connections = ConnectionSingleton.getInstance(this, this, mConnectorListener, mPerformerListener, this, MainActivity.this, this, intent, mServiceConnection).getConnections();
            //this method start the background services of sdk
            initData(intent);

        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            CallStateListener callStateListener = new CallStateListener();
            tm.listen(callStateListener, PhoneStateListener.LISTEN_CALL_STATE);
        } catch (Exception e) {
            e.printStackTrace();
        }

        /*try {
            Intent alarm = new Intent(context, CheckAndReconnectService.class);
            boolean alarmRunning = (PendingIntent.getBroadcast(context, 0, alarm, PendingIntent.FLAG_NO_CREATE) != null);
            if (!alarmRunning) {
                PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, alarm, 0);
                AlarmManager alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
                alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(), 1000, pendingIntent);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }*/

        //this method handles the method and data which are passed from flutter

        /// Added by: Chaitanya
        /// Added on: Oct/8/2021
        /// formate change for Start date and date because google fit need some specific data format.
        channel.setMethodCallHandler((call, result) -> {
            this.call = call;

            int sdkType = Constants.e66;

            long startDate = 0;
            long endDate = 0;

            try {
                if (call.arguments != null && call.arguments instanceof HashMap) {
                    HashMap map = (HashMap) call.arguments;

                    try {
                        if (map.containsKey("sdkType") && map.get("sdkType") != null) {
                            sdkType = (int) map.get("sdkType");
                            if (connections != null) {
                                connections.setSdkType(sdkType);
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                    if (call.method.equals("writeStepsData")) {
                        formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    }
                    if (map.containsKey("startDate")) {
                        String strStart = String.valueOf(map.get("startDate"));
                        startDate = Timestamp.valueOf(strStart).getTime();
//                        startDate = formatter.parse(strStart).getTime();
                    }
                    if (map.containsKey("endDate")) {
                        String strEnd = String.valueOf(map.get("endDate"));
                        endDate = Timestamp.valueOf(strEnd).getTime();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                switch (call.method) {

                    case "checkConnectionStatus":
                        boolean isCameFromMeasurement = false;
                        try {
                            HashMap map = (HashMap) call.arguments;
                            if (map != null) {
                                if (map.containsKey("type")) {
                                    sdkType = (int) map.get("type");
                                }
                                if (map.containsKey("isCameFromMeasurement") && map.get("isCameFromMeasurement") != null) {
                                    isCameFromMeasurement = (boolean) map.get("isCameFromMeasurement");
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            if (Utils.hasPermissions(MainActivity.this, BLUETOOTH_PERMISSIONS_S)) {
                                boolean isConnected = connections.isConnected(MainActivity.this, isCameFromMeasurement, sdkType);
                                result.success(isConnected);
                            } else {
                                ActivityCompat.requestPermissions(MainActivity.this, BLUETOOTH_PERMISSIONS_S, REQUEST_CODE_IS_BT_DEVICE_CONNECTED);
                            }
                        } else {
                            boolean isConnected = connections.isConnected(MainActivity.this, isCameFromMeasurement, sdkType);
                            result.success(isConnected);
                        }
                        break;
                    case "getDeviceList":

                        if (call.arguments != null) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                                if (Utils.hasPermissions(MainActivity.this, BLUETOOTH_PERMISSIONS_S)) {
                                    getDeviceList();
                                } else {
                                    ActivityCompat.requestPermissions(MainActivity.this, BLUETOOTH_PERMISSIONS_S, REQUEST_CODE_GET_BT_DEVICE_LIST);
                                }
                            } else {
                                getDeviceList();
                            }
                        }
                        break;
                    case "stopScan":
                        connections.stopScanning();
                        onConfigureWeightScale.onStopScanning();
                        break;
                    case "getDataForE66":
                        connections.getDataForE66();
                        result.success(true);
                        break;
                    case "connectToDevice":
                        resultForConnect = result;
                        HashMap map = (HashMap) call.arguments;
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            if (Utils.hasPermissions(MainActivity.this, BLUETOOTH_PERMISSIONS_S)) {
                                connectToDevice(map);
                            } else {
                                ActivityCompat.requestPermissions(MainActivity.this, BLUETOOTH_PERMISSIONS_S, 1597);
                            }
                        } else {
                            connectToDevice(map);
                        }
                        break;

                    case "tryToReconnect":
                        resultForReconnect = result;
                        connections.tryToReconnect();
                        break;
                    case "disConnectToDevice":
                        resultForDisConnect = result;
                        connections.disConnectDevice();
                        break;
                    case "startMeasurement":
                        startECGMeasurementTime = 0;
                        startPPGMeasurementTime = 0;
                        startMeasurementResult = result;
                        connections.startMeasurement();
                        break;
                    case "stopMeasurement":
                        stopMeasurementResult = result;
                        connections.stopMeasurement();
                        break;
                    case "vibrate":
                        connections.findDevice();
                        result.success(true);
                        break;
                    case "Calibration":
                        HashMap data = (HashMap) call.arguments;
                        int hr = (int) data.get("hr");
                        int sbp = (int) data.get("sbp");
                        int dbp = (int) data.get("dbp");
                        connections.setCalibration(hr, sbp, dbp);
                        result.success(true);
                        break;
                    case "setCelebrationInE66":
                        int calibrationType = (int) call.arguments;
                        connections.setCelebrationInE66(calibrationType);
                        result.success(true);
                        break;
                    case "setLiftBrighten":
//                        boolean isON = (Boolean) call.arguments;
                        map = (HashMap) call.arguments;
                        boolean isON = (boolean) map.get("isLiftTheWristBrightnessOn");
                        connections.setLiftBrighten(isON);
                        result.success(true);
                        break;
                    case "setDoNotDisturb":
//                        boolean isEnable = (Boolean) call.arguments;
                        map = (HashMap) call.arguments;
                        boolean isEnable = (boolean) map.get("enable");
                        connections.setDoNotDisturb(isEnable);
                        result.success(true);
                        break;
                    case "setTimeFormat":
                        map = (HashMap) call.arguments;
                        boolean timeFormat = (boolean) map.get("enable");
//                        boolean timeFormat = (Boolean) call.arguments;
                        connections.setTimeFormat(timeFormat);
                        result.success(true);
                        break;
                    case "setHourlyHrMonitorOn":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
                        int interval = (int) map.get("timeInterval");
//                        boolean enable = (Boolean) call.arguments;
                        connections.setHourlyHrMonitorOn(isEnable, interval);
                        result.success(true);
                        break;
                    case "setWearType":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        boolean isWearOnLeft = (Boolean) call.arguments;
                        connections.setWearType(isEnable);
                        result.success(true);
                        break;
                    case "setUserData":
                        HashMap userData = (HashMap) call.arguments;
                        connections.setUserInformation(userData);
                        result.success(true);
                        break;
                    case "setSkinType":
                        map = (HashMap) call.arguments;
                        int skinType = (int) map.get("skinType");
                        connections.setSkinType(skinType);
                        result.success(true);
                        break;
                    case "openNotificationScreen":
                        connections.openNotificationScreen(MainActivity.this);
                        result.success(true);
                        break;

                    //region set app reminder
                    case "setCallEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setCallEnable((Boolean) call.arguments);
                        connections.setCallEnable(isEnable);


                        break;
                    case "setMessageEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setMessageEnable((Boolean) call.arguments);
                        connections.setMessageEnable(isEnable);
                        break;
                    case "setQqEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setQqEnable((Boolean) call.arguments);
                        connections.setQqEnable(isEnable);
                        break;
                    case "setWeChatEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setWeChatEnable((Boolean) call.arguments);
                        connections.setWeChatEnable(isEnable);
                        break;
                    case "setLinkedInEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setLinkedInEnable((Boolean) call.arguments);
                        connections.setLinkedInEnable(isEnable);
                        break;
                    case "setSkypeEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setSkypeEnable((Boolean) call.arguments);
                        connections.setSkypeEnable(isEnable);
                        break;
                    case "setFacebookMessengerEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setFacebookMessengerEnable((Boolean) call.arguments);
                        connections.setFacebookMessengerEnable(isEnable);
                        break;
                    case "setTwitterEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setTwitterEnable((Boolean) call.arguments);
                        connections.setTwitterEnable(isEnable);
                        break;
                    case "setWhatsAppEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setWhatsAppEnable((Boolean) call.arguments);
                        connections.setWhatsAppEnable(isEnable);
                        break;
                    case "setViberEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setViberEnable((Boolean) call.arguments);
                        connections.setViberEnable(isEnable);
                        break;
                    case "setLineEnable":
                        map = (HashMap) call.arguments;
                        isEnable = (boolean) map.get("enable");
//                        connections.setLineEnable((Boolean) call.arguments);
                        connections.setLineEnable(isEnable);
                        break;
                    //endregion
                    //region get app reminder

                    case "getCallEnable":
                        result.success(connections.getCallEnable());
                        break;
                    case "getMessageEnable":
                        result.success(connections.getMessageEnable());
                        break;
                    case "getQqEnable":
                        result.success(connections.getQqEnable());
                        break;
                    case "getWeChatEnable":
                        result.success(connections.getWeChatEnable());
                        break;
                    case "getLinkedInEnable":
                        result.success(connections.getLinkedInEnable());
                        break;
                    case "getSkypeEnable":
                        result.success(connections.getSkypeEnable());
                        break;
                    case "getFacebookMessengerEnable":
                        result.success(connections.getFacebookMessengerEnable());
                        break;
                    case "getTwitterEnable":
                        result.success(connections.getTwitterEnable());
                        break;
                    case "getWhatsAppEnable":
                        result.success(connections.getWhatsAppEnable());
                        break;
                    case "getViberEnable":
                        result.success(connections.getViberEnable());
                        break;
                    case "getLineEnable":
                        result.success(connections.getLineEnable());
                        break;
                    case "setWaterReminder":
                        HashMap waterInfo = (HashMap) call.arguments;
                        int startH = (int) waterInfo.get("startHour");
                        int startM = (int) waterInfo.get("startMinute");
                        int endH = (int) waterInfo.get("endHour");
                        int endM = (int) waterInfo.get("endMinute");
                        interval = (int) waterInfo.get("interval");
                        boolean isOn = (boolean) waterInfo.get("isEnable");
                        connections.setWaterReminder(startH, startM, endH, endM, interval, isOn);
                        result.success(waterInfo);
                        break;
                    case "getWaterReminder":
                        if (connections.getWaterReminder() != null) {
                            result.success(connections.getWaterReminder());
                        }
                        result.success(null);
                        break;
                    case "setMedicalReminder":
                        HashMap medicalInfo = (HashMap) call.arguments;
                        startH = (int) medicalInfo.get("startHour");
                        startM = (int) medicalInfo.get("startMinute");
                        endH = (int) medicalInfo.get("endHour");
                        endM = (int) medicalInfo.get("endMinute");
                        interval = (int) medicalInfo.get("interval");
                        isOn = (boolean) medicalInfo.get("isEnable");
                        connections.setMedicalReminder(startH, startM, endH, endM, interval, isOn);
                        result.success(medicalInfo);
                        break;
                    case "getMedicalReminder":
                        if (connections.getMedicalReminder() != null) {
                            result.success(connections.getMedicalReminder());
                        }
                        result.success(null);
                        break;
                    case "setSitReminder":
                        HashMap sitInfo = (HashMap) call.arguments;
                        startH = (int) sitInfo.get("startHour");
                        startM = (int) sitInfo.get("startMinute");
                        endH = (int) sitInfo.get("endHour");
                        endM = (int) sitInfo.get("endMinute");
                        interval = (int) sitInfo.get("interval");
                        isOn = (boolean) sitInfo.get("isEnable");

                        int secondStartHour = 0;
                        int secondStartMinute = 0;
                        int secondEndHour = 0;
                        int secondEndMinute = 0;
                        if (sitInfo.containsKey("secondStartHour") && sitInfo.get("secondStartHour") != null) {
                            secondStartHour = (int) sitInfo.get("secondStartHour");
                        }
                        if (sitInfo.containsKey("secondStartMinute") && sitInfo.get("secondStartMinute") != null) {
                            secondStartMinute = (int) sitInfo.get("secondStartMinute");
                        }

                        if (sitInfo.containsKey("secondEndHour") && sitInfo.get("secondEndHour") != null) {
                            secondEndHour = (int) sitInfo.get("secondEndHour");
                        }
                        if (sitInfo.containsKey("secondEndMinute") && sitInfo.get("secondEndMinute") != null) {
                            secondEndMinute = (int) sitInfo.get("secondEndMinute");
                        }

                        connections.setSitReminder(startH, startM, endH, endM, interval, isOn, secondStartHour, secondStartMinute, secondEndHour, secondEndMinute);
                        result.success(sitInfo);
                        break;
                    case "getSitReminder":
                        if (connections.getSitReminder() != null) {
                            result.success(connections.getSitReminder());
                        }
                        result.success(null);
                        break;
                    case "addAlarm":
                        HashMap hashMap = (HashMap) call.arguments;
                        AlarmModel alarmModel = new AlarmModel();
                        alarmModel = alarmModel.fromMap(hashMap);
                        if (sdkType == Constants.e66) {
                            connections.addSdkAlarm(alarmModel);
                            result.success(null);
                        } else {
                            connections.addAlarm(alarmModel);

                            result.success(null);
                        }
                        break;
                    case "addSDKAlarm":
                        hashMap = (HashMap) call.arguments;
                        alarmModel = new AlarmModel();
                        alarmModel = alarmModel.fromMap(hashMap);
                        connections.addSdkAlarm(alarmModel);
                        result.success(null);
                        break;
                    case "updateSdkAlarm":
                        hashMap = (HashMap) call.arguments;
                        alarmModel = new AlarmModel();
                        alarmModel = alarmModel.fromMap(hashMap);
                        connections.updateSdkAlarm(alarmModel);
                        result.success(null);
                        break;
                    case "setStepTarget":
                        map = (HashMap) call.arguments;
                        int target = (int) map.get("target");
//                        int steps = (int) call.arguments;
                        connections.setStepTarget(target);
                        result.success(null);
                        break;
                    case "setCaloriesTarget":
                        map = (HashMap) call.arguments;
                        target = (int) map.get("caloriesValue");
//                        int calories = (int) call.arguments;
                        connections.setCaloriesTarget(target);
                        result.success(null);
                        break;
                    case "setDistanceTarget":
                        int distance = (int) call.arguments;
                        connections.setDistanceTarget(distance);
                        result.success(null);
                        break;
                    case "setSleepTarget":
                        map = (HashMap) call.arguments;
                        int hour = (int) map.get("hour");
                        int minute = (int) map.get("minute");
                        connections.setSleepTarget(hour, minute);
                        result.success(null);
                        break;
                    case "getStepTarget":
                        int step = connections.getStepTarget();
                        result.success(step);
                        break;
                    //endregion
                    case "setWeightScaleUser":
                        try {
                            HashMap userDataValueMap = (HashMap) call.arguments;
//                            int userId = (int) userDataValueMap.get("id");
                            int sex = (int) userDataValueMap.get("sex");
                            int age = (int) userDataValueMap.get("age");
                            int height = (int) userDataValueMap.get("height");
                            int weight = (int) userDataValueMap.get("weight");
                            User user = new User();
                            user.setId(1);
                            user.setSex(sex);
                            user.setAge(age);
                            user.setHeight(height);
                            user.setWeight(weight);
                            onConfigureWeightScale.onGetUserInformation(user);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        result.success(true);
                        break;
                    case "disconnectWeightScaleDevice":
                        try {
                            onConfigureWeightScale.onDisconnect();
                        } catch (Exception e) {
                            e.printStackTrace();
                            result.success(null);
                        }
                        break;
                    case "setBrightness":
                        try {
                            map = (HashMap) call.arguments;
                            int brightness = (int) map.get("brightness");
//                            int brightness = (int) call.arguments;
                            connections.setBrightness(brightness);
                        } catch (Exception e) {
                            e.printStackTrace();
                            result.success(null);
                        }
                        break;
                    case "getTempData":
                        try {
                            connections.getRealTemp();
//                            connections.getAllDataFromE66();
                            result.success(true);
                        } catch (Exception e) {
                            e.printStackTrace();
                            result.success(false);
                        }
                        break;
                    case "collectMemory":
                        String memoryInfoData = getMemoryInfo();
                        result.success(memoryInfoData);
                        break;
                    case "invokeGc":
                        callGc();
                        result.success(true);
                        break;
                    case "sendMessage":
                        try {
                            map = (HashMap) call.arguments;
                            connections.sendMessage(map);
                        } catch (Exception e) {
                            e.printStackTrace();
                            result.success(null);
                        }
                        break;
                    case "requestAccess":
                        resultForRequestAuth = result;
                        checkAndRequestAccess();
                        break;
                    case "readStepsData":
                        googleFitData.readSteps(startDate, endDate, result);
                        break;
                    case "readSleepData":
                        googleFitData.readSleep(startDate, endDate, result);
                        break;
                    case "readDistanceData":
                        googleFitData.readDistance(startDate, endDate, result);
                        break;
                    case "readHeightData":
                        googleFitData.readHeight(startDate, endDate, result);
                        break;
                    case "readBodyMassData":
                        googleFitData.readWeight(startDate, endDate, result);
                        break;
                    case "readHeartRateData":
                        googleFitData.readHR(startDate, endDate, result);
                        break;
                    case "readSystolicBloodPressureData":
                        googleFitData.readBloodPressure(startDate, endDate, true, result);
                        break;
                    case "readDiastolicBloodPressureData":
                        googleFitData.readBloodPressure(startDate, endDate, false, result);
                        break;
                    case "readBloodGlucoseData":
                        googleFitData.readBloodGlucose(startDate, endDate, result);
                        break;
                    /// Added by: Chaitanya
                    /// Added on: Oct/8/2021
                    /// cases add for body temperature, Respirator rate and oxygen data
//                    case "readRespiratoryRate":
//                        googleFitData.readRespiratoryRate(startDate, endDate,result);
//                        break;
                    case "readBodyTemperatureData":
                        googleFitData.readBodyTemperature(startDate, endDate, result);
                        break;
                    case "readOxygenData":
                        googleFitData.readOxygen(startDate, endDate, result);
                        break;
                    case "readActiveCaloriesData":
                        googleFitData.readActiveCalories(startDate, endDate, result);
                        break;
                    case "readRestingCaloriesData":
                        googleFitData.readRestingCalories(startDate, endDate, result);
                        break;
                    case "writeStepsData":
                        if (call.arguments instanceof HashMap) {
                            map = (HashMap) call.arguments;
                            int steps = (int) map.get("steps");
                            googleFitData.writeStepData(startDate, endDate, steps, result);
                        }
                        break;
                    case "writeSleepData":
                        if (call.arguments instanceof ArrayList) {
                            ArrayList listOfSleepData = (ArrayList) call.arguments;
                            googleFitData.writeSleepDataInBunch(listOfSleepData, result);
                        }
                        break;
                    case "writeWeightData":
                        if (call.arguments instanceof HashMap) {
                            map = (HashMap) call.arguments;
                            float weight = Float.parseFloat(map.get("weight").toString());
                            googleFitData.writeWeightData(startDate, startDate, weight, result);
                        }
                        break;
                    case "writeBloodPressureData":
                        if (call.arguments instanceof HashMap) {
                            map = (HashMap) call.arguments;
                            float sbp1 = Float.parseFloat(map.get("sbp").toString());
                            float dbp1 = Float.parseFloat(map.get("dbp").toString());
                            googleFitData.writeBloodPressureData(startDate, sbp1, dbp1, result);
                        }
                        break;
                    case "setTemperatureMonitorOn":
                        if (call.arguments instanceof HashMap) {
                            map = (HashMap) call.arguments;
                            sdkType = (int) map.get("sdkType");
                            isEnable = (boolean) map.get("enable");
                            interval = (int) map.get("timeInterval");
                            connections.setTemperatureMonitorOn(isEnable, interval);
                        }
                        break;
                    case "setOxygenMonitorOn":
                        if (call.arguments instanceof HashMap) {
                            map = (HashMap) call.arguments;
                            sdkType = (int) map.get("sdkType");
                            isEnable = (boolean) map.get("enable");
                            interval = (int) map.get("timeInterval");
                            connections.setOxygenMonitorOn(isEnable, interval);
                        }
                        break;

                    case "changeWeightScaleUnit":
                        if (call.arguments instanceof HashMap) {
                            hashMap = (HashMap) call.arguments;
                            int type = (int) hashMap.get("type");
                            onConfigureWeightScale.onSetUnit(type);
                        }
                        break;
                    case "setUnits":
                        if (call.arguments instanceof HashMap) {
                            connections.setUnits((HashMap) call.arguments);
                        }
                        break;
                    case "addE80SDKAlarm":
                    case "modifyE80SDKAlarm":
                        addAlarmCall = call;
                        addAlarmCallResult = result;
                        if (call.arguments instanceof HashMap) {
                            hashMap = (HashMap) call.arguments;
                            E80AlarmModel e80AlarmModel = new E80AlarmModel().fromMap(hashMap);
                            if (connections != null) {
                                connections.addAlarmForE66(e80AlarmModel);
                            }
                        }
                        break;
                    case "deleteE80SDKAlarm":
                        addAlarmCall = call;
                        addAlarmCallResult = result;
                        if (call.arguments instanceof HashMap) {
                            hashMap = (HashMap) call.arguments;
                            int startHour = (int) hashMap.get("startHour");
                            int startMinute = (int) hashMap.get("startMinute");
                            if (connections != null) {
                                connections.deleteSDKAlarm(startHour, startMinute);
                            }
                        }
                        break;

                    case "getAlarmListOfE80":
                        getAlarmCall = call;
                        getAlarmCallResult = result;
                        connections.getSDKAlarm();
                        break;
                    case "startMode":
                        this.startModeResult = result;
                        this.startModeCall = call;
                        if (call.arguments instanceof Integer) {
                            connections.startMode((Integer) call.arguments);
                        }
                        break;
                    case "endMode":
                        this.stopModeResult = result;
                        this.stopModeCall = call;
                        if (call.arguments instanceof Integer) {
                            connections.stopMode((Integer) call.arguments);
                        }
                        break;
                    case "reset":
                        connections.reset();
                        break;
                    case "shutdown":
                        connections.shutdown();
                        break;
                    case "deleteSport":
                        connections.deleteSport();
                        break;
                    case "deleteSleep":
                        connections.deleteSleep();
                        break;
                    case "deleteHeartRate":
                        connections.deleteHeartRate();
                        break;
                    case "deleteBloodPressure":
                        connections.deleteBloodPressure();
                        break;
                    case "deleteTempAndOxygen":
                        connections.deleteTempAndOxygen();
                        break;
                    case "collectHeartRateHistory":
                        collectHeartRate = call;
                        collectHeartRateResult = result;
                        connections.getHeartRateHistory();
                        break;
                    case "collectECG":
                        collectECG = call;
                        collectECGResult = result;
                        connections.getEcgData();
                        break;
                    case "collectBP":
                        connections.getBloodPressureData();
                        break;
                    case "isBluetoothEnable":
                        bluetoothCheck(result);
                        break;
                    case "onGetHRData":
                        connections.getHeartRateHistory();
                        result.success(true);
                        break;
                    case "getAllWatchdata":
                        connections.getAllDataFromE66();
                        connections.getSleepDataFromE66();
                        connections.getBloodPressureData();
                        connections.getHeartRateHistory();
                        result.success(true);
                        break;
                    case "goToBle":
                        goToBle();
                        result.success(true);
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }


    private void getDeviceList() {
        HashMap map = (HashMap) call.arguments;
        if (map != null) {
            if (map.containsKey("isForWeightScale") && map.get("isForWeightScale") != null) {
                if ((boolean) map.get("isForWeightScale")) {
                    onConfigureWeightScale.onStartScanning();
                }
            } else if (map.containsKey("sdkType") && map.get("sdkType") != null) {
                int sdkTypeFroScan = (int) map.get("sdkType");
                connections.startScanning(sdkTypeFroScan);
            }
        }
    }

    void goToBle() {
        Intent settings_intent = new Intent(android.provider.Settings.ACTION_BLUETOOTH_SETTINGS);
        startActivity(settings_intent);
    }

    private void bluetoothCheck(MethodChannel.Result result) {
        try {
            BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            boolean isEnabledBle = mBluetoothAdapter != null && mBluetoothAdapter.isEnabled();
            if (call != null && call.method != null && call.method.equals("isBluetoothEnable") && result != null) {
                result.success(isEnabledBle);
                result = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (result != null) {
                result.success(false);
                result = null;
            }
        }
    }

    private void connectToDevice(HashMap map) {
        DeviceModel model = new DeviceModel();
        model.fromMap(map);
        deviceModel = model;
        connections.connectToDevice(model);
    }

    private void connectToBLEDevice(HashMap map) {
        BLEDeviceModel model = new BLEDeviceModel();
        model.fromMap(map);
        BLEdeviceModel = model;
        connections.connectToBLEDevice(model);
    }


    void initData(Intent intent) {
        try {
            openBleService(intent);
            if (connections == null) {
                connections = ConnectionSingleton.getInstance(this, this, mConnectorListener, mPerformerListener, this, MainActivity.this, this, intent, mServiceConnection).getConnections();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void openBleService(Intent intent) {
        bindService(intent, mServiceConnection, Context.BIND_AUTO_CREATE);
    }

    public ServiceConnection mServiceConnection = new ServiceConnection() {

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.i(TAG, "onService - Disconnected: " + name);
            ZhbraceletApplication.setZhBraceletService(null);
        }

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Log.i(TAG, "onService - Connected: " + name);
            ZhbraceletApplication.setZhBraceletService(((ZhBraceletService.LocalBinder) service).getService());
            try {
                ((ZhBraceletService.LocalBinder) service).getService().UnBindDevice();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };

    @Override
    public void onResponseStart(boolean isStarted) {
        try {
            if (startMeasurementResult != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        startMeasurementResult.success(isStarted);
                        startMeasurementResult = null;
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onResponseEnd(boolean isStopped) {
        try {
            if (stopMeasurementResult != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        stopMeasurementResult.success(isStopped);
                        stopMeasurementResult = null;
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onResponseCollectECG(CollectECGModel collectECGModel) {
        try {
            if (collectECGResult != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        collectECGResult.success(collectECGModel.toMap());
                        collectECGResult = null;
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onResponseCollectBP(ArrayList<HashMap> hashMaps) {
        try {
            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onResponseCollectBP", hashMaps);
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private final SimplePerformerListener mPerformerListener = new SimplePerformerListener() {

        @Override
        public void onResponseDeviceInfo(DeviceInfo mDeviceInfo) {

            DeviceInfoModel deviceInfoModel = new DeviceInfoModel();
            deviceInfoModel.setPower(mDeviceInfo.getDeviceBattery());
            deviceInfoModel.setType(mDeviceInfo.getDeviceType());
            deviceInfoModel.setDevice_number(mDeviceInfo.getDeviceVersionName());
            deviceInfoModel.setDevice_name(mDeviceInfo.getDeviceVersionName());
//            Log.i(TAG, "onResponseDeviceInfo: " + deviceInfoModel.toString());

            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onResponseDeviceInfo", deviceInfoModel.toMap());
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onResponseMotionInfo(MotionInfo mMotionInfo) {
//            Log.i(TAG, "onResponseMotionInfo: a");
            MotionInfoModel motionInfoModel = new MotionInfoModel();
            motionInfoModel.setDate(mMotionInfo.getMotionDate());
            motionInfoModel.setCalories(mMotionInfo.getMotionCalorie());
            motionInfoModel.setDistance(mMotionInfo.getMotionDistance());
            motionInfoModel.setStep(mMotionInfo.getMotionStep());
            motionInfoModel.setData(mMotionInfo.getMotionData());
//            Log.i(TAG, "onResponseMotionInfo: " + motionInfoModel.toString());
            try {
                runOnUiThread(() -> channel.invokeMethod("onResponseMotionInfo", motionInfoModel.toMap()));
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        @Override
        public void onResponseSleepInfo(SleepInfo mSleepInfo) {
            SleepInfoModel sleepInfoModel = new SleepInfoModel();
            sleepInfoModel.setDate(mSleepInfo.getSleepDate());
            sleepInfoModel.setSleepAllTime(mSleepInfo.getSleepTotalTime());
            sleepInfoModel.setDeepTime(mSleepInfo.getSleepDeepTime());
            sleepInfoModel.setLightTime(mSleepInfo.getSleepLightTime());
            sleepInfoModel.setStayUpTime(mSleepInfo.getSleepStayupTime());
            sleepInfoModel.setWakInCount(mSleepInfo.getSleepWakingNumber());
            ArrayList<SleepDataInfo> arrayList = new ArrayList<>();
            for (int i = 0; i < mSleepInfo.getSleepData().size(); i++) {
                SleepData data = mSleepInfo.getSleepData().get(i);
                SleepDataInfo model = new SleepDataInfo();
                model.setType(data.getSleep_type());
                model.setTime(data.getStartTime());
                arrayList.add(model);
            }
            sleepInfoModel.setData(arrayList);
//            Log.i(TAG, "onResponseSleepInfo: " + sleepInfoModel.toString());
            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onResponseSleepInfo", sleepInfoModel.toMap());

                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onResponsePoHeartInfo(PoHeartInfo mPoHeartInfo) {
//            Log.e(TAG, "onResponsePoHeartInfo: " + mPoHeartInfo.toString());
            HeartInfoModel model = new HeartInfoModel();
            model.setDate(mPoHeartInfo.getPoHeartDate());
            model.setSleepMaxHeart(mPoHeartInfo.getPoHeartSleepMax());
            model.setSleepMinHeart(mPoHeartInfo.getPoHeartSleepMin());
            model.setSleepAvgHeart(mPoHeartInfo.getPoHeartSleepAvg());
            model.setAllMaxHeart(mPoHeartInfo.getPoHeartDayMax());
            model.setAllMinHeart(mPoHeartInfo.getPoHeartDayMin());
            model.setAllAvgHeart(mPoHeartInfo.getPoHeartDayAvg());
            model.setNewHeart(mPoHeartInfo.getPoHeartRecent());
            model.setData(mPoHeartInfo.getPoHeartData());
//            Log.i(TAG, "onResponsePoHeartInfo: " + model.toString());
            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onResponsePoHeartInfo", model.toMap());
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }


        }

        @Override
        public void onResponseWoHeartInfo(WoHeartInfo mWoHeartInfo) {
            Log.e(TAG, "onResponseWoHeartInfo: " + mWoHeartInfo.toString());
            WoHeartInfoModel model = new WoHeartInfoModel();
            model.setDate(mWoHeartInfo.getWoHeartDate());
            model.setSleepMaxHeart(mWoHeartInfo.getWoHeartSleepMax());
            model.setSleepMinHeart(mWoHeartInfo.getWoHeartSleepMin());
            model.setSleepAvgHeart(mWoHeartInfo.getWoHeartSleepAvg());
            model.setAllMaxHeart(mWoHeartInfo.getWoHeartDayMax());
            model.setAllMinHeart(mWoHeartInfo.getWoHeartDayMin());
            model.setAllAvgHeart(mWoHeartInfo.getWoHeartDayAvg());
            model.setNewHeart(mWoHeartInfo.getWoHeartRecent());
            model.setData(mWoHeartInfo.getWoHeartData());
//            Log.i(TAG, "onResponseWoHeartInfo: " + model.toString());
            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onResponseWoHeartInfo", model.toMap());
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onResponseComplete() {
//            Utils.MyLog(TAG, "onResponseComplete");
        }

        @Override
        public void onResponsePhoto() {
//            Utils.MyLog(TAG, "onResponsePhoto");
        }


        @Override
        public void onResponseFindPhone() {
//            Utils.MyLog(TAG, "onResponseFindPhone");
        }

        @Override
        public void onResponseOffLineStart() {
//            Utils.MyLog(TAG, "onResponseOffLineStart");
        }

        @Override
        public void onResponseOffLineInfo(OffLineEcgInfo mOffLineEcgInfo) {
            OfflineEcgInfoModel model = new OfflineEcgInfoModel();
            model.setEcgDate(mOffLineEcgInfo.getOffLineEcgDate());
            model.setEcgHR(mOffLineEcgInfo.getOffLineEcgHR());
            model.setEcgSBP(mOffLineEcgInfo.getOffLineEcgSBP());
            model.setEcgDBP(mOffLineEcgInfo.getOffLineEcgDBP());
            model.setHealthHrvIndex(mOffLineEcgInfo.getOffLineHealthHrvIndex());
            model.setHealthFatigueIndex(mOffLineEcgInfo.getOffLineHealthFatigueIndex());
            model.setHealthLoadIndex(mOffLineEcgInfo.getOffLineHealthLoadIndex());
            model.setHealthBodyIndex(mOffLineEcgInfo.getOffLineHealthBodyIndex());
            model.setHealtHeartIndex(mOffLineEcgInfo.getOffLineHealtHeartIndex());
            model.setEcgData(mOffLineEcgInfo.getOffLineEcgData());
//            Log.i(TAG, "onResponseOffLineInfo: " + model.toString());
            try {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onResponseOffLineInfo", model.toMap());
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onResponseOffLineEnd() {
//            Utils.MyLog(TAG, "onResponseOffLineStart");
        }

        @Override
        public void onResponseEcgInfo(EcgInfo ecgInfo) {
            super.onResponseEcgInfo(ecgInfo);
            ArrayList ecgDataList = (ArrayList) ecgInfo.getEcgData();
            for (int i = 0; i < ecgDataList.size(); i++) {

                if (startECGMeasurementTime == 0) {
                    startECGMeasurementTime = System.currentTimeMillis();
                }
                endECGMeasurementTime = System.currentTimeMillis();

                double ecgPoint = (double) ecgDataList.get(i);

//                Log.i(TAG, "point: " + ecgPoint);

                EcgInfoModel mEcgBean = new EcgInfoModel();
                mEcgBean.setApproxHr(ecgInfo.getEcgHR());
                mEcgBean.setApproxSBP(ecgInfo.getEcgSBP());
                mEcgBean.setApproxDBP(ecgInfo.getEcgDBP());
                mEcgBean.setHrv(ecgInfo.getHealthHrvIndex());
                mEcgBean.setEcgPointY(ecgPoint);
                mEcgBean.setStartTime(startECGMeasurementTime);
                mEcgBean.setEndTime(endECGMeasurementTime);
                mEcgBean.setLeadOff(ecgInfo.getGuideOff());
                mEcgBean.setPoorConductivity(ecgInfo.getEcgFallOff());

                if (readCount >= 0) {
                    try {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
//                                channel.invokeMethod("onGetLeadOff", mEcgBean.isLeadOff());
//                                channel.invokeMethod("onGetPoorConductivity", mEcgBean.isPoorConductivity());
                                channel.invokeMethod("onResponseEcgInfo", mEcgBean.toMap());
                            }
                        });
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }


        @Override
        public void onResponsePpgInfo(PpgInfo ppgInfo) {
            super.onResponsePpgInfo(ppgInfo);
            Log.i(TAG, "onResponsePpgInfo: " + ppgInfo.toString());
            ArrayList ppgDataList = (ArrayList) ppgInfo.getPpgData();
            for (int i = 0; i < ppgDataList.size(); i++) {

                if (startPPGMeasurementTime == 0) {
                    startPPGMeasurementTime = System.currentTimeMillis();
                }
                endPPGMeasurementTime = System.currentTimeMillis();

                double ppgPoint = (double) ppgDataList.get(i);

//                Log.i(TAG, "point: " + ppgPoint);

                PpgInfoModel ppgInfoModel = new PpgInfoModel();
                ppgInfoModel.setPoint(ppgPoint);
                ppgInfoModel.setStartTime(startPPGMeasurementTime);
                ppgInfoModel.setEndTime(endPPGMeasurementTime);
                try {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onResponsePpgInfo", ppgInfoModel.toMap());
                        }
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        }

        @Override
        public void onResponseHeartInfo(HeartInfo heartInfo) {
            super.onResponseHeartInfo(heartInfo);
            Log.i(TAG, "onResponseHeartInfo: " + heartInfo.toString());
        }
    };

    @Override
    public void onScanDevice(DeviceModel deviceModel) {

        try {
            deviceModelArrayList.add(deviceModel);
            if (channel != null) {
                channel.invokeMethod("getDeviceList", deviceModel.toMap());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onScanBLEDevice(BLEDeviceModel deviceModel) {
        try {
            devices.add(deviceModel);
            if (channel != null) {
                channel.invokeMethod("getBLEDeviceList", deviceModel.toMap());
            }
        } catch (Exception e) {
            Log.e(TAG, "onScanBLEDevice: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void connectEvent(ConnectEvent connectEvent) {
//        baseOrderSet();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
        unbindService(mServiceConnection);
        System.exit(1);
    }

    @Override
    public void onGetMotionData(ArrayList<MotionInfoModel> motionInfoModelList) {
        try {
            ArrayList listOfMap = new ArrayList();
            for (MotionInfoModel model : motionInfoModelList) {
                listOfMap.add(model.toMap());
            }
            runOnUiThread(() -> channel.invokeMethod("onResponseMotionInfoE66", listOfMap));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetSleepData(ArrayList<SleepInfoModel> sleepInfoModelList) {
        try {
            ArrayList listOfMap = new ArrayList();
            for (SleepInfoModel model : sleepInfoModelList) {
                listOfMap.add(model.toMap());
            }
            runOnUiThread(() -> channel.invokeMethod("onResponseSleepInfoE66", listOfMap));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetECGData(EcgInfoModel ecgInfoModel) {
        try {
            runOnUiThread(() -> {

                if (startECGMeasurementTime == 0) {
                    startECGMeasurementTime = System.currentTimeMillis();
                }
                endECGMeasurementTime = System.currentTimeMillis();
                ecgInfoModel.setStartTime(startECGMeasurementTime);
                ecgInfoModel.setEndTime(endECGMeasurementTime);
                channel.invokeMethod("onResponseEcgInfo", ecgInfoModel.toMap());
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetLeadStatus(LeadStatusModel leadStatusModel) {
        try {
            runOnUiThread(() -> {
                channel.invokeMethod("onResponseLeadStatus", leadStatusModel.toMap());

            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetPPGData(PpgInfoModel ppgInfoModel) {
        try {
            runOnUiThread(() -> {

                if (startPPGMeasurementTime == 0) {
                    startPPGMeasurementTime = System.currentTimeMillis();
                }
                endPPGMeasurementTime = System.currentTimeMillis();
                ppgInfoModel.setStartTime(startPPGMeasurementTime);
                ppgInfoModel.setEndTime(endPPGMeasurementTime);
                channel.invokeMethod("onResponsePpgInfo", ppgInfoModel.toMap());
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetHRData(int hr, int sbp, int dbp) {
        HashMap map = new HashMap();
        map.put("hr", hr);
        map.put("sbp", sbp);
        map.put("dbp", dbp);
        try {
            runOnUiThread(() -> channel.invokeMethod("onGetHRData", map));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetTempData(ArrayList mapList) {
        try {
            runOnUiThread(() -> channel.invokeMethod("onGetTempData", mapList));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetHeartRateData(ArrayList map) {
        try {

            runOnUiThread(() -> {
                if (collectHeartRate != null && collectHeartRate.method != null && collectHeartRate.method.equals("collectHeartRateHistory")) {
                    if (collectHeartRateResult != null) {
                        collectHeartRateResult.success(map);
                        collectHeartRateResult = null;
                    }
                }
            });
            runOnUiThread(() -> channel.invokeMethod("onGetHeartRateData", map));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onE66DeviceConnect(boolean isConnected) {
        try {
            runOnUiThread(() -> {
                if (call != null && call.method != null && call.method.equals("connectToDevice")) {
                    if (resultForConnect != null) {
                        resultForConnect.success(isConnected);
                        resultForConnect = null;
                    }
                }
            });

            runOnUiThread(() -> {
                if (call != null && call.method != null && call.method.equals("tryToReconnect")) {
                    if (resultForReconnect != null) {
                        resultForReconnect.success(isConnected);
                        resultForReconnect = null;
                    }
                }
            });
            if (isConnected && channel != null && deviceModel != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (channel != null) {
                            channel.invokeMethod("onConnectIosDevice", deviceModel.toMap());
                        }
                    }
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void onE66DeviceDisConnect() {
        try {
            runOnUiThread(() -> {
                if (call != null && call.method != null && call.method.equals("disConnectToDevice")) {
                    if (resultForDisConnect != null) {
                        resultForDisConnect.success(true);
                        resultForDisConnect = null;
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onResponseE80RealTimeMotionData(HashMap map) {
        try {
            runOnUiThread(() -> channel.invokeMethod("onResponseE80RealTimeMotionData", map));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetAlarmList(HashMap map) {
        try {
            if (getAlarmCall != null && getAlarmCall.method != null && getAlarmCall.method.equals("getAlarmListOfE80")) {
                runOnUiThread(() -> {
                    getAlarmCallResult.success(map);
                    getAlarmCall = null;
                    getAlarmCallResult = null;
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onAddAlarm(HashMap map) {
        try {
            if (addAlarmCall != null && addAlarmCall.method != null && (addAlarmCall.method.equals("addE80SDKAlarm") || addAlarmCall.method.equals("modifyE80SDKAlarm") || addAlarmCall.method.equals("deleteE80SDKAlarm"))) {
                runOnUiThread(() -> {
                    addAlarmCallResult.success(map);
                    addAlarmCall = null;
                    addAlarmCallResult = null;
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetHeartRateFromRunMode(int heartRate) {
        try {
            runOnUiThread(() -> channel.invokeMethod("onGetHeartRateFromRunMode", heartRate));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void startModeSuccess() {
        try {
            if (startModeCall != null) {
                runOnUiThread(() -> {
                    startModeResult.success(true);
                    startModeCall = null;
                    startModeResult = null;
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void stopModeSuccess() {
        try {
            if (stopModeCall != null) {
                runOnUiThread(() -> {
                    stopModeResult.success(true);
                    stopModeCall = null;
                    stopModeResult = null;
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onGetRealTemp(double number) {
        try {
            runOnUiThread(() -> channel.invokeMethod("onGetRealTemp", number));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onConnectResponse(int i) {
        try {
            runOnUiThread(() -> {
                if (resultForReconnect != null) {
                    resultForReconnect.success(true);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private class CallStateListener extends PhoneStateListener {
        @Override
        public void onCallStateChanged(int state, String incomingNumber) {
            if (state == TelephonyManager.CALL_STATE_RINGING) {// called when someone is ringing to this phone
                Intent msgrcv = new Intent("Msg");
                msgrcv.putExtra("package", "com.luutinhit.secureincomingcall");
                msgrcv.putExtra("title", "Call");
                msgrcv.putExtra("text", incomingNumber);
                LocalBroadcastManager.getInstance(context).sendBroadcast(msgrcv);
            }
        }
    }


    //region --------------------google fit-----------------------
    private void googleAuthentication() {
        fitnessOptions = FitnessOptions.builder()
                .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_SLEEP_SEGMENT, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_SLEEP_SEGMENT, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_HEART_POINTS, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_HEART_POINTS, FitnessOptions.ACCESS_WRITE)

                .addDataType(TYPE_HEART_RATE_BPM, FitnessOptions.ACCESS_READ)
                .addDataType(TYPE_HEART_RATE_BPM, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_HEIGHT, FitnessOptions.ACCESS_READ)
                .addDataType(TYPE_WEIGHT, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.AGGREGATE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.AGGREGATE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_WRITE)

                //.addDataType(DataType.TYPE_NUTRITION, FitnessOptions.ACCESS_READ)
                //.addDataType(DataType.TYPE_NUTRITION, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_ACTIVITY_SEGMENT, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_ACTIVITY_SEGMENT, FitnessOptions.ACCESS_WRITE)

                .addDataType(TYPE_BLOOD_PRESSURE, FitnessOptions.ACCESS_READ)
                .addDataType(TYPE_BLOOD_PRESSURE, FitnessOptions.ACCESS_WRITE)

                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_PRESSURE_SUMMARY, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_PRESSURE_SUMMARY, FitnessOptions.ACCESS_WRITE)

                .addDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE, FitnessOptions.ACCESS_WRITE)

                /// Added by: Chaitanya
                /// Added on: Oct/8/2021
                /// oetmission ask when user need to acces fit data (body temp and Oxygen data)
                .addDataType(HealthDataTypes.TYPE_BODY_TEMPERATURE, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.TYPE_BODY_TEMPERATURE, FitnessOptions.ACCESS_WRITE)

                .addDataType(HealthDataTypes.TYPE_OXYGEN_SATURATION, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.TYPE_OXYGEN_SATURATION, FitnessOptions.ACCESS_WRITE)

                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_GLUCOSE_SUMMARY, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_GLUCOSE_SUMMARY, FitnessOptions.ACCESS_WRITE)
                .build();

        /// Added by: Chaitanya
        /// Added on: Oct/8/2021
        /// change in method as per new google fit update.
        try {
            GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
//                    .requestIdToken(getString(R.string.google_token))
                    .requestEmail()
                    .addExtension(fitnessOptions)
                    .build();
            GoogleSignInClient mGoogleSignInClient = GoogleSignIn.getClient(this, gso);
            Intent signInIntent = mGoogleSignInClient.getSignInIntent();
            startActivityForResult(signInIntent, Constants.googleFitSignInRequestCode);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //region for google fit api
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        try {

            if (requestCode == Constants.googleFitSignInRequestCode) {
                Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
                account = task.getResult();
                try {
                    if (resultForRequestAuth != null) {
                        resultForRequestAuth.success(true);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                /// Added by: Chaitanya
                /// Added on: Oct/8/2021
                /// add nullable condition.
                if (account != null) {
                    googleFitData.setAccount(account);
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (resultForRequestAuth != null) {
                    resultForRequestAuth.success(false);
                }
            } catch (Exception exception) {
                exception.printStackTrace();
            }
        }
    }

    void checkAndRequestAccess() {
        try {
            if (account == null) {
                googleAuthentication();
                Log.e("GFit : account", String.valueOf(account != null));
                /*showGoogleFitPermissionInfoDialog(new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                        googleAuthentication();
                    }
                }, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });*/
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (account != null) {
            if (!GoogleSignIn.hasPermissions(account, fitnessOptions)) {
                Log.e("GFit : permission", String.valueOf(GoogleSignIn.hasPermissions(account, fitnessOptions)));
                showGoogleFitPermissionInfoDialog(new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                        GoogleSignIn.requestPermissions(MainActivity.this, Constants.googleFitSignInRequestCode, account, fitnessOptions);
                    }
                }, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });
            } else {
                try {
                    if (call != null) {
                        resultForRequestAuth.success(true);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
    //endregion

    void showGoogleFitPermissionInfoDialog(final DialogInterface.OnClickListener successListener, final DialogInterface.OnClickListener cancelListener) {
        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
        builder.setCancelable(true);
        builder.setIcon(R.drawable.icon_google_fit);
        builder.setTitle("Google Fit");
        builder.setMessage("Turning on this feature sync your fitness data to Google Fit. Google Fit helps you reach your fitness goals by tracking your daily habits, Such as activity, sleep and fitness.");
        builder.setPositiveButton("Connect to Google Fit", successListener);
        builder.setNegativeButton("Skip", cancelListener);
        AlertDialog alert = builder.create();
        alert.show();
    }

    void handleIntent() {
        try {
            String url = null;
            Intent intent = getIntent();
            if (intent != null) {
                url = intent.getStringExtra(Constants.dynamicLinkUrl);
            }

            if (url == null) {
                assert intent != null;
                Uri appLinkData = intent.getData();
                if (appLinkData != null) {
                    url = appLinkData.toString();
                }
            }

            if (url != null) {
                Uri uri = Uri.parse(url);
                String path = uri.getPath();
                if (path != null && path.contains("features")) {
                    final String[] queryValue = {uri.getQueryParameter("featureName")};

                    if (!queryValue[0].trim().isEmpty()) {


                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if (channel != null) {
                                    if (queryValue[0].toLowerCase().trim().contains("tell health gauge".trim())) {
                                        queryValue[0] = "Tell Health Gauge";
                                    }
                                    channel.invokeMethod("onGetMeasurementQuery", queryValue[0]);
                                }
                            }
                        });
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
    }


    private String getMemoryInfo() {
        try {

            ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
            ActivityManager activityManager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
            activityManager.getMemoryInfo(memoryInfo);

            Runtime runtime = Runtime.getRuntime();
            int threadCount = Thread.activeCount();

            double toMB = 1024 * 1024;

            return
                    "Available Memory = " + memoryInfo.availMem / toMB + ","
                            + "Total Memory = " + memoryInfo.totalMem / toMB + ","
                            + "Runtime Max Memory = " + runtime.maxMemory() / toMB + ","
                            + "Runtime Total Memory = " + runtime.totalMemory() / toMB + ","
                            + "Runtime Free Memory = " + runtime.freeMemory() / toMB + ","
                            + "Thread Count = " + threadCount

                    ;

        } catch (Exception e) {
            return "Some exception occured when getting memory";
        }
    }

    private void callGc() {
        Runtime.getRuntime().gc();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case REQUEST_CODE_GET_BT_DEVICE_LIST:
                if (Utils.isAllPermissionGranted(grantResults)) {
                    getDeviceList();
                }
                break;
            case REQUEST_CODE_GET_BLE_DEVICE_LIST:
                if (Utils.isAllPermissionGranted(grantResults)) {
                    getDeviceList();
                }
                break;
        }
    }
}