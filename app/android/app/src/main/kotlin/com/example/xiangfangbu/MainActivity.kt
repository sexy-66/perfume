package com.example.xiangfangbu

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

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
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "xiangfangbu/media",
        ).setMethodCallHandler { call, result ->
            if (call.method != "saveImage") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val path = call.argument<String>("path")
            val requestedName = call.argument<String>("displayName")
            if (path.isNullOrBlank() || requestedName.isNullOrBlank()) {
                result.error("invalid_arguments", "图片路径或名称无效", null)
                return@setMethodCallHandler
            }
            try {
                val source = File(path)
                val displayName = requestedName.replace(
                    Regex("[\\\\/:*?\"<>|]"),
                    "_",
                )
                val values = ContentValues().apply {
                    put(MediaStore.Images.Media.DISPLAY_NAME, displayName)
                    put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                    put(
                        MediaStore.Images.Media.RELATIVE_PATH,
                        "${Environment.DIRECTORY_PICTURES}/香方簿",
                    )
                    put(MediaStore.Images.Media.IS_PENDING, 1)
                }
                val uri = contentResolver.insert(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    values,
                ) ?: error("无法创建相册图片")
                try {
                    contentResolver.openOutputStream(uri)?.use { output ->
                        source.inputStream().use { input -> input.copyTo(output) }
                    } ?: error("无法写入相册图片")
                    values.clear()
                    values.put(MediaStore.Images.Media.IS_PENDING, 0)
                    contentResolver.update(uri, values, null, null)
                    result.success(uri.toString())
                } catch (error: Throwable) {
                    contentResolver.delete(uri, null, null)
                    throw error
                }
            } catch (error: Throwable) {
                result.error("save_failed", error.message, null)
            }
        }
    }
}
