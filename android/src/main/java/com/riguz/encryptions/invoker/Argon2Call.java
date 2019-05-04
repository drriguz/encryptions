package com.riguz.encryptions.invoker;

import com.riguz.encryptions.Invokable;
import com.riguz.encryptions.Param;
import com.riguz.encryptions.cipher.AES;
import com.riguz.encryptions.cipher.Argon2;

import java.security.InvalidKeyException;

import javax.crypto.IllegalBlockSizeException;

public class Argon2Call {
    private static final Argon2 argon2 = new Argon2(256, 32, 2, 32);

    @Invokable("argon2i")
    public byte[] argon2i(@Param("password") String password,
                          @Param("salt") String salt)
            throws InvokeException {
        return argon2.argon2i(password, salt);
    }

    @Invokable("argon2d")
    public byte[] argon2d(@Param("password") String password,
                          @Param("salt") String salt)
            throws InvokeException {
        return argon2.argon2d(password, salt);
    }
}
