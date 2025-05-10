package com.yullg.flutter.scaffold.core

import android.annotation.SuppressLint
import android.content.Context
import android.media.AudioFormat
import android.media.AudioPlaybackCaptureConfiguration
import android.media.AudioRecord
import android.os.Build
import java.nio.ByteBuffer
import java.nio.ByteOrder

@SuppressLint("MissingPermission")
class AudioRecorder(
    format: AudioFormat,
    source: Int? = null,
    config: AudioPlaybackCaptureConfiguration? = null,
    privacySensitive: Boolean? = null,
    context: Context? = null
) {

    private val locker = Object()

    private val bufferSizeInBytes: Int
    private val audioRecord: AudioRecord
    private val audioRecordThread: Thread

    var status: Status = Status.READY
        private set
    var listener: Listener? = null

    init {
        val minBufferSize = AudioRecord.getMinBufferSize(
            format.sampleRate,
            format.channelMask,
            format.encoding
        )
        bufferSizeInBytes = minBufferSize * 2
        audioRecord = AudioRecord.Builder().apply {
            setAudioFormat(format)
            source?.also { setAudioSource(it) }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                config?.also { setAudioPlaybackCaptureConfig(it) }
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                privacySensitive?.also { setPrivacySensitive(it) }
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                context?.also { setContext(it) }
            }
            setBufferSizeInBytes(bufferSizeInBytes)
        }.build()
        audioRecordThread = Thread(MyRunnable(), "AudioRecorderThread")
        audioRecordThread.priority = Thread.MAX_PRIORITY
        audioRecordThread.start()
    }

    fun start() {
        if (Status.READY == status || Status.STOPPED == status) {
            try {
                audioRecord.startRecording()
                status = Status.STARTED
                synchronized(locker) {
                    locker.notifyAll()
                }
            } finally {
                listener?.onStatus(status)
            }
        }
    }

    fun stop() {
        if (Status.STARTED == status) {
            try {
                status = Status.STOPPED
                audioRecord.stop()
            } finally {
                listener?.onStatus(status)
            }
        }

    }

    fun release() {
        if (Status.RELEASED != status) {
            try {
                status = Status.RELEASED
                audioRecordThread.interrupt()
            } finally {
                try {
                    audioRecord.release()
                } finally {
                    listener?.onStatus(status)
                }
            }
        }
    }

    private fun read(): ByteBuffer {
        val audioBuffer = ByteBuffer.allocateDirect(bufferSizeInBytes).apply {
            order(ByteOrder.nativeOrder())
        }
        val readResult = audioRecord.read(audioBuffer, bufferSizeInBytes)
        if (readResult >= 0) {
            return audioBuffer
        } else {
            val messageSB = StringBuilder("Error when reading audio data:").appendLine()
            when (readResult) {
                AudioRecord.ERROR_INVALID_OPERATION -> messageSB.append("ERROR_INVALID_OPERATION: Failure due to the improper use of a method.")
                AudioRecord.ERROR_BAD_VALUE -> messageSB.append("ERROR_BAD_VALUE: Failure due to the use of an invalid value.")
                AudioRecord.ERROR_DEAD_OBJECT -> messageSB.append("ERROR_DEAD_OBJECT: Object is no longer valid and needs to be recreated.")
                AudioRecord.ERROR -> messageSB.append("ERROR: Generic operation failure")
                else -> messageSB.append("Unknown errorCode: (").append(readResult).append(")")
            }
            throw RuntimeException(messageSB.toString())
        }
    }

    private inner class MyRunnable : Runnable {
        override fun run() {
            while (!Thread.currentThread().isInterrupted) {
                try {
                    while (Status.STARTED != status) {
                        synchronized(locker) {
                            if (Status.STARTED != status) {
                                locker.wait()
                            }
                        }
                    }
                    val audioBuffer = read()
                    listener?.onData(audioBuffer)
                } catch (e: InterruptedException) {
                    break
                } catch (e: Throwable) {
                    listener?.onError(e)
                }
            }
        }
    }

    enum class Status { READY, STARTED, STOPPED, RELEASED }

    interface Listener {

        fun onStatus(status: Status) {}

        fun onData(data: ByteBuffer) {}

        fun onError(error: Throwable) {}

    }

}