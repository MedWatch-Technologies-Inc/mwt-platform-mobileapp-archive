package com.HealthGauge.models;

import java.util.HashMap;
import java.util.List;

public class OfflineEcgInfoModel {
    String ecgDate;
    int ecgHR;
    int ecgSBP;
    int ecgDBP;
    int healthHrvIndex;
    int healthFatigueIndex;
    int healthLoadIndex;
    int healthBodyIndex;
    int healtHeartIndex;
    List ecgData;

    public String getEcgDate() {
        return ecgDate;
    }

    public void setEcgDate(String ecgDate) {
        this.ecgDate = ecgDate;
    }

    public int getEcgHR() {
        return ecgHR;
    }

    public void setEcgHR(int ecgHR) {
        this.ecgHR = ecgHR;
    }

    public int getEcgSBP() {
        return ecgSBP;
    }

    public void setEcgSBP(int ecgSBP) {
        this.ecgSBP = ecgSBP;
    }

    public int getEcgDBP() {
        return ecgDBP;
    }

    public void setEcgDBP(int ecgDBP) {
        this.ecgDBP = ecgDBP;
    }

    public int getHealthHrvIndex() {
        return healthHrvIndex;
    }

    public void setHealthHrvIndex(int healthHrvIndex) {
        this.healthHrvIndex = healthHrvIndex;
    }

    public int getHealthFatigueIndex() {
        return healthFatigueIndex;
    }

    public void setHealthFatigueIndex(int healthFatigueIndex) {
        this.healthFatigueIndex = healthFatigueIndex;
    }

    public int getHealthLoadIndex() {
        return healthLoadIndex;
    }

    public void setHealthLoadIndex(int healthLoadIndex) {
        this.healthLoadIndex = healthLoadIndex;
    }

    public int getHealthBodyIndex() {
        return healthBodyIndex;
    }

    public void setHealthBodyIndex(int healthBodyIndex) {
        this.healthBodyIndex = healthBodyIndex;
    }

    public int getHealtHeartIndex() {
        return healtHeartIndex;
    }

    public void setHealtHeartIndex(int healtHeartIndex) {
        this.healtHeartIndex = healtHeartIndex;
    }

    public List getEcgData() {
        return ecgData;
    }

    public void setEcgData(List ecgData) {
        this.ecgData = ecgData;
    }

    public HashMap toMap() {
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("ecgDate", ecgDate);
        hashMap.put("ecgHR", ecgHR);
        hashMap.put("ecgSBP", ecgSBP);
        hashMap.put("ecgDBP", ecgDBP);
        hashMap.put("healthHrvIndex", healthHrvIndex);
        hashMap.put("healthFatigueIndex", healthFatigueIndex);
        hashMap.put("healthLoadIndex", healthLoadIndex);
        hashMap.put("healthBodyIndex", healthBodyIndex);
        hashMap.put("healtHeartIndex", healtHeartIndex);
        hashMap.put("ecgData", ecgData);
        return hashMap;
    }

    @Override
    public String toString() {
        return "OfflineEcgInfoModel{" +
                "ecgDate='" + ecgDate + '\'' +
                ", ecgHR=" + ecgHR +
                ", ecgSBP=" + ecgSBP +
                ", ecgDBP=" + ecgDBP +
                ", healthHrvIndex=" + healthHrvIndex +
                ", healthFatigueIndex=" + healthFatigueIndex +
                ", healthLoadIndex=" + healthLoadIndex +
                ", healthBodyIndex=" + healthBodyIndex +
                ", healtHeartIndex=" + healtHeartIndex +
                ", ecgData=" + ecgData +
                '}';
    }
}
