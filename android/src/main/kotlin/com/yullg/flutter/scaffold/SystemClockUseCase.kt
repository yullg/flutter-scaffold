package com.yullg.flutter.scaffold

import android.os.SystemClock

object SystemClockUseCase {

    fun elapsedRealtime(): Long {
        return SystemClock.elapsedRealtime();
    }

    fun uptimeMillis(): Long {
        return SystemClock.uptimeMillis();
    }

}