package com.tk.nfc_card

import android.os.Bundle
import com.anythink.core.api.ATSDK
import com.facebook.ads.AudienceNetworkAds
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AudienceNetworkAds.initialize(this)
        ATSDK.init(this, "a66cfe8cb1619e", "a97c28d90bde260af69e71132ab7e5812")
    }
}
