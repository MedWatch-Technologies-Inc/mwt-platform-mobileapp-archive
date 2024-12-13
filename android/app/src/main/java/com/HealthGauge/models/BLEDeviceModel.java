package com.HealthGauge.models;

import java.util.HashMap;

public class BLEDeviceModel {

    private String deviceAddress;
    private String deviceName;
    private String deviceRange;
    private String deviceUuids;
    private String deviceBondState;

    public String getDeviceBondState() {
        return deviceBondState;
    }

    public void setDeviceBondState(String deviceBondState) {
        this.deviceBondState = deviceBondState;
    }

    public String getDeviceUuids() {
        return deviceUuids;
    }

    public void setDeviceUuids(String deviceUuids) {
        this.deviceUuids = deviceUuids;
    }

    public String getDeviceAddress() {
        return deviceAddress;
    }

    public void setDeviceAddress(String deviceAddress) {
        this.deviceAddress = deviceAddress;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDeviceRange() {
        return deviceRange;
    }

    public void setDeviceRange(String deviceRange) {
        this.deviceRange = deviceRange;
    }

    public void fromMap(HashMap map){
        deviceAddress = (String) map.get("address");
        deviceName = (String) map.get("name");
        deviceRange = (String) map.get("rssi");
        deviceUuids = (String) map.get("Uuids");
        deviceBondState = (String) map.get("BondState");

    }

    public HashMap toMap(){
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("name",deviceName);
        hashMap.put("rssi",deviceRange);
        hashMap.put("address",deviceAddress);
        hashMap.put("Uuids",deviceUuids);
        hashMap.put("BondState",deviceBondState);

        return hashMap;
    }

}
