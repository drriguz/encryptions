package com.riguz.encryptions;

import android.util.Log;

import org.apache.commons.codec.binary.Hex;

import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterCallExecutor implements MethodChannel.MethodCallHandler {
    private final Map<String, InvokeContext> registeredMethods = new HashMap<>();

    public void register(Class<?> handlerClass) {
        final Constructor<?> constructor;
        try {
            constructor = handlerClass.getConstructor();
        } catch (NoSuchMethodException e) {
            throw new IllegalArgumentException("No default constructor found in " + handlerClass.getName());
        }
        final Method[] methods = handlerClass.getDeclaredMethods();
        for (Method method : methods) {
            final InvokeContext context = parseMethod(constructor, method);
            if (context != null) {
                final String registeredName = context.getMethodName();
                if (registeredMethods.containsKey(registeredName))
                    throw new IllegalArgumentException("Method name conflict:" + registeredName);
                registeredMethods.put(registeredName, context);
                Log.d("FLUTTER_CALL", "registered channel:" + registeredName);
            }
        }
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        final InvokeContext context = registeredMethods.get(methodCall.method);
        if (context == null) {
            result.notImplemented();
        } else {
            execute(context, methodCall, result);
        }
    }

    private void execute(final InvokeContext context,
                         final MethodCall methodCall,
                         final MethodChannel.Result result) {
        try {
            final Object handlerInstance = context.getConstructor().newInstance();
            final List<Object> params = new ArrayList<>();
            for (String paramName : context.getParamNames()) {
                params.add(methodCall.argument(paramName));
            }
            final Object value = context.getInvokableMethod().invoke(handlerInstance, params.toArray());
            Log.d("FLUtTER_CALL", "result:" + new String(Hex.encodeHex((byte[])value)));
            result.success(value);
        } catch (Exception e) {
            e.printStackTrace();
            result.error("FLUTTER_CALL_ERROR", "UNKNOWN", e.getMessage());
        }
    }

    private InvokeContext parseMethod(final Constructor<?> constructor, final Method method) {
        final Invokable invokable = getAnnotation(method.getDeclaredAnnotations(), Invokable.class);
        if (invokable == null)
            return null;
        final String methodName = invokable.value();

        final Annotation[][] allParameterAnnotations = method.getParameterAnnotations();
        final List<String> paramNames = new ArrayList<>();
        for (Annotation[] paramAnnotations : allParameterAnnotations) {
            final Param param = getAnnotation(paramAnnotations, Param.class);
            if (param == null)
                throw new IllegalArgumentException("Please use @Param to specify param name on method:" + method.getName());
            paramNames.add(param.value());
        }
        return new InvokeContext(constructor, method, methodName, paramNames);
    }

    @SuppressWarnings("unchecked")
    private <T> T getAnnotation(final Annotation[] annotations, final Class<T> type) {
        for (Annotation annotation : annotations) {
            if (annotation.annotationType().equals(type)) {
                return (T) annotation;
            }
        }
        return null;
    }
}
