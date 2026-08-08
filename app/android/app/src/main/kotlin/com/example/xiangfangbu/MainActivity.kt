package com.example.xiangfangbu

import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun popSystemNavigator(): Boolean {
        finishAndRemoveTask()
        return true
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "xiangfangbu/device",
        ).setMethodCallHandler { call, result ->
            if (call.method != "name") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val configured = Settings.Global.getString(
                contentResolver,
                Settings.Global.DEVICE_NAME,
            )?.trim()
            val fallback = "${Build.MANUFACTURER} ${Build.MODEL}".trim()
            result.success(configured?.takeIf { it.isNotEmpty() } ?: fallback)
        }
    }
}
