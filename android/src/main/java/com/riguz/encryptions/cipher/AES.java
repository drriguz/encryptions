package com.riguz.encryptions.cipher;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

public class AES {
    public enum Mode {
        CBC,
        ECB
    }

    public enum Padding {
        NoPadding,
        PKCS5Padding
    }

    private final byte[] key;
    private final byte[] iv;
    private final Mode mode;
    private final Padding padding;

    public AES(byte[] key, byte[] iv, Mode mode, Padding padding) {
        this.key = key;
        this.iv = iv;
        this.mode = mode;
        this.padding = padding;
    }

    public static AES ofCBC(byte[] key, byte[] iv, Padding padding) {
        return new AES(key, iv, Mode.CBC, padding);
    }

    public static AES ofECB(byte[] key, Padding padding) {
        return new AES(key, null, Mode.ECB, padding);
    }

    public byte[] encrypt(byte[] value) throws InvalidKeyException, IllegalBlockSizeException {
        return process(value, Cipher.ENCRYPT_MODE);
    }

    public byte[] decrypt(byte[] value) throws InvalidKeyException, IllegalBlockSizeException {
        return process(value, Cipher.DECRYPT_MODE);
    }

    public byte[] process(byte[] value, int processMode) throws InvalidKeyException, IllegalBlockSizeException {
        final SecretKeySpec keySpec = new SecretKeySpec(key, "AES");

        try {
            final Cipher cipher = Cipher.getInstance(getAlgorithm());
            if (mode == Mode.ECB) // ECB mode cannot use IV
                cipher.init(processMode, keySpec);
            else
                cipher.init(processMode, keySpec, new IvParameterSpec(iv));

            return cipher.doFinal(value);
        } catch (NoSuchAlgorithmException
                | NoSuchPaddingException
                | InvalidAlgorithmParameterException
                | BadPaddingException e) {
            throw new RuntimeException(e);
        }
    }

    public String getAlgorithm() {
        return String.format("AES/%s/%s", mode.name(), padding.name());
    }
}
