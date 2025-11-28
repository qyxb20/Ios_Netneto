//
//  ClassContentModel.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "ClassContentModel.h"

@implementation ClassContentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"productId":@"id",
             };
}
@end
