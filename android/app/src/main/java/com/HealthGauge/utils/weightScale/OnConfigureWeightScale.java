package com.HealthGauge.utils.weightScale;

import java.io.Serializable;

import aicare.net.cn.iweightlibrary.entity.User;
import io.flutter.plugin.common.MethodChannel;

public interface OnConfigureWeightScale extends Serializable {
    void initialiseChannel(MethodChannel channel);
    void onStartScanning();
    void onStopScanning();
    void onGetUserInformation(User user);
    void onSetUnit(int unit);
    void onDisconnect();
}