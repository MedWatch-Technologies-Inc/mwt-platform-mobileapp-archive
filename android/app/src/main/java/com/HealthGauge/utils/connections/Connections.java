package com.HealthGauge.utils.connections;

import static android.content.Context.ALARM_SERVICE;
import static com.HealthGauge.app.MyFlutterApp.myApplication;
import static com.zjw.zhbraceletsdk.ZhBraceletUtils.openNotificationAccess;
import static com.zjw.zhbraceletsdk.application.ZhbraceletApplication.getZhBraceletService;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import com.HealthGauge.e66.E66DataListener;
import com.HealthGauge.models.AlarmModel;
import com.HealthGauge.models.BLEDeviceModel;
import com.HealthGauge.models.CollectECGModel;
import com.HealthGauge.models.DeviceModel;
import com.HealthGauge.models.E80AlarmModel;
import com.HealthGauge.models.EcgInfoModel;
import com.HealthGauge.models.LeadStatusModel;
import com.HealthGauge.models.MotionInfoModel;
import com.HealthGauge.models.PpgInfoModel;
import com.HealthGauge.models.SleepDataInfo;
import com.HealthGauge.models.SleepInfoModel;
import com.HealthGauge.models.TempModel;
import com.HealthGauge.services.AlarmReceiver;
import com.HealthGauge.services.MyBroadcastReceiver;
import com.HealthGauge.utils.Constants;
import com.HealthGauge.utils.PrefUtils;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.inuker.bluetooth.library.Code;
import com.inuker.bluetooth.library.search.SearchResult;
import com.inuker.bluetooth.library.search.response.SearchResponse;
import com.veepoo.protocol.listener.IBloodGlucoseChangeListener;
import com.veepoo.protocol.listener.base.IBleWriteResponse;
import com.veepoo.protocol.listener.base.INotifyResponse;
import com.veepoo.protocol.listener.data.IAllHealthDataListener;
import com.veepoo.protocol.listener.data.IDeviceFuctionDataListener;
import com.veepoo.protocol.listener.data.IECGDetectListener;
import com.veepoo.protocol.listener.data.IECGReadDataListener;
import com.veepoo.protocol.listener.data.IFindDevicelistener;
import com.veepoo.protocol.listener.data.IPttDetectListener;
import com.veepoo.protocol.listener.data.IPwdDataListener;
import com.veepoo.protocol.listener.data.ISleepDataListener;
import com.veepoo.protocol.listener.data.ISocialMsgDataListener;
import com.veepoo.protocol.listener.data.ISportDataListener;
import com.veepoo.protocol.model.datas.EcgDetectInfo;
import com.veepoo.protocol.model.datas.EcgDetectResult;
import com.veepoo.protocol.model.datas.EcgDetectState;
import com.veepoo.protocol.model.datas.FunctionDeviceSupportData;
import com.veepoo.protocol.model.datas.FunctionSocailMsgData;
import com.veepoo.protocol.model.datas.OriginData;
import com.veepoo.protocol.model.datas.OriginHalfHourData;
import com.veepoo.protocol.model.datas.PwdData;
import com.veepoo.protocol.model.datas.SleepData;
import com.veepoo.protocol.model.datas.SportData;
import com.veepoo.protocol.model.datas.TimeData;
import com.veepoo.protocol.model.enums.EBloodGlucoseStatus;
import com.veepoo.protocol.model.enums.EEcgDataType;
import com.veepoo.protocol.model.settings.Alarm2Setting;
import com.yucheng.ycbtsdk.AITools;
import com.yucheng.ycbtsdk.Bean.ScanDeviceBean;
import com.yucheng.ycbtsdk.Response.BleConnectResponse;
import com.yucheng.ycbtsdk.Response.BleDataResponse;
import com.yucheng.ycbtsdk.Response.BleDeviceToAppDataResponse;
import com.yucheng.ycbtsdk.Response.BleRealDataResponse;
import com.yucheng.ycbtsdk.Response.BleScanResponse;
import com.yucheng.ycbtsdk.YCBTClient;
import com.yucheng.ycbtsdk.a.b;
import com.zjw.zhbraceletsdk.ZhBraceletUtils;
import com.zjw.zhbraceletsdk.application.ZhbraceletApplication;
import com.zjw.zhbraceletsdk.bean.AlarmInfo;
import com.zjw.zhbraceletsdk.bean.BleDeviceWrapper;
import com.zjw.zhbraceletsdk.bean.DeviceInfo;
import com.zjw.zhbraceletsdk.bean.DrinkInfo;
import com.zjw.zhbraceletsdk.bean.MedicalInfo;
import com.zjw.zhbraceletsdk.bean.SitInfo;
import com.zjw.zhbraceletsdk.bean.UserInfo;
import com.zjw.zhbraceletsdk.linstener.ConnectorListener;
import com.zjw.zhbraceletsdk.linstener.ScannerListener;
import com.zjw.zhbraceletsdk.linstener.SimplePerformerListener;
import com.zjw.zhbraceletsdk.scan.ScanDevice;
import com.zjw.zhbraceletsdk.service.NotificationSetting;
import com.zjw.zhbraceletsdk.service.ZhBraceletService;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.veepoo.protocol.VPOperateManager;

import java.nio.ByteBuffer;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import aicare.net.cn.aicareutils.BuildConfig;
import aicare.net.cn.iweightlibrary.entity.BroadData;
import aicare.net.cn.iweightlibrary.utils.AicareBleConfig;
import aicare.net.cn.iweightlibrary.wby.WBYService;

public class Connections implements ScannerListener {


    ArrayList<BleDeviceWrapper> bleDeviceWrapperArrayList = new ArrayList<>();

    ArrayList<BroadData> weightScaleDeviceList = new ArrayList<>();
    private WBYService.WBYBinder binder;
    BroadData connectedDevice;

    private DeviceScanListener deviceScanListener;
    private BLEDeviceScanListener bleDeviceScanListener;


    private int sdkType = 2;
    private boolean isMeasureOn = false;

    public int getSdkType() {
        return sdkType;
    }

    public void setSdkType(int sdkType) {
        this.sdkType = sdkType;
    }

    private ScanDevice mScanDevice = new ScanDevice();

    private ZhBraceletService mBleService;

    public ZhBraceletService getmBleService() {
        return mBleService;
    }

    public ConnectorListener connectorListener;

    SimplePerformerListener simplePerformerListener;

    Context context;

    NotificationSetting mNotificationSetting = ZhbraceletApplication.getNotificationSetting();

    DrinkInfo mDrinkInfo;
    MedicalInfo mMedicalInfo;
    SitInfo mSitInfo;
    ArrayList<AlarmInfo> alarmInfoArrayList = new ArrayList<>();

    PrefUtils prefUtils;

    public static E66DataListener e66DataListener;
    private String TAG = "Constatns";
    private AITools aiTools;

    BleConnectResponse bleConnectResponse;

    DeviceModel requestedDeviceToConnect = null;
    Intent intent;
    ServiceConnection mServiceConnection;

    boolean isRegistred = false;

    long startECGMeasurementTime;
    long startPPGMeasurementTime;

    long endECGMeasurementTime;
    long endPPGMeasurementTime;
    private List<BluetoothDevice> devices = new ArrayList<>();


    ///New SDK implementation
    VPOperateManager hBandkSdk;

