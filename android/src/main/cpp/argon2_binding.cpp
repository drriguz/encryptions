#include "argon2_binding.h"
#include <jni.h>
#include <string>


extern "C"
JNIEXPORT jbyteArray JNICALL
Java_com_riguz_encryptions_cipher_Argon2_argon2iInternal(JNIEnv *env, jobject instance, jint iterations,
                                                     jint memory, jint parallelism,
                                                     jstring password_, jstring salt_,
                                                     jint hashLength) {
    const char *password = env->GetStringUTFChars(password_, 0);
    const char *salt = env->GetStringUTFChars(salt_, 0);

    Argon2 argon2(iterations, memory, parallelism, hashLength);
    uint8_t *hash = argon2.argon2i(password, salt);

    jbyteArray result = (*env).NewByteArray(hashLength);
    (*env).SetByteArrayRegion(result, 0, hashLength, (jbyte*)hash);

    env->ReleaseStringUTFChars(password_, password);
    env->ReleaseStringUTFChars(salt_, salt);
    return result;
}

extern "C"
JNIEXPORT jbyteArray JNICALL
Java_com_riguz_encryptions_cipher_Argon2_argon2dInternal(JNIEnv *env, jobject instance, jint iterations,
                                                     jint memory, jint parallelism,
                                                     jstring password_, jstring salt_,
                                                     jint hashLength) {
    const char *password = env->GetStringUTFChars(password_, 0);
    const char *salt = env->GetStringUTFChars(salt_, 0);

    Argon2 argon2(iterations, memory, parallelism, hashLength);
    uint8_t *hash = argon2.argon2d(password, salt);
    jbyteArray result = (*env).NewByteArray(hashLength);
    (*env).SetByteArrayRegion(result, 0, hashLength, (jbyte*)hash);

    env->ReleaseStringUTFChars(password_, password);
    env->ReleaseStringUTFChars(salt_, salt);
    return result;
}