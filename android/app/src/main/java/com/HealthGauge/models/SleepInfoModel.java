package com.HealthGauge.models;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
public class SleepInfoModel  implements Serializable {
    String date;
    int sleepAllTime;
    int deepTime;
    int lightTime;
    int stayUpTime;
    int wakInCount;
    int allTime;
    ArrayList<SleepDataInfo> data = new ArrayList<>();

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getSleepAllTime() {
        return sleepAllTime;
    }

    public void setSleepAllTime(int sleepAllTime) {
        this.sleepAllTime = sleepAllTime;
    }

    public int getDeepTime() {
        return deepTime;
    }

    public void setDeepTime(int deepTime) {
        this.deepTime = deepTime;
    }

    public int getLightTime() {
        return lightTime;
    }

    public void setLightTime(int lightTime) {
        this.lightTime = lightTime;
    }

    public int getStayUpTime() {
        return stayUpTime;
    }

    public void setStayUpTime(int stayUpTime) {
        this.stayUpTime = stayUpTime;
    }

    public int getWakInCount() {
        return wakInCount;
    }

    public void setWakInCount(int wakInCount) {
        this.wakInCount = wakInCount;
    }

    public int getAllTime() {
        return allTime;
    }

    public void setAllTime(int allTime) {
        this.allTime = allTime;
    }

    public ArrayList<SleepDataInfo> getData() {
        return data;
    }

    public void setData(ArrayList<SleepDataInfo> data) {
        this.data = data;
    }

    public HashMap toMap() {
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("date", date);
        hashMap.put("sleepAllTime", sleepAllTime);
        hashMap.put("deepTime", deepTime);
        hashMap.put("lightTime", lightTime);
        hashMap.put("stayUpTime", stayUpTime);
        hashMap.put("wakInCount", wakInCount);
        hashMap.put("allTime", allTime);
        ArrayList<HashMap<String,Object>> dataMap = new ArrayList<>();
        for (int i = 0; i < data.size(); i++) {
            dataMap.add(data.get(i).toMap());
        }
        hashMap.put("data", dataMap);
        return hashMap;
    }

    @Override
    public String toString() {
        return "SleepInfoModel{" +
                "date='" + date + '\'' +
                ", sleepAllTime=" + sleepAllTime +
                ", deepTime=" + deepTime +
                ", lightTime=" + lightTime +
                ", stayUpTime=" + stayUpTime +
                ", wakInCount=" + wakInCount +
                ", allTime=" + allTime +
                ", data=" + data +
                '}';
    }

}
