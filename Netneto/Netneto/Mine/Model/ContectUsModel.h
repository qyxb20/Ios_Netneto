//
//  ContectUsModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContectUsModel : BaseModel
///姓名
@property (nonatomic, copy) NSString *userName;
///昵称
@property (nonatomic, copy) NSString *nickName;
///邮箱
@property (nonatomic, copy) NSString *email;
///电话号码
@property (nonatomic, copy) NSString *contact;
///要件
@property (nonatomic, copy) NSString *topic;
///留言状态
@property (nonatomic, copy) NSString *status;
///留言内容
@property (nonatomic, copy) NSString *content;
///创建时间
@property (nonatomic, copy) NSString *createTime;
///回答内容
@property (nonatomic, copy) NSString *reply;

///回复时间
@property (nonatomic, copy) NSString *replyTime;
///id
@property (nonatomic, copy) NSString *idStr;
@end

NS_ASSUME_NONNULL_END
