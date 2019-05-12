package com.riguz.encryptions.cipher;

public final class Argon2 {
    static {
        System.loadLibrary("argon2-binding");
    }

    private final int iterations;
    private final int memory;
    private final int parallelism;
    private final int hashLength;

    public Argon2(int iterations, int memory, int parallelism, int hashLength) {
        this.iterations = iterations;
        this.memory = memory;
        this.parallelism = parallelism;
        this.hashLength = hashLength;
    }

    public byte[] argon2i(final byte[] password, final byte[] salt) {
        return argon2iInternal(iterations, memory, parallelism, password, salt, hashLength);
    }

    public byte[] argon2d(final byte[] password, final byte[] salt) {
        return argon2dInternal(iterations, memory, parallelism, password, salt, hashLength);
    }

    private native byte[] argon2iInternal(int iterations, int memory, int parallelism, final byte[] password, final byte[] salt, int hashLength);

    private native byte[] argon2dInternal(int iterations, int memory, int parallelism, final byte[] password, final byte[] salt, int hashLength);
}