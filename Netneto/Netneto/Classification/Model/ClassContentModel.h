//
//  ClassContentModel.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassContentModel : BaseModel
/** 分类id */
@property (nonatomic, copy) NSString *categoryId;
/** 分类名称 - 商品名称 */
@property (nonatomic, copy) NSString *categoryName;
/** 分类图片地址 - 商品图片地址 */
@property (nonatomic, copy) NSString *pic;

@end

NS_ASSUME_NONNULL_END
