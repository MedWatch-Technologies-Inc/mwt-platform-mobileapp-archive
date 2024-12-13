package com.HealthGauge.models;

import java.util.HashMap;

public class SleepDataInfo{
    private String type;
    private String time;
    private long timeStamp;

    public long getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(long timeStamp) {
        this.timeStamp = timeStamp;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getType() {
        return type;
    }

    public String getTime() {
        return time;
    }

    public HashMap<String,Object> toMap(){
        HashMap<String,Object> hashMap = new HashMap<>();
        hashMap.put("type",type);
        hashMap.put("time",time);
        return hashMap;
    }
}