    public Connections(DeviceScanListener deviceScanListener, BLEDeviceScanListener bleDeviceScanListener, ConnectorListener connectorListener, SimplePerformerListener simplePerformerListener, E66DataListener e66DataListener, Context context, BleConnectResponse bleConnectResponse, Intent intent, ServiceConnection mServiceConnection) {
        try {
            prefUtils = new PrefUtils(context);
            this.deviceScanListener = deviceScanListener;
            this.bleDeviceScanListener = bleDeviceScanListener;
            this.mScanDevice.addScannerListener(this);
            this.mBleService = getZhBraceletService();
            this.connectorListener = connectorListener;
            this.simplePerformerListener = simplePerformerListener;
            this.context = context;
            this.mNotificationSetting = myApplication.getNotificationSetting();
            this.bleConnectResponse = bleConnectResponse;
            this.e66DataListener = e66DataListener;
            this.hBandkSdk = VPOperateManager.getMangerInstance(context);
            if (mBleService != null) {
                alarmInfoArrayList = mBleService.getAlarmData();
                mBleService.addConnectorListener(this.connectorListener);
                mBleService.addSimplePerformerListenerLis(this.simplePerformerListener);
            }
            this.intent = intent;
            this.mServiceConnection = mServiceConnection;

        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void findDevice() {
        try {
            if (sdkType == Constants.zhBle) {
                if (mBleService == null) {
                    mBleService = ZhbraceletApplication.getZhBraceletService();
                    mBleService.addConnectorListener(connectorListener);
                    mBleService.addSimplePerformerListenerLis(simplePerformerListener);
                }
                mBleService.findDevice();
            }
            if (sdkType == Constants.e66) {
                YCBTClient.appFindDevice(0x01, 2, 2, new BleDataResponse() {
                    @Override
                    public void onDataResponse(int i, float v, HashMap hashMap) {
                        Log.i(TAG, "appFindDevice: ");
                    }
                });
            }
            if (sdkType == Constants.hBand) {
                hBandkSdk.startFindDeviceByPhone(new IBleWriteResponse() {
                    @Override
                    public void onResponse(int i) {

                    }
                }, new IFindDevicelistener() {
                    @Override
                    public void unSupportFindDeviceByPhone() {

                    }

                    @Override
                    public void findedDevice() {

                    }

                    @Override
                    public void unFindDevice() {

                    }

                    @Override
                    public void findingDevice() {

                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public boolean isConnected(Context context, boolean isCameFromMeasurement, int sdkType) {
        if (sdkType == Constants.e66) {
            try {
                int bleState = YCBTClient.connectState();
                Log.i(TAG, "connectState: " + bleState + " == " + (bleState == com.yucheng.ycbtsdk.Constants.BLEState.Connected || bleState == com.yucheng.ycbtsdk.Constants.BLEState.ReadWriteOK));
                return (bleState == com.yucheng.ycbtsdk.Constants.BLEState.Connected || bleState == com.yucheng.ycbtsdk.Constants.BLEState.ReadWriteOK);
//                return (bleState != com.yucheng.ycbtsdk.Constants.BLEState.Disconnect);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (sdkType == Constants.zhBle) {
            try {


                if (mBleService == null) {
                    mBleService = ZhbraceletApplication.getZhBraceletService();
                    mBleService.addConnectorListener(connectorListener);
                    mBleService.addSimplePerformerListenerLis(simplePerformerListener);
//                    mBleService.unbindService(mServiceConnection);
//                    mBleService.bindService(intent,mServiceConnection,Context.BIND_AUTO_CREATE);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (ZhBraceletUtils.DeviceIsBand(context) && mBleService.getBleConnectState()) {
                try {
                    mBleService.syncTime();
                    return true;
//                if (!isCameFromMeasurement) {
//                    mBleService.tryConnectDevice();
//                }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                service_call();
                return true;
            } else {
                try {
                    String address = new PrefUtils(context).getString(Constants.connectedDeviceAddress);
                    int sdkTypeInSave = new PrefUtils(context).getInt(Constants.connectedDeviceSDKType);
                    if (address != null && !address.isEmpty()) {
                        if (sdkTypeInSave == Constants.zhBle) {
                            if (requestedDeviceToConnect == null) {
                                DeviceModel requestedDeviceToConnect = new DeviceModel();
                                requestedDeviceToConnect.setDeviceAddress(address);
                            }
                            startScanning(Constants.zhBle);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public void tryToReconnect() {
        try {
            if (sdkType == Constants.e66) {
                YCBTClient.reconnectBle(new BleConnectResponse() {
                    @Override
                    public void onConnectResponse(final int i) {
                        Log.i(TAG, "onConnectResponse: ----------------------------------------------- reconnected connected status " + i + " -----------------------------------------------");
                        if (i == com.yucheng.ycbtsdk.Constants.CODE.Code_OK) {
                            Log.i(TAG, "onConnectResponse: ----------------------------------------------- reconnected connected -----------------------------------------------");
                            e66DataListener.onE66DeviceConnect(true);
                            openRegisterRealStepData();
                            YCBTClient.appTemperatureCorrect(0, 0, new BleDataResponse() {
                                @Override
                                public void onDataResponse(int i, float v, HashMap hashMap) {
                                    if (BuildConfig.DEBUG) {
                                        Log.i(TAG, "onDataResponse: appTemperatureCorrect " + hashMap);
                                    }
                                }
                            });
                        } else {
                            e66DataListener.onE66DeviceConnect(false);
                        }
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void startScanning(int sdkTypeFroScan) {
        try {
            SharedPreferences sharedPreferences = new PrefUtils(context).sharedpreferences;
            String address = sharedPreferences.getString(Constants.connectedDeviceAddress, null);
            if (address == null || address.trim().isEmpty()) {
                disConnectDevice();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (sdkTypeFroScan == Constants.zhBle) {
            try {
                mScanDevice.startSCan();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (sdkTypeFroScan == Constants.e66) {
            startScanInE66();
        } else if (sdkTypeFroScan == Constants.hBand) {
            newSDkScanInE66();
        }
    }

    public void stopScanning() {
        if (sdkType == Constants.zhBle) {
            try {
                mScanDevice.stopSCan();
                hBandkSdk.stopScanDevice();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (sdkType == Constants.e66) {
            YCBTClient.stopScanBle();
        }
        if (sdkType == Constants.hBand) {
            hBandkSdk.disconnectWatch(new IBleWriteResponse() {
                @Override
                public void onResponse(int i) {

                }
            });
        }
    }


    public void connectToDevice(DeviceModel device) {
        try {
            if (device != null) {
                if (device.getSdkType() == Constants.hBand) {
                    hBandkSdk.connectDevice(device.getDeviceAddress(), (i, bleGattProfile, b) -> {
                        Log.e(TAG, "connectState: " + i + "bleGattProfile" + bleGattProfile.toString());
                        Log.i(TAG, "onConnectResponse: ----------------------------------------------- connected status " + i + " -----------------------------------------------");

                        if (i == Code.REQUEST_SUCCESS) {
                            Log.i(TAG, "onConnectResponse: ----------------------------------------------- connected -----------------------------------------------");
                            new PrefUtils(context).setString(Constants.connectedDeviceAddress, device.getDeviceAddress());
                            new PrefUtils(context).setInt(Constants.connectedDeviceSDKType, device.getSdkType());
                            e66DataListener.onE66DeviceConnect(true);

                            /*getDataForE66();

                            openRegisterRealStepData();

                           *//* YCBTClient.appTemperatureCorrect(0, 0, new BleDataResponse() {
                                @Override
                                public void onDataResponse(int i, float v, HashMap hashMap) {
                                    if (BuildConfig.DEBUG) {
                                        Log.i(TAG, "onDataResponse: appTemperatureCorrect " + hashMap);
                                    }
                                }
                            });*/
                        } else {
                            e66DataListener.onE66DeviceConnect(false);
                        }

                    }, new INotifyResponse() {
                        @Override
                        public void notifyState(int i) {

                        }
                    });
                    hBandkSdk.confirmDevicePwd(new IBleWriteResponse() {
                        @Override
                        public void onResponse(int i) {
                            if (i == Code.REQUEST_SUCCESS) {
                                Log.i(TAG, "onConnectResponse: ----------------------------------------------- connected -----------------------------------------------");
                                new PrefUtils(context).setString(Constants.connectedDeviceAddress, device.getDeviceAddress());
                                new PrefUtils(context).setInt(Constants.connectedDeviceSDKType, device.getSdkType());
                                e66DataListener.onE66DeviceConnect(true);

//                                getDataForE66();
//
//                                openRegisterRealStepData();

                               /* YCBTClient.appTemperatureCorrect(0, 0, new BleDataResponse() {
                                    @Override
                                    public void onDataResponse(int i, float v, HashMap hashMap) {
                                        if (BuildConfig.DEBUG) {
                                            Log.i(TAG, "onDataResponse: appTemperatureCorrect " + hashMap);
                                        }
                                    }
                                });*/
                            } else {
                                e66DataListener.onE66DeviceConnect(false);
                            }
                        }
                    }, new IPwdDataListener() {
                        @Override
                        public void onPwdDataChange(PwdData pwdData) {

                        }
                    }, new IDeviceFuctionDataListener() {
                        @Override
                        public void onFunctionSupportDataChange(FunctionDeviceSupportData functionDeviceSupportData) {

                        }
                    }, new ISocialMsgDataListener() {
                        @Override
                        public void onSocialMsgSupportDataChange(FunctionSocailMsgData functionSocailMsgData) {

                        }

                        @Override
                        public void onSocialMsgSupportDataChange2(FunctionSocailMsgData functionSocailMsgData) {

                        }
                    }, "0000", false);
                } else if (device.getSdkType() == Constants.e66) {
                    bleConnectResponse = new BleConnectResponse() {
                        @Override
                        public void onConnectResponse(final int i) {
                            Log.i(TAG, "onConnectResponse: ----------------------------------------------- connected status " + i + " -----------------------------------------------");
                            if (i == com.yucheng.ycbtsdk.Constants.CODE.Code_OK) {
                                Log.i(TAG, "onConnectResponse: ----------------------------------------------- connected -----------------------------------------------");
                                new PrefUtils(context).setString(Constants.connectedDeviceAddress, device.getDeviceAddress());
                                new PrefUtils(context).setInt(Constants.connectedDeviceSDKType, device.getSdkType());
                                e66DataListener.onE66DeviceConnect(true);

//                            getDataForE66();

                                openRegisterRealStepData();

                                YCBTClient.appTemperatureCorrect(0, 0, new BleDataResponse() {
                                    @Override
                                    public void onDataResponse(int i, float v, HashMap hashMap) {
                                        if (BuildConfig.DEBUG) {
                                            Log.i(TAG, "onDataResponse: appTemperatureCorrect " + hashMap);
                                        }
                                    }
                                });
                            } else {
                                e66DataListener.onE66DeviceConnect(false);
                            }

                        }
                    };
                    YCBTClient.connectBle(device.getDeviceAddress(), bleConnectResponse);
                    YCBTClient.registerBleStateChange(bleConnectResponse);

                } else if (device.isWeightScaleDevice()) {
                    if (mBleService == null) {
                        mBleService = ZhbraceletApplication.getZhBraceletService();
                        mBleService.addConnectorListener(connectorListener);
                        mBleService.addSimplePerformerListenerLis(simplePerformerListener);
                    }

                    BroadData selectedDevice = null;
                    for (BroadData value : weightScaleDeviceList) {
                        if (value.getAddress().equals(device.getDeviceAddress())) {
                            selectedDevice = value;
                            break;
                        }
                    }
                    if (selectedDevice != null) {
                        if (selectedDevice.getDeviceType() != AicareBleConfig.TYPE_WEI_BROAD && selectedDevice.getDeviceType() != AicareBleConfig.TYPE_WEI_TEMP_BROAD && selectedDevice.getDeviceType() != AicareBleConfig.BM_09 && selectedDevice.getDeviceType() != AicareBleConfig.BM_15) {
                            connectedDevice = selectedDevice;
                        }
                    }
                } else {
//                    mBleService.bindService(intent,mServiceConnection, Context.BIND_AUTO_CREATE);
                    requestedDeviceToConnect = device;
                    if (mBleService == null) {
                        mBleService = ZhbraceletApplication.getZhBraceletService();
                        mBleService.addConnectorListener(connectorListener);
                        mBleService.addSimplePerformerListenerLis(simplePerformerListener);
                    }

                    BleDeviceWrapper bleDeviceWrapper = null;
                    for (BleDeviceWrapper value : bleDeviceWrapperArrayList) {
                        if (value.getDeviceAddress().equals(device.getDeviceAddress())) {
                            bleDeviceWrapper = value;
                            break;
                        }
                    }

                    if (bleDeviceWrapper != null) {
                        mBleService.BindDevice(bleDeviceWrapper);
                        mBleService.tryConnectDevice();
                        new PrefUtils(context).setString(Constants.connectedDeviceAddress, device.getDeviceAddress());
                        new PrefUtils(context).setInt(Constants.connectedDeviceSDKType, device.getSdkType());
                    } else {
                        mScanDevice.startSCan();
                    }
                }

                service_call();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void connectToBLEDevice(BLEDeviceModel device) {
        try {
            if (device != null) {

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void connectToE08(BleDeviceWrapper bleDeviceWrapper) {
        try {
            if (bleDeviceWrapper != null) {


                if (mBleService == null) {
                    mBleService = ZhbraceletApplication.getZhBraceletService();
                    mBleService.addConnectorListener(connectorListener);
                    mBleService.addSimplePerformerListenerLis(simplePerformerListener);
                }


                mBleService.BindDevice(bleDeviceWrapper);
                mBleService.tryConnectDevice();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void getDeviceInformation() {
        if (sdkType == Constants.e66) {
            YCBTClient.getDeviceInfo(new BleDataResponse() {
                @Override
                public void onDataResponse(int code, float ratio, HashMap resultMap) {
                    try {
                        if (resultMap != null) {
                            HashMap data = (HashMap) resultMap.get("data");
                            if (data != null) {
                                Log.i(TAG, "onDataResponse: " + resultMap.toString());
                                DeviceInfo deviceInfoModel = new DeviceInfo();
                                if (connectedDevice != null) {
                                    deviceInfoModel.setDeviceVersionName(connectedDevice.getName());
                                }
                                if (data != null && data.containsKey("deviceBatteryValue") && data.get("deviceBatteryValue") != null) {
                                    deviceInfoModel.setDeviceBattery((int) data.get("deviceBatteryValue"));
                                }
                                if (data != null && data.containsKey("deviceId") && data.get("deviceId") != null) {
                                    deviceInfoModel.setDeviceVersionNumber((int) data.get("deviceId"));
                                }
                                simplePerformerListener.onResponseDeviceInfo(deviceInfoModel);
                            }
                        }
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    }

    private void getSportDataFromE66() {
//        YCBTClient.settingDataCollect();
        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x0502, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    if (hashMap != null) {

                        ArrayList<HashMap> lists = (ArrayList<HashMap>) hashMap.get("data");
                        Collections.sort(lists, new Comparator<HashMap>() {
                            public int compare(HashMap p1, HashMap p2) {
                                long timeStampA = (long) p1.get("sportStartTime");
                                long timeStampB = (long) p1.get("sportStartTime");
                                if (timeStampA > timeStampB) {
                                    return 1;
                                } else {
                                    return 0;
                                }
                            }
                        });

                        DateFormat dateFormatForDateOnly = new SimpleDateFormat("yyyy-MM-dd");
                        ArrayList<String> dateList = new ArrayList<>();
                        for (int j = 0; j < lists.size(); j++) {
                            HashMap map = lists.get(j);
                            long timeStampA = (long) map.get("sportStartTime");

                            Date date = new Date(timeStampA);
                            String strDate = dateFormatForDateOnly.format(date);
                            if (!dateList.contains(strDate)) {
                                dateList.add(strDate);
                            }
                        }
                        ArrayList<ArrayList> listOfList = new ArrayList<ArrayList>();
                        for (int j = 0; j < dateList.size(); j++) {
                            String currentRecordDate = dateList.get(j);
                            ArrayList recordForDate = new ArrayList();
                            for (HashMap map : lists) {
                                long timeStampA = (long) map.get("sportStartTime");
                                Date date = new Date(timeStampA);
                                String strDate = dateFormatForDateOnly.format(date);
                                if (currentRecordDate.equals(strDate)) {
                                    recordForDate.add(map);
                                }
                            }
                            listOfList.add(recordForDate);
                        }

                        Log.i(TAG, "onDataResponse: getSportDataFromE66" + listOfList);

                        ArrayList<MotionInfoModel> listOfModel = new ArrayList<>();
                        for (ArrayList dayData : listOfList) {
                            MotionInfoModel motionInfoModel = new MotionInfoModel();

                            int totalStep = 0;
                            int totalCalories = 0;
                            int totalDistance = 0;

                            ArrayList<Integer> stepList = new ArrayList<Integer>();
                            ArrayList<Integer> caloriesList = new ArrayList<Integer>();
                            ArrayList<Integer> distanceList = new ArrayList<Integer>();

                            for (int j = 0; j < 24; j++) {
                                stepList.add(0);
                                caloriesList.add(0);
                                distanceList.add(0);
                            }
                            for (int j = 0; j < dayData.size(); j++) {
                                HashMap data = (HashMap) dayData.get(j);

                                long timestamp = (long) data.get("sportStartTime");
                                Date date = new Date(timestamp);
                                int hour = date.getHours();
                                int step = (int) data.get("sportStep");
                                int distance = (int) data.get("sportDistance");
                                int sportCalorie = (int) data.get("sportCalorie");

                                totalStep += step;
                                totalDistance += distance;
                                totalCalories += sportCalorie;

                                step = stepList.get(hour) + step;
                                sportCalorie = caloriesList.get(hour) + sportCalorie;
                                distance = distanceList.get(hour) + distance;

                                stepList.set(hour, step);
                                caloriesList.set(hour, sportCalorie);
                                distanceList.set(hour, distance);


                                motionInfoModel.setDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
                                motionInfoModel.setCalories(totalCalories);
                                motionInfoModel.setStep(totalStep);
                                motionInfoModel.setDistance(totalDistance / 1000.0);
                                motionInfoModel.setData(stepList);
                                motionInfoModel.setCalorieData(caloriesList);
                                motionInfoModel.setDistanceData(distanceList);

                            }
                            listOfModel.add(motionInfoModel);
                        }
                        Log.i(TAG, "sport data: " + listOfModel.toString());

                        e66DataListener.onGetMotionData(listOfModel);

                    }
                }
            });

        }
        if (sdkType == Constants.hBand) {
            hBandkSdk.readSportStep(new IBleWriteResponse() {
                @Override
                public void onResponse(int i) {

                }
            }, new ISportDataListener() {
                @Override
                public void onSportDataChange(SportData sportData) {
                    ArrayList<MotionInfoModel> listOfModel = new ArrayList<>();
                    MotionInfoModel motionInfoModel = new MotionInfoModel();
                    motionInfoModel.setCalories((float) sportData.getKcal());
                    motionInfoModel.setDistance(sportData.getDis());
                    motionInfoModel.setStep(sportData.getStep());
                    listOfModel.add(motionInfoModel);
                    new Handler().post(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(mBleService, motionInfoModel.toMap() + "", Toast.LENGTH_SHORT).show();
                        }
                    });
                 //   e66DataListener.onGetMotionData(listOfModel);
                }
            });
        }

    }

    public void getSleepDataFromE66() {
        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x0504, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    if (hashMap != null) {
                        JSONObject json = new JSONObject(hashMap);
                        Log.i(TAG, "onDataResponse: " + json.toString());
                        ArrayList<HashMap> lists = (ArrayList<HashMap>) hashMap.get("data");


                        DateFormat dateFormatForDateOnly = new SimpleDateFormat("yyyy-MM-dd");
                        ArrayList<String> dateList = new ArrayList<String>();
                        for (int j = 0; j < lists.size(); j++) {
                            HashMap map = lists.get(j);
                            long timeStampA = (long) map.get("endTime");

                            Date date = new Date(timeStampA);
                            if (date.getHours() > 12) {
                                Calendar calendar = Calendar.getInstance();
                                calendar.setTime(date);
                                calendar.set(Calendar.HOUR, 0);
                                calendar.set(Calendar.MINUTE, 0);
                                calendar.add(Calendar.DATE, 1);
                                timeStampA = calendar.getTimeInMillis();
                                date = new Date(timeStampA);
                            }
                            String strDate = dateFormatForDateOnly.format(date);
                            if (!dateList.contains(strDate)) {
                                dateList.add(strDate);
                            }
                        }

                        try {
                            ArrayList<SleepInfoModel> sleepInfoModelArrayList = new ArrayList<>();
                            for (String currentDataDateStr : dateList) {
                                String dataDate1 = currentDataDateStr;
                                Date currentDate = dateFormatForDateOnly.parse(currentDataDateStr);
                                DateFormat hourMinuteDateFormat = new SimpleDateFormat("HH:mm");

                                //region calculate previous date
                                Calendar calendar = Calendar.getInstance();
                                calendar.setTime(currentDate);
                                calendar.add(Calendar.DATE, -1);
                                //endregion

                                Date previousDate = calendar.getTime();
                                String previousDateString = dateFormatForDateOnly.format(previousDate);

                                //region calculate next date
                                calendar = Calendar.getInstance();
                                calendar.setTime(currentDate);
                                calendar.add(Calendar.DATE, 1);
                                //endregion

                                Date nextDate = calendar.getTime();
                                String nextDateString = dateFormatForDateOnly.format(nextDate);


                                Date dateOfData = null;

                                SleepInfoModel sleepInfoModel = new SleepInfoModel();
                                int totalLightSleep = 0;
                                int totalDeepSleep = 0;
                                int totalAwake = 0;
                                ArrayList<SleepDataInfo> sleepDataInfoArrayList = new ArrayList<>();


                                for (int a = 0; a < lists.size(); a++) {
                                    HashMap data = lists.get(a);

                                    long endTime = (long) data.get("endTime");
                                    dateOfData = new Date(endTime);
                                    int endHour = dateOfData.getHours();
                                    String dataDate = dateFormatForDateOnly.format(dateOfData);

                                    if ((previousDateString.equals(dataDate) && endHour > 12) || (dataDate.equals(currentDataDateStr) && endHour < 12)) {

                                        totalLightSleep += (int) data.get("lightSleepTotal");
                                        totalDeepSleep += (int) data.get("deepSleepTotal");

                                        ArrayList<HashMap> dataList = (ArrayList<HashMap>) data.get("sleepData");
                                        for (int j = 0; j < dataList.size(); j++) {

                                            HashMap dayData = dataList.get(j);

                                            long startTimeStamp = (long) dayData.get("sleepStartTime");
                                            Date sleepStartDate = new Date(startTimeStamp);

                                            if (j == 0 && sleepDataInfoArrayList.size() > 0) {
                                                long previousTime = sleepDataInfoArrayList.get(sleepDataInfoArrayList.size() - 1).getTimeStamp();
                                                Date previousTimeDate = new Date(previousTime);
                                                long diff = sleepStartDate.getTime() - previousTimeDate.getTime();
                                                int minutes = (int) (diff / (1000 * 60));
                                                totalAwake += minutes;
                                                Log.i(TAG, "previousTime: " + minutes + " " + diff);
                                            }


                                            int type = (int) dayData.get("sleepType");
                                            int sleepLen = (int) dayData.get("sleepLen");

                                            if (type == 242) {
                                                //light
                                                type = 2;
                                            }
                                            if (type == 241) {
                                                //deep sleep
                                                type = 3;
                                            }
                                            SleepDataInfo dataInfo = new SleepDataInfo();

                                            dataInfo.setTime(hourMinuteDateFormat.format(sleepStartDate));
                                            dataInfo.setType(String.valueOf(type));
                                            sleepDataInfoArrayList.add(dataInfo);
                                        }

                                        long startTime = (long) data.get("endTime");
                                        Date sleepStartDate = new Date(startTime);
                                        String type = "0";

                                        SleepDataInfo dataInfo = new SleepDataInfo();
                                        dataInfo.setTime(hourMinuteDateFormat.format(sleepStartDate));
                                        dataInfo.setTimeStamp(startTime);
                                        dataInfo.setType(type);
                                        if (a == (lists.size() - 1)) {
                                            if (sleepDataInfoArrayList.size() > 0) {
                                                SleepDataInfo info = sleepDataInfoArrayList.get(sleepDataInfoArrayList.size() - 1);
                                                type = info.getType();
                                                dataInfo.setType(type);
                                            }
                                        }
                                        sleepDataInfoArrayList.add(dataInfo);
                                    }
                                }
                                sleepInfoModel.setLightTime(totalLightSleep);
                                sleepInfoModel.setDeepTime(totalDeepSleep);
                                sleepInfoModel.setStayUpTime(totalAwake);
                                if (dateOfData != null) {
                                    sleepInfoModel.setDate(currentDataDateStr);
                                }
                                sleepInfoModel.setAllTime(totalDeepSleep + totalLightSleep + totalAwake);
                                sleepInfoModel.setData(sleepDataInfoArrayList);
                                sleepInfoModelArrayList.add(sleepInfoModel);
                            }
                            e66DataListener.onGetSleepData(sleepInfoModelArrayList);
                        } catch (ParseException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });
        }
        if (sdkType == Constants.hBand) {
            hBandkSdk.readSleepData(new IBleWriteResponse() {
                @Override
                public void onResponse(int i) {

                }
            }, new ISleepDataListener() {
                @Override
                public void onSleepDataChange(String s, SleepData sleepData) {
                    ArrayList<SleepInfoModel> sleepInfoModelArrayList = new ArrayList<>();

                    SleepInfoModel sleepInfoModel = new SleepInfoModel();
                    sleepInfoModel.setDate(sleepData.Date);
                    sleepInfoModel.setAllTime(sleepData.allSleepTime);
                    sleepInfoModel.setLightTime(sleepData.getLowSleepTime());
                    sleepInfoModel.setWakInCount(sleepData.wakeCount);
                    sleepInfoModelArrayList.add(sleepInfoModel);

                    new Handler().post(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(mBleService, sleepInfoModel.toMap() + "", Toast.LENGTH_SHORT).show();
                        }
                    });
                }

                @Override
                public void onSleepProgress(float v) {

                }

                @Override
                public void onSleepProgressDetail(String s, int i) {

                }

                @Override
                public void onReadSleepComplete() {

                }
            }, 1);
        }
    }

    public static Map<String, Object> toMap(JsonObject object) throws JSONException {
        Map<String, Object> map = new HashMap<String, Object>();
        Map<String, Object> yourHashMap = new Gson().fromJson(object, HashMap.class);

        Iterator<String> keysItr = yourHashMap.keySet().iterator();
        while (keysItr.hasNext()) {
            String key = keysItr.next();
            Object value = object.get(key);

            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }


    public void getAllDataFromE66() {
        Log.i(TAG, "getAllDataFromE66: ");
        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x0509, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    if (hashMap != null) {
                        Log.i(TAG, "onDataResponse: " + hashMap);
                        if (hashMap.containsKey("data")) {
                            ArrayList list = (ArrayList) hashMap.get("data");
                            ArrayList<HashMap> arrayList = new ArrayList<>();
                            for (int j = 0; j < list.size(); j++) {

                                HashMap data = (HashMap) list.get(j);
                                int heartValue = (int) data.get("heartValue");
                                int hrvValue = (int) data.get("hrvValue");
                                int cvrrValue = (int) data.get("cvrrValue");
                                int OOValue = (int) data.get("OOValue");
                                int stepValue = (int) data.get("stepValue");
                                int dbpValue = (int) data.get("DBPValue");
                                int tempIntValue = (int) data.get("tempIntValue");
                                int tempFloatValue = (int) data.get("tempFloatValue");
                                long startTime = (long) data.get("startTime");
                                int SBPValue = (int) data.get("SBPValue");
                                int respiratoryRateValue = (int) data.get("respiratoryRateValue");


                                Date date = new Date(startTime);
                                String strDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);

                                TempModel model = new TempModel();
                                model.setHeartValue(heartValue);
                                model.setStepValue(stepValue);
                                model.setDBPValue(dbpValue);
                                model.setTempInt(tempIntValue);
                                model.setTempDouble(tempFloatValue);
                                model.setHRV(hrvValue);
                                model.setOxygen(OOValue);
                                model.setCvrrValue(cvrrValue);
                                model.setSBPValue(SBPValue);
                                model.setRespiratoryRateValue(respiratoryRateValue);
                                model.setDate(strDate);
                                arrayList.add(model.toJson());
                                Log.i(TAG, "onDataResponse_000: " + OOValue);
                            }

                            e66DataListener.onGetTempData(arrayList);
                        }
                    }
                    e66DataListener.onGetTempData(new ArrayList());

                }
            });

        }
    }

    private void getOxygenDataFromE66() {

        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x051A, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {

                    if (hashMap != null) {
                        ArrayList<HashMap> lists = (ArrayList<HashMap>) hashMap.get("data");
                        Log.i(TAG, "getOxygenDataFromE66_onDataResponse: " + lists);
                    }
                }
            });
        }
    }

    public void getTempDataFromE66() {
        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x0509, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {

                    if (hashMap != null) {
                        ArrayList<HashMap> lists = (ArrayList<HashMap>) hashMap.get("data");
                        e66DataListener.onGetTempData(lists);
                    }
                }
            });
        }
    }

    public static Map<String, Object> jsonToMap(JSONObject json) throws JSONException {
        Map<String, Object> retMap = new HashMap<String, Object>();

        if (json != JSONObject.NULL) {
            retMap = toMap(json);
        }
        return retMap;
    }

    public static HashMap<String, Object> toMap(JSONObject object) throws JSONException {
        HashMap<String, Object> map = new HashMap<String, Object>();

        Iterator<String> keysItr = object.keys();
        while (keysItr.hasNext()) {
            String key = keysItr.next();
            Object value = object.get(key);

            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }

    public static List<Object> toList(JSONArray array) throws JSONException {
        List<Object> list = new ArrayList<Object>();
        for (int i = 0; i < array.length(); i++) {
            Object value = array.get(i);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            list.add(value);
        }
        return list;
    }


    public void disConnectDevice() {
        new PrefUtils(context).remove(Constants.connectedDeviceAddress);
        new PrefUtils(context).remove(Constants.connectedDeviceSDKType);
        requestedDeviceToConnect = null;
//        if(sdkType == Constants.zhBle) {
        hBandkSdk.disconnectWatch(new IBleWriteResponse() {
            @Override
            public void onResponse(int i) {
                Log.e(TAG, "onDisconnet: " + i);
            }
        });
       /* try {
            if (mBleService == null) {
                mBleService = getZhBraceletService();
                if (mBleService != null) {
                    mBleService.addConnectorListener(this.connectorListener);
                    mBleService.addSimplePerformerListenerLis(this.simplePerformerListener);
                }
            }
            if (mBleService != null) {
                mBleService.UnBindDevice();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }*/


        try {
            if (binder != null) {
                binder.disconnect();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
//        }

//        if(sdkType == Constants.e66) {
        try {
            YCBTClient.disconnectBle();
            e66DataListener.onE66DeviceDisConnect();
        } catch (Exception e) {
            //e.printStackTrace();
        }
//        }
    }


    public void startMeasurement() {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.openMeasurement();
            }
        }
        if (sdkType == Constants.e66) {

            startMeasurementInE66();
        }
        if (sdkType == Constants.hBand) {
            startMeasurmentInHband();
        }
    }

    public void startMeasurmentInHband() {

        getHbandECG();

    }

    private void getBloodPHBand() {
        hBandkSdk.startBloodGlucoseDetect(new IBleWriteResponse() {
            @Override
            public void onResponse(int i) {

            }
        }, new IBloodGlucoseChangeListener() {
            @Override
            public void onDetectError(int i, EBloodGlucoseStatus eBloodGlucoseStatus) {

            }

            @Override
            public void onBloodGlucoseDetect(int i, int i1) {

            }

            @Override
            public void onBloodGlucoseStopDetect() {

            }

            @Override
            public void onBloodGlucoseAdjustingSettingSuccess(boolean b, float v) {

            }

            @Override
            public void onBloodGlucoseAdjustingSettingFailed() {

            }
        });
    }

    private void getHbandECG() {
        startECGMeasurementTime = 0;
        startPPGMeasurementTime = 0;

        endECGMeasurementTime = 0;
        endPPGMeasurementTime = 0;
        TimeData time = new TimeData();
        Calendar calendar = Calendar.getInstance();
        Date date = calendar.getTime();
        time.setSecond(date.getSeconds());
        time.setMinute(date.getMinutes());
        time.setHour(date.getHours());
        time.setDay(date.getDay());
        time.setMonth(date.getMonth());
        time.setYear(date.getYear());

        final int[] hr = {0};
        int hrv = 0;
        final int[] sbp = {0};
        final int[] dbp = {0};

        hBandkSdk.startReadPttSignData(new IBleWriteResponse() {
            @Override
            public void onResponse(int i) {

            }
        }, true, new IPttDetectListener() {
            @Override
            public void onEcgDetectInfoChange(EcgDetectInfo ecgDetectInfo) {
                endPPGMeasurementTime = getUTCDate(new Date()).getTime();
                if (startPPGMeasurementTime == 0) {
                    startPPGMeasurementTime = endPPGMeasurementTime;
                }
            }

            @Override
            public void onEcgDetectStateChange(EcgDetectState ecgDetectState) {

            }

            @Override
            public void onEcgDetectResultChange(EcgDetectResult ecgDetectResult) {

            }

            @Override
            public void onEcgADCChange(int[] ints) {

            }

            @Override
            public void inPttModel() {

            }

            @Override
            public void outPttModel() {

            }
        });

        hBandkSdk.startDetectECG(new IBleWriteResponse() {
            @Override
            public void onResponse(int i) {

            }
        }, true, new IPttDetectListener() {
            @Override
            public void onEcgDetectInfoChange(EcgDetectInfo ecgDetectInfo) {
                endECGMeasurementTime = getUTCDate(new Date()).getTime();
                if (startECGMeasurementTime == 0) {
                    startECGMeasurementTime = endECGMeasurementTime;
                }
            }

            @Override
            public void onEcgDetectStateChange(EcgDetectState ecgDetectState) {

            }

            @Override
            public void onEcgDetectResultChange(EcgDetectResult ecgDetectResult) {

                EcgInfoModel ecgInfoModel = new EcgInfoModel();
                ecgInfoModel.setApproxHr(ecgDetectResult.getAveHeart());
                ecgInfoModel.setApproxSBP(sbp[0]);
                ecgInfoModel.setApproxDBP(dbp[0]);
                ecgInfoModel.setHrv(ecgDetectResult.getAveHrv());

                ecgInfoModel.setStartTime(startECGMeasurementTime);
                ecgInfoModel.setEndTime(endECGMeasurementTime);
                new Handler().post(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(mBleService, ecgInfoModel.toMap() + "", Toast.LENGTH_SHORT).show();
                    }
                });
//                    ecgInfoModel.setPointList(newList);

                //  e66DataListener.onGetECGData(ecgInfoModel);
            }

            @Override
            public void onEcgADCChange(int[] ints) {

            }

            @Override
            public void inPttModel() {

            }

            @Override
            public void outPttModel() {

            }
        });
    }

    private void startMeasurementInE66() {
        startECGMeasurementTime = 0;
        startPPGMeasurementTime = 0;

        endECGMeasurementTime = 0;
        endPPGMeasurementTime = 0;

        final int[] hr = {0};
        int hrv = 0;
        final int[] sbp = {0};
        final int[] dbp = {0};


        AITools.getInstance().init();

        YCBTClient.settingWorkingMode(0x01, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: settingWorkingMode" + hashMap);
            }
        });


        YCBTClient.appEcgTestEnd(new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: appEcgTestEnd ");
            }
        });

        YCBTClient.appEcgTestStart(new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onRealDataResponse: IsMeasurement Started " + (i == 0));
            }
        }, new BleRealDataResponse() {
            @Override
            public void onRealDataResponse(int i, HashMap hashMap) {
                Log.i(TAG, "ECG PPG response " + hashMap);
                sendDataToFlutter(hashMap, hr, dbp, sbp, hrv);
            }
        });

//        appEcgTestStartDeviceToApp(new BleDataResponse() {
//            @Override
//            public void onDataResponse(int i, float v, HashMap hashMap) {
//                Log.i(TAG, "onRealDataResponse: IsMeasurement Started "+(i == 0));
//            }
//        }, new BleDeviceToAppDataResponse() {
//            @Override
//            public void onDataResponse(int i, HashMap hashMap) {
//                Log.i(TAG, "ECG PPG response " + hashMap);
//                sendDataToFlutter(hashMap, hr, dbp, sbp, hrv);
//            }
//        });

//        YCBTClient.appEcgTestStart(new BleDataResponse() {
//            @Override
//            public void onDataResponse(int i, float v, HashMap hashMap) {
//                Log.i(TAG, "onRealDataResponse: IsMeasurement Started "+(i == 0));
//            }
//        }, new BleRealECGResponse() {
//            @Override
//            public void onRealECGResponse(int i, HashMap hashMap) {
//                sendDataToFlutter(hashMap, hr, dbp, sbp, hrv);
//            }
//        });
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                YCBTClient.appEcgTestEnd(new BleDataResponse() {
                    @Override
                    public void onDataResponse(int i, float v, HashMap hashMap) {
                        Log.i(TAG, "onRealDataResponse: IsMeasurement End " + (i == 0));
                    }
                });
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        startECGRealTest();
                    }
                }, 1000);
            }
        }, 1000);

    }

    private void startECGRealTest() {

        final int[] hr = {0};
        int hrv = 0;
        final int[] sbp = {0};
        final int[] dbp = {0};

        YCBTClient.settingWorkingMode(0x01, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: settingWorkingMode" + hashMap);
            }
        });

        YCBTClient.appEcgTestStart(new BleDataResponse() {
            @Override
            public void onDataResponse(int code, float ratio, HashMap resultMap) {
                e66DataListener.onResponseStart(code == 0);
            }
        }, new BleRealDataResponse() {
            @Override
            public void onRealDataResponse(int type, HashMap dataMap) {
                Log.i(TAG, "sendDataToFlutter");

                sendDataToFlutter(dataMap, hr, dbp, sbp, hrv);
            }
        });

    }

    private void sendDataToFlutter(HashMap dataMap, int[] hr, int[] dbp, int[] sbp, int hrv) {
        int dataType = (int) dataMap.get("dataType");
        int second = Calendar.getInstance().get(Calendar.SECOND);
        int millisecond = Calendar.getInstance().get(Calendar.MILLISECOND);
        Log.i(TAG, "sendDataToFlutter_dataType" + dataType);
        Log.i(TAG, "sendDataToFlutter_dataType1" + com.yucheng.ycbtsdk.Constants.DATATYPE.Real_UploadBlood + " " + dataMap.get("heartValue"));

        if (dataType == com.yucheng.ycbtsdk.Constants.DATATYPE.Real_UploadBlood) {
            hr[0] = (int) dataMap.get("heartValue");//心率
            sbp   [0] = (int) dataMap.get("bloodSBP");//高压
            dbp [0] = (int) dataMap.get("bloodDBP");//低压
            Log.i(TAG, "onGetHRData_909data " + hr[0] + " " + sbp[0] + " " + dbp[0]);
            e66DataListener.onGetHRData(hr[0], sbp[0], dbp[0]);
        } else if (dataType == com.yucheng.ycbtsdk.Constants.DATATYPE.Real_UploadPPG) {

            endPPGMeasurementTime = getUTCDate(new Date()).getTime();
            if (startPPGMeasurementTime == 0) {
                startPPGMeasurementTime = endPPGMeasurementTime;
            }

            //PPG  dataMap
//                    byte[] ppgBytes = (byte[]) dataMap.get("data");
//                    ArrayList listOfIntegerPpg = (ArrayList) AITools.getInstance().ecgRealWaveFiltering(ppgBytes);
            byte[] ppgBytes = (byte[]) dataMap.get("data");
            Log.i(TAG, "onRealDataResponse: ppg data " + ppgBytes);
            ArrayList<Integer> listOfIntegerPpg = new ArrayList<>();

            try {
//
                List<byte[]> threeValueChunkList = divideArray(ppgBytes, 3);

                byte[] x = {0, 0, 0, 0};
                for (int i = 0; i < threeValueChunkList.size(); i++) {
                    byte[] array = threeValueChunkList.get(i);
                    x[0] = 0;
                    x[1] = array[2];
                    x[2] = array[1];
                    x[3] = array[0];
                    int val = ByteBuffer.wrap(x).getInt();
                    listOfIntegerPpg.add(val);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            Log.i(TAG, "sendDataToFlutter: Raw PPG Data " + listOfIntegerPpg);
            PpgInfoModel ppgInfoModel = new PpgInfoModel();
            ppgInfoModel.setPointList(listOfIntegerPpg);
            ppgInfoModel.setStartTime(startPPGMeasurementTime);
            ppgInfoModel.setEndTime(endPPGMeasurementTime);
            ppgInfoModel.setPointList(listOfIntegerPpg);
            e66DataListener.onGetPPGData(ppgInfoModel);
        } else if (dataType == com.yucheng.ycbtsdk.Constants.DATATYPE.Real_UploadECG) {

            endECGMeasurementTime = getUTCDate(new Date()).getTime();
            if (startECGMeasurementTime == 0) {
                startECGMeasurementTime = endECGMeasurementTime;
            }

            final ArrayList<Integer> ecgArrayList = (ArrayList<Integer>) dataMap.get("data");
            /*ArrayList newList = new ArrayList();
            for (int i = 0; i < ecgArrayList.size(); i++) {
                byte[] data = intToByteArray(ecgArrayList.get(i));
                newList.addAll(AITools.getInstance().ecgRealWaveFiltering(data));
            }
            Log.i(TAG, "onRealDataResponse: "+newList.toString());*/
            EcgInfoModel ecgInfoModel = new EcgInfoModel();
            ecgInfoModel.setApproxHr(hr[0]);
            ecgInfoModel.setApproxSBP(sbp[0]);
            ecgInfoModel.setApproxDBP(dbp[0]);
            ecgInfoModel.setHrv(hrv);
            ecgInfoModel.setPointList(ecgArrayList);
            ecgInfoModel.setStartTime(startECGMeasurementTime);
            ecgInfoModel.setEndTime(endECGMeasurementTime);
            ecgInfoModel.setPointList(ecgArrayList);
//                    ecgInfoModel.setPointList(newList);

            e66DataListener.onGetECGData(ecgInfoModel);
        } else if (dataType == com.yucheng.ycbtsdk.Constants.DATATYPE.Real_UploadECGHrv) {
            Log.i(TAG, "onRealDataResponse: Hrv : " + dataMap);
        } else if (dataType == com.yucheng.ycbtsdk.Constants.DATATYPE.AppECGPPGStatus) {
            Log.i(TAG, "onRealDataResponse: EcgPpgStatus : " + dataMap);

            if (dataMap.containsKey("EcgStatus")) {
                Integer ecg = (Integer) dataMap.get("EcgStatus");
                Integer ppg = (Integer) dataMap.get("PPGStatus");

                assert ecg != null;
                int ecg1 = Integer.parseInt(ecg.toString());
                assert ppg != null;
                int ppg1 = Integer.parseInt(ppg.toString());

                LeadStatusModel leadStatusModel = new LeadStatusModel();
                leadStatusModel.setEcgStatus(ecg1);
                leadStatusModel.setPpgStatus(ppg1);

                e66DataListener.onGetLeadStatus(leadStatusModel);
            }

        }
    }

    Date getUTCDate(Date myDate) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeZone(TimeZone.getTimeZone("UTC"));
        calendar.setTime(myDate);
        return calendar.getTime();
    }

    byte[] intToByteArray(int a) {
        byte[] ret = new byte[4];
        ret[3] = (byte) (a & 0xFF);
        ret[2] = (byte) ((a >> 8) & 0xFF);
        ret[1] = (byte) ((a >> 16) & 0xFF);
        ret[0] = (byte) ((a >> 24) & 0xFF);
        return ret;
    }

    public static List<byte[]> divideArray(byte[] source, int chunksize) {

        List<byte[]> result = new ArrayList<byte[]>();
        int start = 0;
        while (start < source.length) {
            int end = Math.min(source.length, start + chunksize);
            result.add(Arrays.copyOfRange(source, start, end));
            start += chunksize;
        }

        return result;
    }

    public void getRealTemp() {
        YCBTClient.appTemperatureMeasure(0x01, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: temp appTemperatureMeasure " + hashMap);
            }
        });

        YCBTClient.getRealTemp(new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: temp " + hashMap);
                if (i == 0) {
                    String temp = (String) hashMap.get("tempValue");

                    e66DataListener.onGetRealTemp(Double.parseDouble(temp != null ? temp : "0.0"));
                    if (BuildConfig.DEBUG) {
                        Log.i(TAG, "onDataResponse: temp value" + temp);
                    }
                }
            }
        });
    }
    public void monitoringTemprature(){

        YCBTClient.settingTemperatureMonitor(true, 1, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: "+hashMap);
            }
        });
    }
    public void getRealBloodOxygen() {
        YCBTClient.getRealBloodOxygen(new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                try {
                    Log.i(TAG, "onDataResponse: Oxygen " + hashMap);
                    if (i == 0) {
                        if (hashMap != null && hashMap.containsKey("bloodOxygenIsTest") && hashMap.get("bloodOxygenIsTest") != null) {
                            int bloodOxygenIsTest = (int) hashMap.get("bloodOxygenIsTest");//0x00: 未测心氧 0x01: 正在测试心氧

                            Log.i(TAG, "bloodOxygenIsTest: " + bloodOxygenIsTest);
                        }
                        if (hashMap != null && hashMap.containsKey("bloodOxygenValue") && hashMap.get("bloodOxygenValue") != null) {
                            int bloodOxygenValue = (int) hashMap.get("bloodOxygenValue");//血氧值 0-100
                            android.util.Log.i(TAG, " bloodOxygenValue: " + bloodOxygenValue);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public void stopMeasurement() {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.closeMeasurement();
            }
        }
        if (sdkType == Constants.e66) {
            Log.i(TAG, "appEcgTestEnd: start ");
            YCBTClient.appEcgTestEnd(new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    e66DataListener.onResponseEnd(i == 0);
                    Log.i(TAG, "onRealDataResponse: IsMeasurement stop2 " + (i == 0));
                    //region HRV

                    /*HRVNormBean bean = AITools.getInstance().getHrvNorm();
                    if (bean != null && bean.flag > -1)  {
                        float heavy_load = bean.heavy_load;//负荷指数 （越大越不好 传出）
                        float pressure = bean.pressure;//压力指数 （越大越不好 传出）
                        float HRV_norm = bean.HRV_norm;//HRV指数 （越大越好 传出）
                        float body = bean.body;//身体指数 （越大越好 传出）
                        Log.i(TAG, "onRealDataResponse: HRV "+HRV_norm);
                    }
                    try {
                        AITools.getInstance().getAIDiagnosisResult(new BleAIDiagnosisResponse() {
                            @Override
                            public void onAIDiagnosisResponse(AIDataBean aiDataBean) {
                                if (aiDataBean != null) {
                                    short heart = aiDataBean.heart;//心率
                                    int qrstype = aiDataBean.qrstype;//类型 1正常心拍 5室早心拍 9房早心拍  14噪声
                                    boolean is_atrial_fibrillation = aiDataBean.is_atrial_fibrillation;//是否心房颤动
                                    System.out.println("chong : HRV ------heart==" + heart + "--qrstype==" + qrstype + "--is_atrial_fibrillation==" + is_atrial_fibrillation);
                                }
                            }
                        });
                    } catch (Exception e) {
                        e.printStackTrace();
                    }*/
                    //endregion
                }
            });
        }
        if (sdkType == Constants.hBand) {
            hBandkSdk.stopDetectECG(new IBleWriteResponse() {
                @Override
                public void onResponse(int i) {
                    e66DataListener.onResponseEnd(i == 0);

                }
            }, false, new IECGDetectListener() {
                @Override
                public void onEcgDetectInfoChange(EcgDetectInfo ecgDetectInfo) {

                }

                @Override
                public void onEcgDetectStateChange(EcgDetectState ecgDetectState) {

                }

                @Override
                public void onEcgDetectResultChange(EcgDetectResult ecgDetectResult) {

                }

                @Override
                public void onEcgADCChange(int[] ints) {

                }
            });
        }
    }

    @Override
    public void onScan(BleDeviceWrapper bleDeviceWrapper) {
        if (requestedDeviceToConnect != null && requestedDeviceToConnect.getDeviceAddress() != null && bleDeviceWrapper != null && bleDeviceWrapper.getDeviceAddress() != null && bleDeviceWrapper.getDeviceAddress().equals(requestedDeviceToConnect.getDeviceAddress())) {
            try {
                Log.i(TAG, "onScan: mBleService.getBleConnectState(); " + mBleService.getBleConnectState());
                if (mBleService == null) {
                    mBleService = ZhbraceletApplication.getZhBraceletService();
                    mBleService.addConnectorListener(connectorListener);
                    mBleService.addSimplePerformerListenerLis(simplePerformerListener);
                }
                mBleService.UnBindDevice();
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(context, "mBleService", Toast.LENGTH_SHORT).show();
                        mBleService.BindDevice(bleDeviceWrapper);
                        mBleService.tryConnectDevice();
                        new PrefUtils(context).setString(Constants.connectedDeviceAddress, bleDeviceWrapper.getDeviceAddress());
                        new PrefUtils(context).setInt(Constants.connectedDeviceSDKType, requestedDeviceToConnect.getSdkType());
                    }
                }, 100);

            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            try {
                if (bleDeviceWrapper != null) {
                    bleDeviceWrapperArrayList.add(bleDeviceWrapper);
                    DeviceModel model = new DeviceModel();
                    model.setDeviceName(bleDeviceWrapper.getDeviceName());
                    model.setDeviceAddress(bleDeviceWrapper.getDeviceAddress());
                    model.setDeviceRange(String.valueOf(bleDeviceWrapper.getDeviceRssi()));
                    model.setWeightScaleDevice(false);
                    model.setSdkType(Constants.zhBle);
                    deviceScanListener.onScanDevice(model);

                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void service_call() {
        try {
            Intent alarm = new Intent(context, AlarmReceiver.class);
//            if(e66DataListener != null) {
//                alarm.putExtra("interface", e66DataListener);
//            }
            int flags = PendingIntent.FLAG_NO_CREATE;
            if (Build.VERSION.SDK_INT >= 31) {
                flags |= PendingIntent.FLAG_IMMUTABLE;
            }
            boolean alarmRunning = (PendingIntent.getBroadcast(context, 0, alarm, flags) != null);
            if (!alarmRunning) {
                int flags1 = 0;
                if (Build.VERSION.SDK_INT >= 31) {
                    flags1 |= PendingIntent.FLAG_IMMUTABLE;
                }
                PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, alarm, flags1);
                AlarmManager alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
                alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, 1500, pendingIntent);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setCalibration(int hr, int sbp, int dbp) {
//        if (mBleService != null) {
//            mBleService.setUserCalibration(new UserCalibration(hr, sbp, dbp));
//        }
        try {
            YCBTClient.appBloodCalibration(sbp, dbp, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "setCelebration: " + hashMap);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setCelebrationInE66(int type) {
        try {
            YCBTClient.settingBloodRange(type, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "setCelebrationInE66: " + hashMap);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setLiftBrighten(boolean isOn) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.setTaiWan(isOn);
            }

        }
        if (sdkType == Constants.e66) {
            int setOn = 0X00;
            if (isOn) {
                setOn = 0x01;
            }
            YCBTClient.settingRaiseScreen(setOn, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "settingRaiseScreen: " + hashMap);
                }
            });
        }
    }

    public void setDoNotDisturb(boolean isOn) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.setNotDisturb(isOn);
            }
        }
        if (sdkType == Constants.e66) {
            int doNotDisturb = 0x00;
            if (isOn) {
                doNotDisturb = 0x01;
            }
            YCBTClient.settingNotDisturb(doNotDisturb, 0, 0, 24, 0, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "settingRaiseScreen: " + hashMap);
                }
            });
        }
    }

