import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.library")
}

group = "io.github.darkaxt"
version = "0.1.12-darkaxt.1"

android {
    namespace = "is.xyz.mpv"
    compileSdk = 36

    defaultConfig {
        minSdk = 21
    }

    buildFeatures {
        buildConfig = true
    }

    sourceSets["main"].jniLibs.srcDir("src/main/libs")

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    tasks.withType<KotlinCompile> {
        compilerOptions.jvmTarget.set(JvmTarget.JVM_11)
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.7.1")
}

tasks.register<Jar>("sourceJar") {
    archiveClassifier.set("sources")
    from(android.sourceSets["main"].java.srcDirs)
}
