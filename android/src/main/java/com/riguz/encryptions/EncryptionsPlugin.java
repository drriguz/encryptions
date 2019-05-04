package com.riguz.encryptions;

import com.riguz.encryptions.invoker.AESCall;
import com.riguz.encryptions.invoker.Argon2Call;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;


public class EncryptionsPlugin {
    private static final FlutterCallExecutor executor = new FlutterCallExecutor();

    static {
        executor.register(AESCall.class);
        executor.register(Argon2Call.class);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "encryptions");
        channel.setMethodCallHandler(executor);
    }
}
