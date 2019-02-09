package com.ciy.flutterkugou;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.PixelFormat;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.graphics.Palette;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.transition.Transition;

import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.ciy.flutterkugou/imagePalette";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, Result result) {
                if (methodCall.method.equals("getImagePalette")) {
                    String url = (String) methodCall.arguments;
                    if (paletteCache.containsKey(url)) {
                        result.success(paletteCache.get(url));
                        return;
                    }
                    // 使用Glide获取图片
                    Glide.with(MainActivity.this).load(url).into(new SimpleTarget<Drawable>() {
                        @Override
                        public void onResourceReady(@NonNull Drawable resource, @Nullable Transition<? super Drawable> transition) {
                            Bitmap bitmap = drawableToBitmap(resource);
                            // 使用Palette获取主色调
                            Palette.from(bitmap).generate(new Palette.PaletteAsyncListener() {
                                @Override
                                public void onGenerated(@NonNull Palette palette) {
                                    // primaryColor默认颜色 0x2196F3
                                    Palette.Swatch swatch = palette.getVibrantSwatch();
                                    if (swatch == null) {
                                        swatch = palette.getMutedSwatch();
                                    }
                                    if (swatch != null) {
                                        int color = swatch.getRgb();
                                        int red = (color & 0xff0000) >> 16;
                                        int green = (color & 0x00ff00) >> 8;
                                        int blue = (color & 0x0000ff);
                                        String colorResult = "255," + red + "," + green + "," + blue;
                                        paletteCache.put(url, colorResult);
                                        result.success(colorResult);
                                        return;
                                    }
                                    result.success("");
                                }
                            });
                        }
                    });
                }
            }
        });
        GeneratedPluginRegistrant.registerWith(this);
    }

    static Bitmap drawableToBitmap(Drawable drawable) // drawable 转换成bitmap
    {
        int width = drawable.getIntrinsicWidth();// 取drawable的长宽
        int height = drawable.getIntrinsicHeight();
        Bitmap.Config config = drawable.getOpacity() != PixelFormat.OPAQUE ? Bitmap.Config.ARGB_8888 : Bitmap.Config.RGB_565;// 取drawable的颜色格式
        Bitmap bitmap = Bitmap.createBitmap(width, height, config);// 建立对应bitmap
        Canvas canvas = new Canvas(bitmap);// 建立对应bitmap的画布
        drawable.setBounds(0, 0, width, height);
        drawable.draw(canvas);// 把drawable内容画到画布中
        return bitmap;
    }

    static Map<String, String> paletteCache = new HashMap<>();
}
