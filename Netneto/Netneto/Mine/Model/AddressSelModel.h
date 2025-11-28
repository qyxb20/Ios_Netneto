//
//  AddressSelModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressSelModel : NSObject
///id
@property (nonatomic, assign) NSInteger areaId;
///名
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *areaNameHalfAngle;

@property (nonatomic, assign) BOOL selectedState;
-(instancetype)initWithDic:(NSDictionary *)dic;
-(instancetype)modelWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
