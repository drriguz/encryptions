package com.riguz.encryptions;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.List;

class InvokeContext {
    private final Constructor<?> constructor;
    private final Method invokableMethod;
    private final String methodName;
    private final List<String> paramNames;


    public InvokeContext(Constructor<?> constructor,
                         Method invokableMethod,
                         String methodName,
                         List<String> paramNames) {
        this.constructor = constructor;
        this.invokableMethod = invokableMethod;
        this.methodName = methodName;
        this.paramNames = Collections.unmodifiableList(paramNames);
    }

    public Constructor<?> getConstructor() {
        return constructor;
    }

    public Method getInvokableMethod() {
        return invokableMethod;
    }

    public String getMethodName() {
        return methodName;
    }

    public List<String> getParamNames() {
        return paramNames;
    }
}
