//
//  AESManager.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESManager : NSObject
///aes加密
+ (NSString *)encrypt:(NSString *)text key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
