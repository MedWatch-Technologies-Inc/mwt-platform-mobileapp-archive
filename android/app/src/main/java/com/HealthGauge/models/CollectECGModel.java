package com.HealthGauge.models;

import java.util.ArrayList;
import java.util.HashMap;

public class CollectECGModel {
    private Number collectDigits;
    private Number collectType;
    private Number collectSN;
    private Number collectTotalLen;
    private Number collectSendTime;
    private Number collectStartTime;
    private Number collectBlockNum;
    private ArrayList ecgData;

    public CollectECGModel() {
    }

    public ArrayList getEcgData() {
        return ecgData;
    }

    public void setEcgData(ArrayList ecgData) {
        this.ecgData = ecgData;
    }

    public Number getCollectDigits() {
        return collectDigits;
    }

    public void setCollectDigits(Number collectDigits) {
        this.collectDigits = collectDigits;
    }

    public Number getCollectType() {
        return collectType;
    }

    public void setCollectType(Number collectType) {
        this.collectType = collectType;
    }

    public Number getCollectSN() {
        return collectSN;
    }

    public void setCollectSN(Number collectSN) {
        this.collectSN = collectSN;
    }

    public Number getCollectTotalLen() {
        return collectTotalLen;
    }

    public void setCollectTotalLen(Number collectTotalLen) {
        this.collectTotalLen = collectTotalLen;
    }

    public Number getCollectSendTime() {
        return collectSendTime;
    }

    public void setCollectSendTime(Number collectSendTime) {
        this.collectSendTime = collectSendTime;
    }

    public Number getCollectStartTime() {
        return collectStartTime;
    }

    public void setCollectStartTime(Number collectStartTime) {
        this.collectStartTime = collectStartTime;
    }

    public Number getCollectBlockNum() {
        return collectBlockNum;
    }

    public void setCollectBlockNum(Number collectBlockNum) {
        this.collectBlockNum = collectBlockNum;
    }

    public HashMap<String, Object> toMap() {
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("collectDigits", collectDigits);
        hashMap.put("collectType", collectType);
        hashMap.put("collectSN", collectSN);
        hashMap.put("collectTotalLen", collectTotalLen);
        hashMap.put("collectSendTime", collectSendTime);
        hashMap.put("collectStartTime", collectStartTime);
        hashMap.put("collectBlockNum", collectBlockNum);
        hashMap.put("ecgData", ecgData);
        return  hashMap;
    }

    @Override
    public String toString() {
        return "CollectECGModel{" +
                "collectDigits=" + collectDigits +
                ", collectType=" + collectType +
                ", collectSN=" + collectSN +
                ", collectTotalLen=" + collectTotalLen +
                ", collectSendTime=" + collectSendTime +
                ", collectStartTime=" + collectStartTime +
                ", collectBlockNum=" + collectBlockNum +
                ", ecgData=" + ecgData +
                '}';
    }
}
