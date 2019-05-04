package com.riguz.encryptions.cipher;

import android.util.Log;

import org.apache.commons.codec.binary.Hex;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public final class AES {
    private AES() {
    }

    public static byte[] encrypt(byte[] key, byte[] initVector, byte[] value)
            throws InvalidKeyException, IllegalBlockSizeException {
        final IvParameterSpec iv = new IvParameterSpec(initVector);
        final SecretKeySpec keySpec = new SecretKeySpec(key, "AES");

        Log.d("AES_ENCRYPT", "Key=" + new String(Hex.encodeHex(key)));
        Log.d("AES_ENCRYPT", "Iv=" + new String(Hex.encodeHex(initVector)));
        Log.d("AES_ENCRYPT", "Value=" + new String(Hex.encodeHex(value)));
        try {
            final Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, iv);

            return cipher.doFinal(value);
        } catch (NoSuchAlgorithmException
                | NoSuchPaddingException
                | InvalidAlgorithmParameterException
                | BadPaddingException e) {
            throw new RuntimeException(e);
        }
    }

    public static byte[] decrypt(byte[] key, byte[] initVector, byte[] value)
            throws InvalidKeyException, IllegalBlockSizeException {
        final IvParameterSpec iv = new IvParameterSpec(initVector);
        final SecretKeySpec keySpec = new SecretKeySpec(key, "AES");
        Log.d("AES_DECRYPT", "Key=" + new String(Hex.encodeHex(key)));
        Log.d("AES_DECRYPT", "Iv=" + new String(Hex.encodeHex(initVector)));
        Log.d("AES_DECRYPT", "Value=" + new String(Hex.encodeHex(value)));
        try {
            final Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
            cipher.init(Cipher.DECRYPT_MODE, keySpec, iv);

            return cipher.doFinal(value);
        } catch (NoSuchAlgorithmException
                | NoSuchPaddingException
                | InvalidAlgorithmParameterException
                | BadPaddingException e) {
            throw new RuntimeException(e);
        }
    }
}
