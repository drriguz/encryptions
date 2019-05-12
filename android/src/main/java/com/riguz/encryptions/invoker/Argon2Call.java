package com.riguz.encryptions.invoker;

import com.riguz.encryptions.Invokable;
import com.riguz.encryptions.Param;
import com.riguz.encryptions.cipher.AES;
import com.riguz.encryptions.cipher.Argon2;

import java.security.InvalidKeyException;

import javax.crypto.IllegalBlockSizeException;

public class Argon2Call {
    private static final Argon2 argon2 = new Argon2(2, 1 << 16, 1, 32);

    @Invokable("argon2i")
    public byte[] argon2i(final @Param("password") byte[] password,
                          final @Param("salt") byte[] salt)
            throws InvokeException {
        return argon2.argon2i(password, salt);
    }

    @Invokable("argon2d")
    public byte[] argon2d(final @Param("password") byte[] password,
                          final @Param("salt") byte[] salt)
            throws InvokeException {
        return argon2.argon2d(password, salt);
    }
}
