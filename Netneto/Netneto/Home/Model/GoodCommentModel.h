//
//  GoodCommentModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodCommentModel : NSObject
/** 评论id */
@property (nonatomic, copy) NSString *prodCommId;
/** 得分 */
@property (nonatomic, copy) NSString *score;
/** 掌柜回复 */
@property (nonatomic, copy) NSString *replyContent;
/** 记录时间 */
@property (nonatomic, copy) NSString *recTime;
/** 用户昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 评论内容 */
@property (nonatomic, copy) NSString *content;
/** 评论图品 */
@property (nonatomic, copy) NSString *pics;
/** 用户头像 */
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) CGFloat  rowH;
@property (nonatomic, assign) CGFloat  imgH;
@property (nonatomic, assign) CGFloat  replyH;
-(instancetype)initWithDic:(NSDictionary *)dic;
-(instancetype)modelWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
