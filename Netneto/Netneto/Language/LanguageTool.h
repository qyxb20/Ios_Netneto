//
//  LanguageTool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageTool : NSObject
+(id)shareInstance;
-(NSString *)getLangStringForKey:(NSString *)key withList:(NSString *)list;

-(void)resetLanguageStr:(NSString*)languagestr withFrom:(NSString *)appdelegate;

@end

NS_ASSUME_NONNULL_END
