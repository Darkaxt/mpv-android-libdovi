package com.darkaxt.mpvcompat

import android.content.Context
import android.util.AttributeSet
import `is`.xyz.mpv.BaseMPVView
import `is`.xyz.mpv.MPV

/** Compile-only guard for the API shape consumed by Nuvio. */
class CompatibilityView(
    context: Context,
    attrs: AttributeSet? = null,
) : BaseMPVView(context, attrs) {
    override fun initOptions() {
        mpv.setOptionString("vo", "gpu-next")
    }

    override fun postInitOptions() = Unit

    override fun observeProperties() {
        mpv.observeProperty("pause", MPV.mpvFormat.MPV_FORMAT_FLAG)
    }

    fun configureAndLoad(url: String) {
        val player: MPV = mpv
        player.setOptionString("vo", "gpu-next")
        player.setPropertyString("pause", "no")
        player.command("loadfile", url)
    }
}
