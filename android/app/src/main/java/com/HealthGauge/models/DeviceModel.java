package com.HealthGauge.models;

import java.util.HashMap;

public class DeviceModel {
   private String deviceAddress;
   private String deviceName;
   private String deviceRange;
   private boolean isWeightScaleDevice;
   private int sdkType;
   private String sdk;

    public String getSdk() {
        return sdk;
    }

    public void setSdk(String sdk) {
        this.sdk = sdk;
    }

    public int getSdkType() {
        return sdkType;
    }

    public void setSdkType(int sdkType) {
        this.sdkType = sdkType;
    }

    public boolean isWeightScaleDevice() {
        return isWeightScaleDevice;
    }

    public void setWeightScaleDevice(boolean weightScaleDevice) {
        isWeightScaleDevice = weightScaleDevice;
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
        sdk = (String) map.get("sdk");
        isWeightScaleDevice = (boolean) map.get("isWeightScaleDevice");
        sdkType = (int) map.get("sdkType");
    }

    public HashMap toMap(){
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("name",deviceName);
        hashMap.put("rssi",deviceRange);
        hashMap.put("address",deviceAddress);
        hashMap.put("sdk",sdk);
        hashMap.put("isWeightScaleDevice",isWeightScaleDevice);
        hashMap.put("sdkType",sdkType);
        return hashMap;
    }
}
