package com.HealthGauge.utils.connections;





import com.HealthGauge.models.BLEDeviceModel;

public interface BLEDeviceScanListener {
    public void onScanBLEDevice(BLEDeviceModel bleDeviceModel);
}
