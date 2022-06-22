package com.example.painter;

import android.media.MediaPlayer;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private MediaPlayer mMediaPlayerTick;
    private MediaPlayer mMediaPlayerAlarm;
    private MediaPlayer mMediaPlayerRegular;
    String CHANNEL = "timerTick";
    String CHANNEL2 = "timerAlarm";
    String CHANNEL3 = "timerRegular";


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "playTick":
                            playTick();
                            break;

                        case "disposeTick":
                            disposeTick();
                            break;
                    }
                });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL2)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {

                        case "playAlarm":
                            String s = call.argument("name");
                            playAlarm(result, s);
                            break;
                        case "disposeAlarm":
                            try {
                                disposeAlarm();
                                result.success(true);
                            } catch (Exception e) {
                                result.error("не выполнено", "xz", "xz");
                            }

                            break;
                    }
                });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL3)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {

                        case "playRegular":
                            playRegular();
                            break;
                        case "disposeRegular":
                            try {
                                disposeRegular();
                                result.success(true);
                            } catch (Exception e) {
                                result.error("не выполнено", "xz", "xz");
                            }

                            break;
                    }
                });

    }


    void playRegular() {
        if (mMediaPlayerRegular == null) {
            mMediaPlayerRegular = MediaPlayer.create(this, R.raw.regular);
            mMediaPlayerRegular.start();


        } else if (!mMediaPlayerRegular.isPlaying() && mMediaPlayerRegular != null) {
            mMediaPlayerRegular.start();
        }
    }

    void disposeRegular() {
        if (mMediaPlayerRegular != null) {
            mMediaPlayerRegular.reset();
            mMediaPlayerRegular.release();
            mMediaPlayerRegular = null;
        }
    }

    void playTick() {
        if (mMediaPlayerTick == null) {
            mMediaPlayerTick = MediaPlayer.create(this, R.raw.tick);
            mMediaPlayerTick.start();
        } else if (!mMediaPlayerTick.isPlaying() && mMediaPlayerTick != null) {
            mMediaPlayerTick.start();
        }
    }

    void disposeTick() {
        if (mMediaPlayerTick != null) {
            mMediaPlayerTick.reset();
            mMediaPlayerTick.release();
            mMediaPlayerTick = null;
        }
    }

    void playAlarm(MethodChannel.Result result, String name) {
        if (mMediaPlayerAlarm == null) {
            if (name.equals("alarm")) {
                mMediaPlayerAlarm = MediaPlayer.create(this, R.raw.alarm);
            } else {
                mMediaPlayerAlarm = MediaPlayer.create(this, R.raw.clap);
            }
            mMediaPlayerAlarm.start();


            mMediaPlayerAlarm.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    result.success("завершено");
                    disposeAlarm();
                }
            });

        } else if (!mMediaPlayerAlarm.isPlaying() && mMediaPlayerAlarm != null) {
            mMediaPlayerAlarm.start();
        }

    }

    void disposeAlarm() {
        if (mMediaPlayerAlarm != null) {
            mMediaPlayerAlarm.reset();
            mMediaPlayerAlarm.release();
            mMediaPlayerAlarm = null;
        }
    }
}
