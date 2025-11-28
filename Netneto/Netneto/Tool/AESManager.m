//
//  AESManager.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/21.
//

#import "AESManager.h"


static NSString* const encrykey = @"-mall4j-password";

@implementation AESManager
#pragma mark - 加密
+ (NSString *)encrypt:(NSString *)text key:(NSString *)key {
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    const void *bytesOfData = data.bytes;
    NSUInteger lengthOfData = data.length;
    
    size_t bufferSize = lengthOfData + kCCBlockSizeAES128;
    unsigned char *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          bytesOfData,
                                          lengthOfData,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    
    free(buffer);
    
    return @"";
}

@end
