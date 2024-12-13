package com.HealthGauge.models;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

public class EcgInfoModel  implements Serializable {
    private int approxHr;
    private int approxSBP;
    private int approxDBP;
    private int hrv;
    private double ecgPointY;
    private ArrayList pointList;
    private long startTime;
    private long endTime;
    private boolean isLeadOff;
    private boolean isPoorConductivity;

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

    public EcgInfoModel() {
    }


    public int getApproxHr() {
        return approxHr;
    }

    public void setApproxHr(int approxHr) {
        this.approxHr = approxHr;
    }

    public int getApproxSBP() {
        return approxSBP;
    }

    public void setApproxSBP(int approxSBP) {
        this.approxSBP = approxSBP;
    }

    public int getApproxDBP() {
        return approxDBP;
    }

    public void setApproxDBP(int approxDBP) {
        this.approxDBP = approxDBP;
    }

    public double getEcgPointY() {
        return ecgPointY;
    }

    public void setEcgPointY(double ecgPointY) {
        this.ecgPointY = ecgPointY;
    }

    public int getHrv() {
        return hrv;
    }

    public void setHrv(int hrv) {
        this.hrv = hrv;
    }

    public boolean isLeadOff() {
        return isLeadOff;
    }

    public void setLeadOff(boolean leadOff) {
        isLeadOff = leadOff;
    }
    public boolean isPoorConductivity() {
        return isPoorConductivity;
    }

    public void setPoorConductivity(boolean poorConductivity) {
        isPoorConductivity = poorConductivity;
    }

    public HashMap toMap() {
        HashMap<String, Object> hashMap = new HashMap<String, Object>();
        hashMap.put("approxHr", approxHr);
        hashMap.put("approxSBP", approxSBP);
        hashMap.put("approxDBP", approxDBP);
        hashMap.put("ecgPointY", ecgPointY);
        hashMap.put("startTime", startTime);
        hashMap.put("endTime", endTime);
        hashMap.put("hrv", hrv);
        hashMap.put("isLeadOff", isLeadOff);
        hashMap.put("isPoorConductivity", isPoorConductivity);
        hashMap.put("pointList", pointList);
        return hashMap;
    }

    public void fromMap(HashMap<String, Object> hashMap) {
       approxHr = (int) hashMap.get("approxHr");
       approxSBP = (int) hashMap.get("approxSBP");
       approxDBP = (int) hashMap.get("approxDBP");
        hrv = (int) hashMap.get("hrv");
    }
}
