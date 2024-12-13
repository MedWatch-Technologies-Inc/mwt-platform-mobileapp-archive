package com.HealthGauge.models;

import java.io.Serializable;
import java.util.HashMap;

public class TempModel implements Serializable {
    private int HRV;
    private int oxygen;
    private int cvrrValue;
    private int tempInt;
    private int tempDouble;
    private int heartValue;
    private int stepValue;
    private int DBPValue;
    private int startTime;
    private int SBPValue;
    private int respiratoryRateValue;
    private String date;


    public int getHRV() {
        return HRV;
    }

    public void setHRV(int HRV) {
        this.HRV = HRV;
    }

    public int getOxygen() {
        return oxygen;
    }

    public void setOxygen(int oxygen) {
        this.oxygen = oxygen;
    }

    public int getCvrrValue() {
        return cvrrValue;
    }

    public void setCvrrValue(int cvrrValue) {
        this.cvrrValue = cvrrValue;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getTempInt() {
        return tempInt;
    }

    public void setTempInt(int tempInt) {
        this.tempInt = tempInt;
    }

    public int getTempDouble() {
        return tempDouble;
    }

    public void setTempDouble(int tempDouble) {
        this.tempDouble = tempDouble;
    }

    public int getHeartValue() {
        return heartValue;
    }

    public void setHeartValue(int heartValue) {
        this.heartValue = heartValue;
    }

    public int getStepValue() {
        return stepValue;
    }

    public void setStepValue(int stepValue) {
        this.stepValue = stepValue;
    }

    public int getDBPValue() {
        return DBPValue;
    }

    public void setDBPValue(int DBPValue) {
        this.DBPValue = DBPValue;
    }

    public int getStartTime() {
        return startTime;
    }

    public void setStartTime(int startTime) {
        this.startTime = startTime;
    }

    public int getSBPValue() {
        return SBPValue;
    }

    public void setSBPValue(int SBPValue) {
        this.SBPValue = SBPValue;
    }

    public int getRespiratoryRateValue() {
        return respiratoryRateValue;
    }

    public void setRespiratoryRateValue(int respiratoryRateValue) {
        this.respiratoryRateValue = respiratoryRateValue;
    }

    public HashMap toJson() {
        HashMap map = new HashMap();
        map.put("HRV", HRV);
        map.put("oxygen", oxygen);
        map.put("cvrrValue", cvrrValue);
        map.put("tempInt", tempInt);
        map.put("tempDouble", tempDouble);
        map.put("heartValue", heartValue);
        map.put("stepValue", stepValue);
        map.put("DBPValue", DBPValue);
        map.put("startTime", startTime);
        map.put("SBPValue", SBPValue);
        map.put("respiratoryRateValue", respiratoryRateValue);
        map.put("date", date);
        return map;
    }

    public TempModel fromMap(HashMap map) {
        HRV = (int) map.get("HRV");
        oxygen = (int) map.get("oxygen");
        cvrrValue = (int) map.get("cvrrValue");
        tempInt = (int) map.get("tempInt");
        tempDouble = (int) map.get("tempDouble");
        heartValue = (int) map.get("heartValue");
        stepValue = (int) map.get("stepValue");
        DBPValue = (int) map.get("DBPValue");
        startTime = (int) map.get("startTime");
        SBPValue = (int) map.get("SBPValue");
        respiratoryRateValue = (int) map.get("respiratoryRateValue");
        date = (String) map.get("date");
        return this;
    }
}
