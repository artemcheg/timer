package com.example.painter;

import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private MediaPlayer mMediaPlayer;
    private SoundPool mSoundPool;
    int mSoundId;
    String CHANNEL = "timer";
    String CHANNEL_POOL = "timerPool";
    int streamId = 0;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "play":
                            play();
                            break;

                        case "dispose":
                            dispose();
                            break;
                    }
                });


        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_POOL).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "play":
                    poolPlay();
                    break;
                case "pause":
                    poolPause();
                    break;
                case "resume":
                    poolResume();
                    break;
                case "stop":
                    poolStop();
                    break;
                case "dispose":
                    poolDispose();
                    break;
            }
        });

    }


    void poolPlay() {
        if (Build.VERSION.SDK_INT <= 21) {
            mSoundPool = new SoundPool(1, AudioManager.STREAM_ALARM, 0);
        } else {
            mSoundPool = new SoundPool.Builder().setMaxStreams(1).
                    setAudioAttributes(new AudioAttributes.Builder().
                            setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build()).build();
        }
        mSoundId = mSoundPool.load(this, R.raw.tick, 1);
        streamId = mSoundPool.play(mSoundId, 1, 1, 1, 0, 1);
    }

    void poolStop() {
        if (mSoundPool != null) {
            mSoundPool.stop(streamId);
        }
    }

    void poolPause() {
        if (mSoundPool != null) {
            mSoundPool.pause(streamId);
        }
    }

    void poolResume() {
        if (mSoundPool != null) {
            mSoundPool.resume(streamId);
        }
    }

    void poolDispose() {
        if (mSoundPool != null) {
            mSoundPool.release();
            mSoundPool = null;
        }
    }


    void play() {
        if (mMediaPlayer == null) {
            mMediaPlayer = MediaPlayer.create(this, R.raw.tick);
            mMediaPlayer.start();
        } else if (!mMediaPlayer.isPlaying() && mMediaPlayer != null) {
            mMediaPlayer.start();
        }
    }


    void dispose() {
        if (mMediaPlayer != null) {
            mMediaPlayer.release();
            mMediaPlayer = null;
        }
    }
}
