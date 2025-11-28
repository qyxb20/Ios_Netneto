//
//  ImageModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat  imageH;
-(void)setmyframe:(ImageModel *)model;

-(instancetype)initWithDic:(NSString *)usrlStr;
-(instancetype)modelWithDic:(NSString *)usrlStr;

@end

NS_ASSUME_NONNULL_END
