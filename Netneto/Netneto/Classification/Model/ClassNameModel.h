//
//  ClassNameModel.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassNameModel : BaseModel
/** 商品分类id */
@property (nonatomic, copy) NSString *categoryId;
/** 商品名称 */
@property (nonatomic, copy) NSString *categoryName;
/** 商品图片 */
@property (nonatomic, copy) NSString *pic;
/** 父ID */
@property (nonatomic, copy) NSString *parentId;
/** 是否被选中 */
@property (nonatomic, assign) BOOL isSeleced;

@end

NS_ASSUME_NONNULL_END
