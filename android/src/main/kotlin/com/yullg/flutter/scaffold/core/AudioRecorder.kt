package com.yullg.flutter.scaffold.core

import android.media.AudioRecord
import java.util.concurrent.Executor

class AudioRecorder(
    private val audioRecord: AudioRecord,
    private val executor: Executor,
    private val bufferSize: Int,
    private val listener: Listener
) : Runnable {

    private var isRecording: Boolean = false

    fun start() {
        if (isRecording) {
            return
        }
        isRecording = true
        audioRecord.startRecording()
        executor.execute(this)
    }

    fun stop() {
        isRecording = false
        audioRecord.stop()
    }

    fun release() {
        isRecording = false
        audioRecord.release()
    }

    override fun run() {
        while (isRecording) {
            val buffer = readAudioRecord()
            if (buffer != null) {
                listener.onData(buffer)
            }
        }
    }

    private fun readAudioRecord(): ShortArray? {
        val buffer = ShortArray(bufferSize)
        return if (audioRecord.read(buffer, 0, buffer.size) > 0) {
            buffer
        } else {
            null
        }
    }

    interface Listener {

        fun onData(data: ShortArray)

    }

}