import java.io.File

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val xiangRoot = rootProject.projectDir.parentFile.parentFile
val releaseSigningDirectory = File(xiangRoot, ".secrets")
val releaseKeystore = File(releaseSigningDirectory, "sexy66-release.jks")
val releaseCredentials = File(
    releaseSigningDirectory,
    "sexy66-release.credentials.txt",
)

fun releaseCredential(label: String): String {
    val prefix = "$label:"
    return releaseCredentials.useLines { lines ->
        lines.firstOrNull { it.startsWith(prefix) }
            ?.substring(prefix.length)
            ?.trim()
    } ?: error("Missing release signing credential: $label")
}

android {
    namespace = "com.example.xiangfangbu"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.xiangfangbu"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 29
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("sexy66") {
            storeFile = releaseKeystore
            storePassword = releaseCredential("Store password")
            keyAlias = "sexy66"
            keyPassword = releaseCredential("Key password")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("sexy66")
        }
    }

    lint {
        // Flutter rewrites the ignored local.properties with valid Windows paths.
        disable += "PropertyEscape"
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
