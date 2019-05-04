package com.riguz.encryptions.invoker;

import com.riguz.encryptions.Invokable;
import com.riguz.encryptions.Param;
import com.riguz.encryptions.cipher.AES;

import java.security.InvalidKeyException;

import javax.crypto.IllegalBlockSizeException;

public class AESCall {
    @Invokable("aesEncrypt")
    public byte[] encrypt(@Param("key") byte[] key,
                          @Param("iv") byte[] initVector,
                          @Param("value") byte[] value)
            throws InvokeException {
        try {
            return AES.encrypt(key, initVector, value);
        } catch (InvalidKeyException | IllegalBlockSizeException e) {
            throw new InvokeException(e);
        }
    }

    @Invokable("aesDecrypt")
    public byte[] decrypt(@Param("key") byte[] key,
                          @Param("iv") byte[] initVector,
                          @Param("value") byte[] value)
            throws InvokeException {
        try {
            return AES.decrypt(key, initVector, value);
        } catch (InvalidKeyException | IllegalBlockSizeException e) {
            throw new InvokeException(e);
        }
    }
}
