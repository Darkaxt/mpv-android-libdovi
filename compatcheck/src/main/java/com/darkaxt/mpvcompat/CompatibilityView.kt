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
    fun configureAndLoad(url: String) {
        val player: MPV = requireNotNull(mpv)
        player.setOptionString("vo", "gpu-next")
        player.setPropertyString("pause", "no")
        player.command("loadfile", url)
    }
}