    public void setTimeFormat(boolean isOn) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.setTimeFormat(isOn);
            }
        }
        if (sdkType == Constants.e66) {
            int timeFormat = 0x00;
            int distanceType = 0x00;
            if (!isOn) {
                timeFormat = 0x01;
                distanceType = 0x01;
            }

            YCBTClient.settingUnit(distanceType, 0x00, 0x00, timeFormat, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "settingUnit: " + hashMap);
                }
            });
        }
    }

    public void setHourlyHrMonitorOn(boolean isOn, int interval) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.setPoHeart(isOn);
            }
        }
        if (sdkType == Constants.e66) {
            int setOn = 0x01;
            if (!isOn) {
                setOn = 0x00;
            }
            YCBTClient.settingHeartMonitor(setOn, interval, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "settingHeartMonitor: " + hashMap);
                    if(hashMap!=null){

                        if (hashMap.containsKey("data")) {
                            ArrayList list = (ArrayList) hashMap.get("data");
                            e66DataListener.onGetHeartRateData(list);
                        }
                    }
                }
            });
        }
    }

    public void getHeartRateData() {
        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x0509, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "getHeartRateData: " + hashMap);
                    if (hashMap != null) {
                        Log.i(TAG, "getHeartRateData: " + hashMap);
                        ArrayList<HashMap> lists = (ArrayList<HashMap>) hashMap.get("data");

                        for (HashMap map : lists) {
                            int tempIntValue = (int) map.get("tempIntValue");//Temp int value
                            int tempFloatValue = (int) map.get("tempFloatValue");//Temp float value. if (tempFloatValue == 15) the result is error
                            int blood_oxygen = (int) map.get("OOValue");//Blood oxygen  if (blood_oxygen == 0)  no value
                            int hrv = (int) map.get("hrvValue");//hrv   if (hrv == 0)  no value
                            int cvrr = (int) map.get("cvrrValue");//cvrr   if (cvrr == 0)  no value
                            int respiratoryRateValue = (int) map.get("respiratoryRateValue");//Respiratory Rate  if (respiratoryRateValue == 0)  no value
                            long startTime = (long) map.get("startTime");
                            if (tempFloatValue != 15) {
                                double temp = Double.parseDouble(tempIntValue + "." + tempFloatValue);
                            }
                            String time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(startTime));
                        }
                    }
                }
            });
        }
    }

    public void setWearType(boolean isWearOnLeft) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.setWearType(isWearOnLeft);
            }
        }
        if (sdkType == Constants.e66) {
            int wearType = 0x00;
            if (isWearOnLeft) {
                wearType = 0x01;
            }
            YCBTClient.settingHandWear(wearType, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "settingHandWear: " + hashMap);
                }
            });
        }
    }

    public void setUserInformation(HashMap hashMap) {

        UserInfo userInfo = new UserInfo();
        if (hashMap.get("Height") != null) {
            int height = (Integer) hashMap.get("Height");
            userInfo.setUserHeight(height);
        }
        if (hashMap.get("Weight") != null) {
            int weight = (Integer) hashMap.get("Weight");
            userInfo.setUserWeight(weight);
        }
        if (hashMap.get("Age") != null) {
            int age = (Integer) hashMap.get("Age");
            userInfo.setAge(age);
        }
        if (hashMap.get("Gender") != null) {
            boolean gender = (boolean) hashMap.get("Gender");
            userInfo.setSex(gender);
        }

        int sex = 0;
        if (!userInfo.getSex()) {
            sex = 1;
        }

        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                if (mBleService != null) {
                    mBleService.setUserInfo(userInfo);
                }


            }
        } else {
            try {
                YCBTClient.settingUserInfo(userInfo.getUserHeight(), userInfo.getUserWeight(), sex, userInfo.getAge(), new BleDataResponse() {
                    @Override
                    public void onDataResponse(int i, float v, HashMap hashMap) {
                        Log.e(TAG, "onDataResponse: settingUserInfo " + hashMap);
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void openNotificationScreen(Context context) {
        if (!ZhBraceletUtils.isEnabled(context)) {
            openNoticeDialog();
        }
    }

    private void openNoticeDialog() {
       /* Intent intent = new Intent();
        intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");

        //for Android 5-7
        if(BuildConfig.VERSION_CODE < 26) {
            intent.putExtra("app_package", context.getPackageName());
            intent.putExtra("app_uid", context.getApplicationInfo().uid);
        }else {
        // for Android 8 and above
            intent.putExtra("android.provider.extra.APP_PACKAGE", context.getPackageName());
        }
        context.startActivity(intent);*/
        openNotificationAccess(context);
        /*new AlertDialog.Builder(context)
                .setTitle("Turn on notifications")

                .setMessage("Request to open the APP Notification Service")

                .setPositiveButton("determine", new DialogInterface.OnClickListener() {//添加确定按钮

                    public void onClick(DialogInterface dialog, int which) {

                        openNotificationAccess(context);

                    }

                }).setNegativeButton("cancel", new DialogInterface.OnClickListener() {//添加返回按钮


            @Override

            public void onClick(DialogInterface dialog, int which) {


            }

        }).show();*/
    }

    //region set app reminders
    public void setCallEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_call(isEnable);
        }
    }

    public void setMessageEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_sms(isEnable);
        }
    }

    public void setQqEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_qq(isEnable);
        }
    }

    public void setWeChatEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_wx(isEnable);
        }
    }

    public void setLinkedInEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_linkedin(isEnable);
        }
    }

    public void setSkypeEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_skype(isEnable);
        }
    }

    public void setFacebookMessengerEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_facebook(isEnable);
        }
    }

    public void setTwitterEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_twitter(isEnable);
        }
    }

    public void setWhatsAppEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_whatsapp(isEnable);
        }
    }

    public void setViberEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_viber(isEnable);
        }

    }

    public void setLineEnable(boolean isEnable) {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            mNotificationSetting.set_line(isEnable);
        }

    }
    //endregion

    //region get app reminders
    public boolean getCallEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_call();
        }
        return false;
    }

    public boolean getMessageEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_sms();
        }
        return false;
    }

    public boolean getQqEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_qq();
        }
        return false;
    }

    public boolean getWeChatEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_wx();
        }
        return false;
    }

    public boolean getLinkedInEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_linkedin();
        }
        return false;
    }

    public boolean getSkypeEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_skype();
        }
        return false;
    }

    public boolean getFacebookMessengerEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_facebook();
        }
        return false;
    }

    public boolean getTwitterEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_twitter();
        }
        return false;
    }

    public boolean getWhatsAppEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_whatsapp();
        }
        return false;
    }

    public boolean getViberEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_viber();
        }
        return false;
    }

    public boolean getLineEnable() {
        if (mNotificationSetting == null) {
            mNotificationSetting = ZhbraceletApplication.getNotificationSetting();
        } else {
            return mNotificationSetting.get_line();
        }
        return false;
    }
    //endregion

    public void setWaterReminder(int startHour, int startMinute, int endHour, int endMinute, int interval, boolean isEnable) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mDrinkInfo = mBleService.getDrinkInfo();
                mDrinkInfo.setDrinkStartHour(startHour);
                mDrinkInfo.setDrinkStartMin(startMinute);
                mDrinkInfo.setDrinkEndHour(endHour);
                mDrinkInfo.setDrinkEndMin(endMinute);
                mDrinkInfo.setDrinkEnable(isEnable);
                mDrinkInfo.setDrinkPeriod(interval);
                mBleService.setDrinkInfo(mDrinkInfo);
            }
        }
        if (sdkType == Constants.e66) {
            setWaterReminderInE66(startHour, startMinute, endHour, endMinute, interval, isEnable);
        }
    }

    void setWaterReminderInE66(int startHour, int startMinute, int endHour, int endMinute, int interval, boolean isEnable) {
        YCBTClient.settingAddAlarm(0x07, startHour, startMinute, 11111111, (interval * 60), new BleDataResponse() {
            @Override
            public void onDataResponse(int code, float ratio, HashMap resultMap) {
                Log.i(TAG, "set water reminder: " + resultMap);
            }
        });
    }

    public HashMap<String, Object> getWaterReminder() {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mDrinkInfo = new DrinkInfo();
                HashMap<String, Object> hashMap = new HashMap<>();
                hashMap.put("startHour", mDrinkInfo.getDrinkStartHour());
                hashMap.put("startMinute", mDrinkInfo.getDrinkStartMin());
                hashMap.put("endHour", mDrinkInfo.getDrinkEndHour());
                hashMap.put("endMinute", mDrinkInfo.getDrinkEndMin());
                hashMap.put("interval", mDrinkInfo.getDrinkPeriod());
                hashMap.put("isEnable", mDrinkInfo.getDrinkEnable());
                return hashMap;
            }
        }
        return null;
    }

    public void setMedicalReminder(int startHour, int startMinute, int endHour, int endMinute, int interval, boolean isEnable) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mMedicalInfo = new MedicalInfo();
                mMedicalInfo.setMedicalStartHour(startHour);
                mMedicalInfo.setMedicalStartMin(startMinute);
                mMedicalInfo.setMedicalEndHour(endHour);
                mMedicalInfo.setMedicalEndMin(endMinute);
                mMedicalInfo.setMedicalEnable(isEnable);
                mMedicalInfo.setMedicalPeriod(interval);
                mBleService.setMedicalInfo(mMedicalInfo);
            }
        }
    }

    public HashMap<String, Object> getMedicalReminder() {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mMedicalInfo = mBleService.getMedicalInfo();
                HashMap<String, Object> hashMap = new HashMap<>();
                hashMap.put("startHour", mMedicalInfo.getMedicalStartHour());
                hashMap.put("startMinute", mMedicalInfo.getMedicalStartMin());
                hashMap.put("endHour", mMedicalInfo.getMedicalEndHour());
                hashMap.put("endMinute", mMedicalInfo.getMedicalEndMin());
                hashMap.put("interval", mMedicalInfo.getMedicalPeriod());
                hashMap.put("isEnable", mMedicalInfo.getMedicalEnable());
                return hashMap;
            }
        }
        return null;
    }

    public void setSitReminder(int startHour, int startMinute, int endHour, int endMinute, int interval, boolean isEnable, int secondStartTime, int secondStartMinute, int secondEndHour, int secondEndMinute) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mSitInfo = new SitInfo();
                mSitInfo.setSitStartHour(startHour);
                mSitInfo.setSitStartMin(startMinute);
                mSitInfo.setSitEndHour(endHour);
                mSitInfo.setSitEndMin(endMinute);
                mSitInfo.setSitEnable(isEnable);
                mSitInfo.setSitPeriod(interval);
                mBleService.setSitInfo(mSitInfo);
            }
        }
        if (sdkType == Constants.e66) {
            StringBuilder week = new StringBuilder("11111111");
            if (!isEnable) {
                week.setCharAt(0, '0');
            }
            try {
                YCBTClient.settingLongsite(startHour, startMinute, endHour, endMinute, secondStartTime, secondStartMinute, secondEndHour, secondEndMinute, 15, 0xFF, new BleDataResponse() {
                    @Override
                    public void onDataResponse(int i, float v, HashMap hashMap) {
                        Log.i(TAG, "settingLongsite: " + hashMap);
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public HashMap<String, Object> getSitReminder() {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mSitInfo = mBleService.getSitInfo();
                HashMap<String, Object> hashMap = new HashMap<>();
                hashMap.put("startHour", mSitInfo.getSitStartHour());
                hashMap.put("startMinute", mSitInfo.getSitStartMin());
                hashMap.put("endHour", mSitInfo.getSitEndHour());
                hashMap.put("endMinute", mSitInfo.getSitEndMin());
                hashMap.put("interval", mSitInfo.getSitPeriod());
                hashMap.put("isEnable", mSitInfo.getSitEnable());
                return hashMap;
            }
        }
        return null;
    }

    public void addAlarm(AlarmModel model) {

        /*int position = -1;
        for (int i = 0; i < alarmInfoArrayList.size(); i++) {
            AlarmInfo info = alarmInfoArrayList.get(i);
            if (info.getAlarmId() == model.getId()) {
                position = i;
            }
        }*/

        /*if (position < 0) {
            AlarmInfo alarmInfo = new AlarmInfo(model.getId(), model.getHour(), model.getMinute(), getCheck(model.isEnable(), model.getDays()));
            if (mBleService != null) {
                alarmInfoArrayList = mBleService.addAlarmData(alarmInfoArrayList, alarmInfo);
                mBleService.saveAlarmData(alarmInfoArrayList);
            }
        }else{
            AlarmInfo alarmInfo = alarmInfoArrayList.get(position);
            if (mBleService != null) {
                alarmInfoArrayList = mBleService.updateAlarmData(alarmInfoArrayList, alarmInfo,position);
                mBleService.saveAlarmData(alarmInfoArrayList);
            }
        }*/
        if (prefUtils == null) {
            prefUtils = new PrefUtils(context);
        }
        ArrayList<String> stringList = new ArrayList<>();
        String combineStrings = "";

        try {
            String value = prefUtils.getString(Constants.PREF_ALARM_IDS);
            if (value != null && !value.isEmpty()) {
                stringList = new ArrayList<String>(Arrays.asList(value.split(",")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (model.isEnable()) {
            if (!stringList.contains(String.valueOf(model.getId()))) {
                stringList.add(String.valueOf(model.getId()));
            }
            addAlarmManager(model);
        } else {
            stringList.remove(String.valueOf(model.getId()));
        }
        for (int j = 0; j < stringList.size(); j++) {
            combineStrings = combineStrings + stringList.get(j) + ",";
        }
        prefUtils.setString(Constants.PREF_ALARM_IDS, combineStrings);
    }

    private void addAlarmManager(AlarmModel model) {
        Intent i = new Intent(context, MyBroadcastReceiver.class);
        i.putStringArrayListExtra("map", model.getDaysString());
        i.putExtra("id", String.valueOf(model.getId()));
        i.putExtra("endHour", model.getEndHour());
        i.putExtra("endMinute", model.getEndMinute());
        int flags = 0;
        if (Build.VERSION.SDK_INT >= 31) {
            flags |= PendingIntent.FLAG_IMMUTABLE;
        }
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, model.getId(), i, flags);
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, model.getStartHour());
        calendar.set(Calendar.MINUTE, model.getStartMinute());
        calendar.set(Calendar.SECOND, 0);
        Log.i("TAG", " addAlarm: " + model.getStartHour() + " : " + model.getStartMinute() + "");
        alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), model.getInterval(), pendingIntent);


    }

    //note: this method was use to set alarm in device but cause of it was not work as expected we haven't use.
    // but the ios sdk calls working with sdk.
    public void addSdkAlarm(AlarmModel model) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                if (mBleService != null) {
                    alarmInfoArrayList = mBleService.getAlarmData();
                }
                int position = -1;
                for (int i = 0; i < alarmInfoArrayList.size(); i++) {
                    AlarmInfo info = alarmInfoArrayList.get(i);
                    if (info.getAlarmId() == model.getId()) {
                        position = i;
                    }
                }

                if (position < 0) {
                    AlarmInfo alarmInfo = new AlarmInfo(model.getId(), model.getStartHour(), model.getStartMinute(), getCheck(model.isEnable(), model.getDays()));
                    if (mBleService != null) {
                        alarmInfoArrayList = mBleService.addAlarmData(alarmInfoArrayList, alarmInfo);
                        mBleService.saveAlarmData(alarmInfoArrayList);
                    }
                } else {
                    AlarmInfo alarmInfo = alarmInfoArrayList.get(position);
                    if (mBleService != null) {
                        alarmInfoArrayList = mBleService.updateAlarmData(alarmInfoArrayList, alarmInfo, position);
                        mBleService.saveAlarmData(alarmInfoArrayList);
                    }
                }
            }
        }
        if (sdkType == Constants.e66) {
            StringBuilder days = new StringBuilder("00000000");
            if (model.isEnable()) {
                days.setCharAt(0, '1');
            } else {
                days.setCharAt(0, '0');
            }
            for (int i = 0; i < model.getDays().size(); i++) {
                int day = model.getDays().get(i);
                switch (day) {
                    case 1:
                        days.setCharAt(1, '1');
                        break;
                    case 2:
                        days.setCharAt(7, '1');
                        break;
                    case 3:
                        days.setCharAt(6, '1');
                        break;
                    case 4:
                        days.setCharAt(5, '1');
                        break;
                    case 5:
                        days.setCharAt(4, '1');
                        break;
                    case 6:
                        days.setCharAt(3, '1');
                        break;
                    case 7:
                        days.setCharAt(2, '1');
                        break;
                }
            }
            YCBTClient.settingAddAlarm(0x07, model.getStartHour(), model.getEndMinute(), Integer.parseInt(days.toString()), 0, new BleDataResponse() {
                @Override
                public void onDataResponse(int code, float ratio, HashMap resultMap) {
                    Log.i(TAG, "set alarm: " + resultMap);
                }
            });
        }
    }

    public void updateSdkAlarm(AlarmModel model) {

        if (sdkType == Constants.zhBle) {
            try {
                if (mBleService != null) {
                    if (mBleService != null) {
                        alarmInfoArrayList = mBleService.getAlarmData();
                    }
                    int position = -1;
                    for (int i = 0; i < alarmInfoArrayList.size(); i++) {
                        AlarmInfo info = alarmInfoArrayList.get(i);
                        if (info.getAlarmId() == model.getId()) {
                            position = i;
                        }
                    }

                    if (position > -1) {
                        AlarmInfo alarmInfo = alarmInfoArrayList.get(position);
                        if (mBleService != null) {
                            alarmInfoArrayList = mBleService.updateAlarmData(alarmInfoArrayList, alarmInfo, position);
                            mBleService.saveAlarmData(alarmInfoArrayList);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (sdkType == Constants.e66) {

            StringBuilder days = new StringBuilder("00000000");
            if (model.isEnable()) {
                days.setCharAt(0, '1');
            } else {
                days.setCharAt(0, '0');
            }
            for (int i = 0; i < model.getDays().size(); i++) {
                int day = model.getDays().get(i);
                switch (day) {
                    case 1:
                        days.setCharAt(1, '1');
                        break;
                    case 2:
                        days.setCharAt(7, '1');
                        break;
                    case 3:
                        days.setCharAt(6, '1');
                        break;
                    case 4:
                        days.setCharAt(5, '1');
                        break;
                    case 5:
                        days.setCharAt(4, '1');
                        break;
                    case 6:
                        days.setCharAt(3, '1');
                        break;
                    case 7:
                        days.setCharAt(2, '1');
                        break;
                }
            }
            YCBTClient.settingModfiyAlarm(model.getPreviousStartHour(), model.getPreviousStartMinute(), 0x07, model.getStartHour(), model.getEndHour(), Integer.parseInt(days.toString()), 0, new BleDataResponse() {
                @Override
                public void onDataResponse(int code, float ratio, HashMap resultMap) {
                    Log.i(TAG, "set alarm: " + resultMap);
                }
            });
        }
    }


    public void getSDKAlarm() {
        if (sdkType == Constants.e66) {
            YCBTClient.settingGetAllAlarm(new BleDataResponse() {
                @Override
                public void onDataResponse(int code, float ratio, HashMap resultMap) {
                    try {
                        if (resultMap != null) {
                            ArrayList<HashMap<String, Object>> keyAlarmData = new ArrayList<HashMap<String, Object>>();
                            int keyOptType = (int) resultMap.get("optType");
                            int keyAlarmNum = (int) resultMap.get("tSettedAlarmNum");
                            int keyMaxLimitNum = (int) resultMap.get("tSupportAlarmNum");

                            ArrayList tData = (ArrayList) resultMap.get("data");
                            for (int i = 0; i < tData.size(); i++) {
                                HashMap tAlarm = (HashMap) tData.get(i);
                                int type = (int) tAlarm.get("alarmType");
                                int hour = (int) tAlarm.get("alarmHour");
                                int min = (int) tAlarm.get("alarmMin");
                                int repeat = (int) tAlarm.get("alarmRepeat");
                                int delay = (int) tAlarm.get("alarmDelayTime");
                                E80AlarmModel model = new E80AlarmModel();
                                model.setType(type);
                                model.setHour(hour);
                                model.setMinute(min);
                                model.setRepeatBits(repeat);
                                model.setDelayTime(delay);
                                keyAlarmData.add(model.toMapForList());
                            }
                            HashMap<String, java.io.Serializable> map = new HashMap<>();
                            map.put("keyOptType", keyOptType);
                            map.put("keyAlarmNum", keyAlarmNum);
                            map.put("keyMaxLimitNum", keyMaxLimitNum);
                            map.put("keyAlarmData", keyAlarmData);
                            e66DataListener.onGetAlarmList(map);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        }

        if (sdkType == Constants.hBand) {
            List<Alarm2Setting> list = hBandkSdk.getAlarm2List();
            ArrayList<HashMap<String, Object>> keyAlarmData = new ArrayList<HashMap<String, Object>>();

            for (int i = 0; i < list.size(); i++) {
                Alarm2Setting tAlarm = list.get(i);
                int type = tAlarm.alarmId;
                int hour = tAlarm.alarmHour;
                int min = tAlarm.getAlarmMinute();
                int repeat = tAlarm.getRepeatIntStatus();
                E80AlarmModel model = new E80AlarmModel();
                model.setType(type);
                model.setHour(hour);
                model.setMinute(min);
                model.setRepeatBits(repeat);

                keyAlarmData.add(model.toMapForList());
            }
            HashMap<String, java.io.Serializable> map = new HashMap<>();
            map.put("keyAlarmData", keyAlarmData);
            e66DataListener.onGetAlarmList(map);
        }
    }

    private int getCheck(boolean isEnable, ArrayList<Integer> days) {
        if (sdkType == Constants.zhBle) {
            boolean[] my_data = new boolean[8];
            my_data[0] = isEnable;
            my_data[1] = days.contains(2);//m
            my_data[2] = days.contains(3);//t
            my_data[3] = days.contains(4);//w
            my_data[4] = days.contains(5);//t
            my_data[5] = days.contains(6);//f
            my_data[6] = days.contains(7);//s
            my_data[7] = days.contains(1);//s
            if (mBleService != null) {
                return mBleService.getCheckInt(my_data);
            }
        }
        return 0;
    }

    public void setStepTarget(int steps) {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                mBleService.setSportTarget(steps);
            }
        }
        if (sdkType == Constants.e66) {
            YCBTClient.settingGoal(0x00, steps, 0x00, 0x00, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: setStepTarget " + hashMap);
                }
            });
        }
    }

    public void setDistanceTarget(int distanceTarget) {
        if (sdkType == Constants.e66) {
            YCBTClient.settingGoal(0x01, distanceTarget, 0x00, 0x00, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: setStepTarget " + hashMap);
                }
            });
        }
    }

    public void setCaloriesTarget(int caloriesTarget) {
        if (sdkType == Constants.e66) {
            YCBTClient.settingGoal(0x02, caloriesTarget, 0x00, 0x00, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: setStepTarget " + hashMap);
                }
            });
        }
    }
   public void getStepData() {
        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x0502, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: setStepTarget " + hashMap);
                }
            });
        }
    }

    public void setSkinType(int skinColor) {
        if (sdkType == Constants.e66) {
            int color = 0X00;
            switch (skinColor) {
                case 0:
                    color = 0x00;
                    break;
                case 1:
                    color = 0x01;
                    break;
                case 2:
                    color = 0x02;
                    break;
                case 3:
                    color = 0x03;
                    break;
                case 4:
                    color = 0x05;
                    break;
            }
            YCBTClient.settingSkin(color, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: setSkinType " + hashMap);
                }
            });
        }
    }

    public void setBrightness(int brightness) {
        if (sdkType == Constants.e66) {
            int color = 0X00;
            switch (brightness) {
                case 0:
                    brightness = 0x00;
                    break;
                case 1:
                    brightness = 0x01;
                    break;
                case 2:
                    brightness = 0x02;
                    break;
            }
            YCBTClient.settingDisplayBrightness(brightness, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "settingDisplayBrightness: " + hashMap);
                }
            });
        }
    }

    public void setSleepTarget(int hour, int minutes) {
        if (sdkType == Constants.e66) {
            YCBTClient.settingGoal(0x03, 0x00, hour, minutes, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: setSleepTarget " + hashMap);
                }
            });
        }
    }

    public int getStepTarget() {
        if (sdkType == Constants.zhBle) {
            if (mBleService != null) {
                return mBleService.getSportTarget();
            }
        }
        return 8000;
    }

    public void setSleepTarget(int steps) {
        if (mBleService != null) {
            mBleService.setSportTarget(steps);
        }
    }

    public int getSleepTarget() {
        if (mBleService != null) {
            return mBleService.getSportTarget();
        }
        return 8000;
    }

    private void startScanInE66() {
        try {
            YCBTClient.startScanBle(new BleScanResponse() {
                @Override
                public void onScanResponse(int i, ScanDeviceBean scanDeviceBean) {
                    if (scanDeviceBean != null) {
                        DeviceModel deviceModel = new DeviceModel();
                        deviceModel.setDeviceAddress(scanDeviceBean.getDeviceMac());
                        deviceModel.setDeviceRange("" + scanDeviceBean.getDeviceRssi());
                        deviceModel.setDeviceName(scanDeviceBean.getDeviceName());
                        deviceModel.setSdkType(Constants.e66);
                        deviceModel.setSdk("production");
                        deviceScanListener.onScanDevice(deviceModel);
                        Log.e("device", "mac=" + scanDeviceBean.getDeviceMac() + ";name=" + scanDeviceBean.getDeviceName() + "rssi=" + scanDeviceBean.getDeviceRssi() + "type=" + deviceModel.getSdk());
                    }
                }
            }, 10);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void newSDkScanInE66() {
        try {
            hBandkSdk.startScanDevice(new SearchResponse() {
                @Override
                public void onSearchStarted() {

                }

                @Override
                public void onDeviceFounded(SearchResult searchResult) {
                    if (searchResult != null) {

                        DeviceModel deviceModel = new DeviceModel();
                        deviceModel.setDeviceAddress(searchResult.getAddress());
                        deviceModel.setDeviceRange("" + searchResult.rssi);
                        deviceModel.setDeviceName(searchResult.getName());
                        deviceModel.setSdkType(Constants.hBand);
                        deviceModel.setSdk("hBand");
                        Log.e("device", "mac=" + deviceModel.getDeviceAddress() + ";name=" + deviceModel.getDeviceName() + "rssi=" + deviceModel.getDeviceRange() + "type=" + deviceModel.getSdk());

                        deviceScanListener.onScanDevice(deviceModel);

                    }
                }

                @Override
                public void onSearchStopped() {

                }

                @Override
                public void onSearchCanceled() {

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public void sendMessage(HashMap map) {
        try {
            String packageName = String.valueOf(map.get("packageName"));
            String title = String.valueOf(map.get("title"));
            String content = String.valueOf(map.get("content"));

            int app = 0x01;

            if (packageName.toLowerCase().contains("whatsapp")) {
                app = 0x0B;
            } else if (packageName.toLowerCase().contains("message") || packageName.toLowerCase().contains("sms")) {
                app = 0x02;
            }

            if (packageName.toLowerCase().contains("com.luutinhit.secureincomingcall")) {
                app = 0x00;
            }
            if (packageName.toLowerCase().contains("com.google.android.apps.messaging")) {
                app = 0x01;
            }
            if (packageName.toLowerCase().contains("com.google.android.gm")) {
                app = 0x02;
            }
            /*if (packageName.toLowerCase().contains("com.tencent.mobileqq")) {
                app = 0x04;
            }
            if (packageName.toLowerCase().contains("com.tencent.mm")) {
                app = 0x05;
            }
            if (packageName.toLowerCase().contains("com.sina.weibo")) {
                app = 0x06;
            }
            if (packageName.toLowerCase().contains("com.twitter.android")) {
                app = 0x07;
            }
            if (packageName.toLowerCase().contains("com.facebook.katana")) {
                app = 0x08;
            }
            if (packageName.toLowerCase().contains("com.facebook.orca")) {
                app = 0x09;
            }
            if (packageName.toLowerCase().contains("com.whatsapp")) {
                app = 0x0A;
            }
            if (packageName.toLowerCase().contains("com.linkedin.android")) {
                app = 0x0B;
            }
            if (packageName.toLowerCase().contains("com.instagram.android")) {
                app = 0x0C;
            }
            if (packageName.toLowerCase().contains("com.skype.raider")) {
                app = 0x0D;
            }
            if (packageName.toLowerCase().contains("jp.naver.line.android")) {
                app = 0x0E;
            }
            if (packageName.toLowerCase().contains("com.snapchat.android")) {
                app = 0x0F;
            }*/

            YCBTClient.appSengMessageToDevice(app, title, content, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    if (i == 0) {
                        //success sendMessage
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void getHeartRateHistory() {
        if (sdkType == Constants.e66) {
            YCBTClient.healthHistoryData(0x0506, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    ArrayList list =new ArrayList();
                    if(hashMap!=null){
                        if (hashMap.containsKey("data")) {
                            list = (ArrayList) hashMap.get("data");
                        }
                    }
                    e66DataListener.onGetHeartRateData(list);
                }
            });
        }
        if (sdkType == Constants.hBand) {
            hBandkSdk.readAllHealthData(new IAllHealthDataListener() {
                @Override
                public void onProgress(float v) {

                }

                @Override
                public void onSleepDataChange(String s, SleepData sleepData) {

                }

                @Override
                public void onReadSleepComplete() {

                }

                @Override
                public void onOringinFiveMinuteDataChange(OriginData originData) {

                }

                @Override
                public void onOringinHalfHourDataChange(OriginHalfHourData originHalfHourData) {

                }

                @Override
                public void onReadOriginComplete() {

                }
            }, 1);
        }
    }

    public void getDataForE66() {
        Log.i(TAG, "getDataForE66: ------------------------------------\n---------------------------\n----------------- " + sdkType);
        if (sdkType == Constants.e66) {
            Log.i(TAG, "getDataForE66_090909");
//            getRealTemp();
           /*
            YCBTClient.getDeviceUserConfig(new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: getDeviceUserConfig "+hashMap);
                }
            });*/

            //sport
            getSportDataFromE66();

            //sleep data
            getSleepDataFromE66();

            //temp
            getAllDataFromE66();

            //device info
            getDeviceInformation();

            //heart rate information
            getHeartRateHistory();

            //get all alarm
            getSDKAlarm();

            getTempDataFromE66();

            getOxygenDataFromE66();

            getBloodPressureData();
        }
    }

    public void getDataForHband() {
        Log.i(TAG, "getDataForHband: ------------------------------------\n---------------------------\n----------------- " + sdkType);
        if (sdkType == Constants.hBand) {
            //sport
            getSportDataFromE66();

            //sleep data
            getSleepDataFromE66();

            //temp
            getAllDataFromE66();

            //device info
            getDeviceInformation();

            //heart rate information
            getHeartRateHistory();

            //get all alarm
            getSDKAlarm();

            getTempDataFromE66();

            getOxygenDataFromE66();

            getBloodPressureData();
        }
    }

    public void getBloodPressureData() {
        if (sdkType == Constants.hBand) {

            return;
        }
        YCBTClient.healthHistoryData(0x0508, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                if (hashMap != null) {
                    ArrayList<HashMap> data = (ArrayList<HashMap>) hashMap.get("data");
                    e66DataListener.onResponseCollectBP(data);
                }
            }
        });
    }

    public void getEcgData() {

        YCBTClient.collectEcgList(new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                try {
                    Log.i(TAG, "onDataResponse: collectEcgFromList start ecg models");
                    JSONObject jsonObject = new JSONObject(hashMap);
                    JSONArray jsonArray = jsonObject.getJSONArray("data");
                    ArrayList<CollectECGModel> ecgData = new ArrayList<>();
                    for (int j = 0; j < jsonArray.length(); j++) {
                        CollectECGModel collectECGModel = new CollectECGModel();
                        JSONObject object = (JSONObject) jsonArray.get(i);


                        Number collectDigits = NumberFormat.getInstance().parse(object.get("collectDigits").toString());
                        Number collectType = NumberFormat.getInstance().parse(object.get("collectType").toString());
                        Number collectSN = NumberFormat.getInstance().parse(object.get("collectSN").toString());
                        Number collectTotalLen = NumberFormat.getInstance().parse(object.get("collectTotalLen").toString());
                        Number collectSendTime = NumberFormat.getInstance().parse(object.get("collectSendTime").toString());
                        Number collectStartTime = NumberFormat.getInstance().parse(object.get("collectStartTime").toString());
                        Number collectBlockNum = NumberFormat.getInstance().parse(object.get("collectBlockNum").toString());

                        collectECGModel.setCollectBlockNum(collectDigits);
                        collectECGModel.setCollectType(collectType);
                        collectECGModel.setCollectSN(collectSN);
                        collectECGModel.setCollectTotalLen(collectTotalLen);
                        collectECGModel.setCollectSendTime(collectSendTime);
                        collectECGModel.setCollectStartTime(collectStartTime);
                        collectECGModel.setCollectBlockNum(collectBlockNum);
                        ecgData.add(collectECGModel);
                    }
                    collectEcgFromList(ecgData);
                    Log.i(TAG, "onDataResponse: " + hashMap);
                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        });


    }

    public void collectEcgFromList(ArrayList<CollectECGModel> arrayList) {
        Log.i(TAG, "onDataResponse: collectEcgFromList start ecg ");
        if (arrayList.size() > 0) {
            int a = arrayList.size() - 1;
            CollectECGModel model = arrayList.get(a);
            YCBTClient.collectEcgDataWithIndex(a, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    try {
                        JSONObject jsonObject = new JSONObject(hashMap);
                        JSONArray array = jsonObject.getJSONArray("data");
                        ArrayList<Number> ecgData = new ArrayList<Number>();
                        for (int k = 0; k < array.length(); k++) {
                            Number point = NumberFormat.getInstance().parse(array.get(k).toString());
                            ecgData.add(point);
                        }
                        model.setEcgData(ecgData);
                        Log.i(TAG, "onDataResponse: collectEcgFromList end ecg");
                        e66DataListener.onResponseCollectECG(model);
                    } catch (JSONException | ParseException e) {
                        e.printStackTrace();
                    }
                }
            });
        }


    }

    public void setTemperatureMonitorOn(boolean isEnable, int interval) {
        YCBTClient.settingTemperatureMonitor(isEnable, interval, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: setTemperatureMonitorOn " + hashMap);
            }
        });
    }

    public void setOxygenMonitorOn(boolean isEnable, int interval) {
        Log.i(TAG, "setOxygenMonitorOn_1111  " + isEnable + " " + interval);
        YCBTClient.settingBloodOxygenModeMonitor(isEnable, interval, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: setOxygenMonitorOn" + hashMap);

            }
        });
    }

    public void setUnits(HashMap arguments) {
        try {
            int weightUnit = 0;
            int tempUnit = 0;
            int distanceUnit = 0;
            int timeUnit = 0;
            if (sdkType == Constants.e66) {
                weightUnit = (int) arguments.get("weightUnit");
                tempUnit = (int) arguments.get("tempUnit");
                distanceUnit = (int) arguments.get("distanceUnit");
                timeUnit = (int) arguments.get("timeUnit");
                if (timeUnit == 0) {
                    timeUnit = 1;
                } else {
                    timeUnit = 0;
                }
                YCBTClient.settingUnit(distanceUnit, weightUnit, tempUnit, timeUnit, new BleDataResponse() {
                    @Override
                    public void onDataResponse(int i, float v, HashMap hashMap) {
                        if (BuildConfig.DEBUG) {
                            Log.i(TAG, "onDataResponse: " + hashMap);
                        }
                    }
                });
            }
            if (sdkType == Constants.zhBle) {
                if (mBleService != null) {
                    mBleService.setTimeFormat(timeUnit == 1);
                }
            }
        } catch (Exception e) {
            if (BuildConfig.DEBUG) {
                e.printStackTrace();
            }
        }
    }


    public void addAlarmForE66(E80AlarmModel e80AlarmModel) {
        if (e80AlarmModel == null) {
            return;
        }
        if (e80AlarmModel.getOldHr() > -1 && e80AlarmModel.getOldMin() > -1) {
        /*    YCBTClient.settingDeleteAlarm(e80AlarmModel.getOldHr(), e80AlarmModel.getOldMin(), new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "settingDeleteAlarm: "+hashMap);
                }
            });*/
            updateAlarmForE66(e80AlarmModel);
        } else {
            YCBTClient.settingAddAlarm(e80AlarmModel.getType(), e80AlarmModel.getHour(), e80AlarmModel.getMinute(), e80AlarmModel.getRepeatBits(), e80AlarmModel.getDelayTime(), new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "onDataResponse: settingAddAlarm: " + hashMap);
                    e66DataListener.onAddAlarm(hashMap);
                }
            });
        }
    }

    public void updateAlarmForE66(E80AlarmModel e80AlarmModel) {
        YCBTClient.settingModfiyAlarm(e80AlarmModel.getOldHr(), e80AlarmModel.getOldMin(), e80AlarmModel.getType(), e80AlarmModel.getHour(), e80AlarmModel.getMinute(), e80AlarmModel.getRepeatBits(), e80AlarmModel.getDelayTime(), new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: modfiyAlarmForE66: " + hashMap);
                e66DataListener.onAddAlarm(hashMap);
            }
        });
    }

    public void deleteSDKAlarm(int hour, int minute) {
        YCBTClient.settingDeleteAlarm(hour, minute, new BleDataResponse() {
            @Override
            public void onDataResponse(int code, float ratio, HashMap hashMap) {
                Log.i(TAG, "settingDeleteAlarm: " + hashMap);
                e66DataListener.onAddAlarm(hashMap);
            }
        });
    }


    public void openRegisterRealStepData() {
        isRegistred = true;
        YCBTClient.appRegisterRealDataCallBack(new BleRealDataResponse() {
            @Override
            public void onRealDataResponse(int i, HashMap hashMap) {
                if (hashMap != null && hashMap.size() > 0) {
                    int sportStep = (int) hashMap.get("sportStep");
                    int sportDistance = (int) hashMap.get("sportDistance");
                    int sportCalorie = (int) hashMap.get("sportCalorie");
                    HashMap<String, Integer> map = new HashMap<>();
                    map.put("step", sportStep);
                    map.put("distance", sportDistance / 1000);
                    map.put("calories", sportCalorie);
                    e66DataListener.onResponseE80RealTimeMotionData(map);
                }
            }
        });
    }

    public void closeRegisterRealStepData() {
        isRegistred = false;
        YCBTClient.appRealSportFromDevice(0x00, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                if (hashMap != null && BuildConfig.DEBUG) {
                    Log.i(TAG, "closeRegisterRealStepData: " + hashMap.toString());
                }
            }
        });
    }

    public void startMode(int mode) {
        if (sdkType == Constants.e66) {
            YCBTClient.appRunModeStart(mode, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "appRunModeStart: " + hashMap);
                    e66DataListener.startModeSuccess();
                }
            }, new BleRealDataResponse() {
                @Override
                public void onRealDataResponse(int i, HashMap hashMap) {
                    Log.i(TAG, "onRealDataResponse: appRunModeStart: " + hashMap);
                    if (hashMap != null && hashMap.containsKey("heartValue")) {
                        e66DataListener.onGetHeartRateFromRunMode((Integer) hashMap.get("heartValue"));
                    }
                }
            });
        }
    }

    public void stopMode(int mode) {
        if (sdkType == Constants.e66) {
            YCBTClient.appRunModeEnd(mode, new BleDataResponse() {
                @Override
                public void onDataResponse(int i, float v, HashMap hashMap) {
                    Log.i(TAG, "appRunModeStart: " + hashMap);
                    e66DataListener.stopModeSuccess();
                }
            });
        }
    }

    public void reset() {
        YCBTClient.settingRestoreFactory(new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse reset : " + hashMap);
            }
        });
    }

    public void shutdown() {
        YCBTClient.appShutDown(0x01, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse shutdown : " + hashMap);
            }
        });
    }


    public void deleteSport() {
        YCBTClient.deleteHealthHistoryData(0x0540, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteSport = " + hashMap);
            }
        });
    }

    public void deleteSleep() {
        YCBTClient.deleteHealthHistoryData(0x0541, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteSleep = " + hashMap);
            }
        });
    }

    public void deleteHeartRate() {
        YCBTClient.deleteHealthHistoryData(0x0542, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteHeartRate = " + hashMap);
            }
        });
    }

    public void deleteBloodPressure() {
        YCBTClient.deleteHealthHistoryData(0x0543, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteBloodPressure = " + hashMap);
            }
        });
    }

    public void deleteTempAndOxygen() {
        YCBTClient.deleteHealthHistoryData(0x0544, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteTempAndOxygen = " + hashMap);
            }
        });
        YCBTClient.deleteHealthHistoryData(0x0545, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteTempAndOxygen = " + hashMap);
            }
        });
        YCBTClient.deleteHealthHistoryData(0x0546, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteTempAndOxygen = " + hashMap);
            }
        });
        YCBTClient.deleteHealthHistoryData(0x0547, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteTempAndOxygen = " + hashMap);
            }
        });
        YCBTClient.deleteHealthHistoryData(0x0548, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteTempAndOxygen = " + hashMap);
            }
        });
        YCBTClient.deleteHealthHistoryData(0x0549, new BleDataResponse() {
            @Override
            public void onDataResponse(int i, float v, HashMap hashMap) {
                Log.i(TAG, "onDataResponse: deleteTempAndOxygen = " + hashMap);
            }
        });
    }

    public void getAllDataHistory(){
        getTempDataFromE66();
    }

    public static void appEcgTestStartDeviceToApp(BleDataResponse var0, BleDeviceToAppDataResponse var1) {
        byte[] var2 = new byte[]{2};
        b.a().a(770, 10, var2, 2, var0);
        b.a().a(var1);
    }


}

