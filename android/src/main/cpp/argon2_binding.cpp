#include "argon2_binding.h"
#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jbyteArray JNICALL
Java_com_riguz_encryptions_cipher_Argon2_argon2iInternal(JNIEnv *env, jobject instance,
                                                         jint iterations, jint memory,
                                                         jint parallelism, jbyteArray password_,
                                                         jbyteArray salt_, jint hashLength) {
    jbyte *password = env->GetByteArrayElements(password_, NULL);
    jbyte *salt = env->GetByteArrayElements(salt_, NULL);
    jsize pwdSize = env->GetArrayLength(password_);
    jsize saltSize = env->GetArrayLength(salt_);

    Argon2 argon2(iterations, memory, parallelism, hashLength);
    uint8_t *hash = argon2.argon2i((uint8_t *) password, pwdSize, (uint8_t *) salt, saltSize);

    jbyteArray result = (*env).NewByteArray(hashLength);
    (*env).SetByteArrayRegion(result, 0, hashLength, (jbyte *) hash);

    env->ReleaseByteArrayElements(password_, password, 0);
    env->ReleaseByteArrayElements(salt_, salt, 0);

    return result;
}

extern "C" JNIEXPORT
jbyteArray JNICALL
Java_com_riguz_encryptions_cipher_Argon2_argon2dInternal(JNIEnv *env, jobject instance,
                                                         jint iterations, jint memory,
                                                         jint parallelism, jbyteArray password_,
                                                         jbyteArray salt_, jint hashLength) {
    jbyte *password = env->GetByteArrayElements(password_, NULL);
    jbyte *salt = env->GetByteArrayElements(salt_, NULL);
    jsize pwdSize = env->GetArrayLength(password_);
    jsize saltSize = env->GetArrayLength(salt_);

    Argon2 argon2(iterations, memory, parallelism, hashLength);
    uint8_t *hash = argon2.argon2d((uint8_t *) password, pwdSize, (uint8_t *) salt, saltSize);

    jbyteArray result = (*env).NewByteArray(hashLength);
    (*env).SetByteArrayRegion(result, 0, hashLength, (jbyte *) hash);

    env->ReleaseByteArrayElements(password_, password, 0);
    env->ReleaseByteArrayElements(salt_, salt, 0);

    return result;
}

