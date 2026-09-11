plugins {
    id("com.android.library")
}

android {
    namespace = "com.darkaxt.mpvcompat"
    compileSdk = 36

    defaultConfig {
        minSdk = 21
    }
}

dependencies {
    implementation(files("../lib/build/outputs/aar/lib-release.aar"))
}
