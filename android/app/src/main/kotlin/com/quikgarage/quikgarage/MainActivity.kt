package com.quikgarage.quikgarage

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "com.quikgarage.quikgarage/whatsapp"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "sharePdf") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val path = call.argument<String>("path")
                val phone = call.argument<String>("phone")
                val text = call.argument<String>("text") ?: ""
                if (path.isNullOrBlank() || phone.isNullOrBlank()) {
                    result.error("bad_args", "path and phone required", null)
                    return@setMethodCallHandler
                }
                try {
                    sharePdfToCustomer(path, phone, text)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("share_failed", e.message, null)
                }
            }
    }

    private fun sharePdfToCustomer(path: String, phone: String, text: String) {
        val file = File(path)
        if (!file.exists()) {
            throw IllegalStateException("PDF file not found")
        }
        val pkg = whatsAppPackage()
            ?: throw IllegalStateException("WhatsApp not installed")
        val uri: Uri = FileProvider.getUriForFile(
            this,
            "$packageName.fileprovider",
            file,
        )
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "application/pdf"
            setPackage(pkg)
            putExtra(Intent.EXTRA_STREAM, uri)
            putExtra(Intent.EXTRA_TEXT, text)
            putExtra("jid", "$phone@s.whatsapp.net")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        grantUriPermission(pkg, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
        startActivity(intent)
    }

    private fun whatsAppPackage(): String? {
        return when {
            isInstalled("com.whatsapp") -> "com.whatsapp"
            isInstalled("com.whatsapp.w4b") -> "com.whatsapp.w4b"
            else -> null
        }
    }

    private fun isInstalled(pkg: String): Boolean {
        return try {
            packageManager.getPackageInfo(pkg, 0)
            true
        } catch (_: PackageManager.NameNotFoundException) {
            false
        }
    }
}
