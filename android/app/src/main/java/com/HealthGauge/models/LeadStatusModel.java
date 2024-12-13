package com.HealthGauge.models;

import java.io.Serializable;
import java.util.HashMap;

public class LeadStatusModel implements Serializable {
    private int ecgStatus;
    private int ppgStatus;

    public int getEcgStatus() {
        return ecgStatus;
    }

    public void setEcgStatus(int ecgStatus) {
        this.ecgStatus = ecgStatus;
    }

    public int getPpgStatus() {
        return ppgStatus;
    }

    public void setPpgStatus(int ppgStatus) {
        this.ppgStatus = ppgStatus;
    }

    public HashMap toMap() {
        HashMap<String, Object> hashMap = new HashMap<String, Object>();
        hashMap.put("ecgStatus", ecgStatus);
        hashMap.put("ppgStatus", ppgStatus);
        return hashMap;
    }

    public void fromMap(HashMap<String, Object> hashMap) {
        ecgStatus = (int) hashMap.get("ecgStatus");
        ppgStatus = (int) hashMap.get("ppgStatus");
    }
}
