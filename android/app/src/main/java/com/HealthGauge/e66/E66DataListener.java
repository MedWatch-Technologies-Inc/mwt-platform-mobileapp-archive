package com.HealthGauge.e66;

import com.HealthGauge.models.CollectECGModel;
import com.HealthGauge.models.EcgInfoModel;
import com.HealthGauge.models.LeadStatusModel;
import com.HealthGauge.models.MotionInfoModel;
import com.HealthGauge.models.PpgInfoModel;
import com.HealthGauge.models.SleepInfoModel;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

public interface E66DataListener extends Serializable {
    public void onGetMotionData(ArrayList<MotionInfoModel> motionInfoModelList);
    public void onGetSleepData(ArrayList<SleepInfoModel> sleepDataInfo);
    public void onGetECGData(EcgInfoModel ecgInfoModel);
    public void onGetPPGData(PpgInfoModel ppgInfoModel);
    public void onGetLeadStatus(LeadStatusModel leadStatusModel);
    public void onGetHRData(int hr, int sbp, int dbp);
    public void onGetTempData(ArrayList mapList);
    public void onGetHeartRateData(ArrayList hashMap);
    public void onE66DeviceConnect(boolean isConnected);
    public void onResponseE80RealTimeMotionData(HashMap map);
    public void onGetAlarmList(HashMap map);
    public void onAddAlarm(HashMap map);
    public void onGetHeartRateFromRunMode(int heartRate);
    public void onE66DeviceDisConnect();
    public void startModeSuccess();
    public void stopModeSuccess();
    public void onGetRealTemp(double number);
    public void onResponseStart(boolean isStarted);
    public void onResponseEnd(boolean isStopped);
    public void onResponseCollectECG(CollectECGModel collectECGModel);
    public void onResponseCollectBP(ArrayList<HashMap> hashMaps);
    //listener
}
