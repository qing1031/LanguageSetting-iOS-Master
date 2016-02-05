//
// OpenSecurityGuardSDK version 2.1.0
//

#ifndef OpenSecurityGuardSDK_IOpenDynamicDataEncryptComponent_h
#define OpenSecurityGuardSDK_IOpenDynamicDataEncryptComponent_h



/**
 *  动态存储接口
 */
@protocol IOpenDynamicDataEncryptComponent <NSObject>



/**
 *  动态加密字符串值
 *
 *  @param key string值对应的key
 *
 *  @return 返回加密结果，加密失败返回nil
 */
- (NSString*) dynamicEncrypt: (NSString*) plainText;


/**
 *  动态解密字符串值
 *
 *  @param cipherText string需要解密的字符串值
 *
 *  @return 返回解密结果，解密失败返回nil
 */
- (NSString*) dynamicDecrypt: (NSString*) cipherText;

/**
 *  动态加密byte数组
 *
 *  @param plainByteArray 待加密的byte数组
 *
 *  @return 返回加密结果，加密失败返回nil
 */
- (NSData*) dynamicEncryptByteArray: (NSData*) plainByteArray;


/**
 *  动态解密byte数组
 *
 *  @param plainByteArray 需要解密的byte数组
 *
 *  @return 返回解密结果，解密失败返回nil
 */
- (NSData*) dynamicDecryptByteArray: (NSData*) cipherByteArray;

@end

#endif
