package com.riguz.encryptions.invoker;

import com.riguz.encryptions.Invokable;
import com.riguz.encryptions.Param;
import com.riguz.encryptions.cipher.Argon2;

public class Argon2Call {
    @Invokable("argon2i")
    public byte[] argon2i(final @Param("iterations") int iterations,
                          final @Param("memory") int memory,
                          final @Param("parallelism") int parallelism,
                          final @Param("hashLength") int hashLength,
                          final @Param("password") byte[] password,
                          final @Param("salt") byte[] salt)
            throws InvokeException {
        final Argon2 argon2 = new Argon2(iterations, memory, parallelism, hashLength);
        return argon2.argon2i(password, salt);
    }

    @Invokable("argon2d")
    public byte[] argon2d(final @Param("iterations") int iterations,
                          final @Param("memory") int memory,
                          final @Param("parallelism") int parallelism,
                          final @Param("hashLength") int hashLength,
                          final @Param("password") byte[] password,
                          final @Param("salt") byte[] salt)
            throws InvokeException {
        final Argon2 argon2 = new Argon2(iterations, memory, parallelism, hashLength);
        return argon2.argon2d(password, salt);
    }

    @Invokable("argon2id")
    public byte[] argon2id(final @Param("iterations") int iterations,
                           final @Param("memory") int memory,
                           final @Param("parallelism") int parallelism,
                           final @Param("hashLength") int hashLength,
                           final @Param("password") byte[] password,
                           final @Param("salt") byte[] salt)
            throws InvokeException {
        final Argon2 argon2 = new Argon2(iterations, memory, parallelism, hashLength);
        return argon2.argon2id(password, salt);
    }
}
