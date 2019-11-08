package com.riguz.encryptions.invoker;

import com.riguz.encryptions.Invokable;
import com.riguz.encryptions.Param;
import com.riguz.encryptions.cipher.AES;

import java.security.InvalidKeyException;

import javax.crypto.IllegalBlockSizeException;

public class AESCall {
    @Invokable("aesEncrypt")
    public byte[] encrypt(@Param("mode") String mode,
                          @Param("padding") String padding,
                          @Param("key") byte[] key,
                          @Param("iv") byte[] initVector,
                          @Param("value") byte[] value)
            throws InvokeException {
        AES aes = createAES(mode, padding, key, initVector);
        try {
            return aes.encrypt(value);
        } catch (InvalidKeyException | IllegalBlockSizeException e) {
            throw new InvokeException(e);
        }
    }

    @Invokable("aesDecrypt")
    public byte[] decrypt(@Param("mode") String mode,
                          @Param("padding") String padding,
                          @Param("key") byte[] key,
                          @Param("iv") byte[] initVector,
                          @Param("value") byte[] value)
            throws InvokeException {
        AES aes = createAES(mode, padding, key, initVector);
        try {
            return aes.decrypt(value);
        } catch (InvalidKeyException | IllegalBlockSizeException e) {
            throw new InvokeException(e);
        }
    }

    private AES createAES(String mode, String padding, byte[] key, byte[] initVector) {
        final AES.Mode aesMode = AES.Mode.valueOf(mode);
        final AES.Padding aesPadding = AES.Padding.valueOf(padding);
        switch (aesMode) {
            case CBC:
                return AES.ofCBC(key, initVector, aesPadding);
            case ECB:
                return AES.ofECB(key, aesPadding);
            default:
                throw new IllegalArgumentException("Unkown aes mode");
        }
    }
}
