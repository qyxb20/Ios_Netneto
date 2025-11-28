//
//  ShopCarModel.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/26.
//

#import "ShopCarModel.h"

@implementation ShopCarModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.prodId = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"prodId"]]] ;
        self.shopId = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"shopId"]]];
        self.skuId = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"skuId"]]];
        self.shopName = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"shopName"]]];
        self.prodName = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"prodName"]]];
        
        self.pic = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"pic"]]];
        self.productTotalAmount = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"productTotalAmount"]]];
        self.price = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"price"]]];
        self.basketId = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"basketId"]]];
        self.actualTotal = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"actualTotal"]]];
        self.oriPrice = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"oriPrice"]]];
        
        self.basketDate = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"basketDate"]]];
        self.skuName = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"skuName"]]];
        self.prodCount = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"prodCount"]]];
        self.stocks = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"stocks"]]];
        self.selectedState = [NSNumber numberWithBool:NO];
        self.limitSum = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"limitSum"]]];
           }
   
    return self;
}

-(instancetype)modelWithDic:(NSDictionary *)dic{
    ShopCarModel *model = [[ShopCarModel alloc] initWithDic:dic];
    return model;
}
@end
