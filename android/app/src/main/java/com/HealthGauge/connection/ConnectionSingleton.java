package com.HealthGauge.connection;

import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;

import com.HealthGauge.e66.E66DataListener;
import com.HealthGauge.utils.connections.BLEDeviceScanListener;
import com.HealthGauge.utils.connections.Connections;
import com.HealthGauge.utils.connections.DeviceScanListener;
import com.yucheng.ycbtsdk.Response.BleConnectResponse;
import com.zjw.zhbraceletsdk.linstener.ConnectorListener;
import com.zjw.zhbraceletsdk.linstener.SimplePerformerListener;

public class ConnectionSingleton {

    private static volatile ConnectionSingleton singleton;
    private Connections connections;
    private ConnectionSingleton(DeviceScanListener deviceScanListener, BLEDeviceScanListener bleDeviceScanListener, ConnectorListener connectorListener, SimplePerformerListener simplePerformerListener, E66DataListener e66DataListener, Context context, BleConnectResponse bleConnectResponse, Intent intent, ServiceConnection mServiceConnection) {
        connections = new Connections(deviceScanListener, bleDeviceScanListener,connectorListener, simplePerformerListener, e66DataListener, context, bleConnectResponse,intent,mServiceConnection);

    }

    public static ConnectionSingleton getInstance(DeviceScanListener deviceScanListener, BLEDeviceScanListener bleDeviceScanListener, ConnectorListener connectorListener,
                                                  SimplePerformerListener simplePerformerListener,
                        E66DataListener e66DataListener, Context context, BleConnectResponse bleConnectResponse, Intent intent, ServiceConnection mServiceConnection
    ) {
        if (singleton == null) {
            synchronized (ConnectionSingleton.class) {
                if (singleton == null) {
                    singleton = new ConnectionSingleton(deviceScanListener,bleDeviceScanListener,connectorListener,simplePerformerListener,e66DataListener,context,bleConnectResponse,intent,mServiceConnection);
                }
            }
        }
        return singleton;
    }

    public  static ConnectionSingleton getInstance(){
        return singleton;
    }


    public Connections getConnections() {
        return connections;
    }

}