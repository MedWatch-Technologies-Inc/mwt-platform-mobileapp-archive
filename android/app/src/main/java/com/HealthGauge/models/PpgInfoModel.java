package com.HealthGauge.models;

import java.util.ArrayList;
import java.util.HashMap;

public class PpgInfoModel {

    private double point;
    private ArrayList pointList;
    private long startTime;
    private long endTime;

    public ArrayList getPointList() {
        return pointList;
    }

    public void setPointList(ArrayList pointList) {
        this.pointList = pointList;
    }

    public long getEndTime() {
        return endTime;
    }

    public void setEndTime(long endTime) {
        this.endTime = endTime;
    }

    public long getStartTime() {
        return startTime;
    }

    public void setStartTime(long startTime) {
        this.startTime = startTime;
    }

    public PpgInfoModel() {
    }


    public double getPoint() {
        return point;
    }

    public void setPoint(double point) {
        this.point = point;
    }



    public HashMap toMap() {
        HashMap<String, Object> hashMap = new HashMap<String, Object>();
        hashMap.put("point", point);
        hashMap.put("startTime", startTime);
        hashMap.put("endTime", endTime);
        hashMap.put("pointList", pointList);
        return hashMap;
    }

    public void fromMap(HashMap<String, Object> hashMap) {
       point = (double) hashMap.get("point");
    }
}
