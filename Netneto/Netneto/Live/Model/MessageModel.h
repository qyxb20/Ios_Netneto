//
//  MessageModel.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/8.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : BaseModel
/** 是否是管理员  */
@property (nonatomic, assign) BOOL isAdmin;
/** 消息内容  */
@property (nonatomic, copy) NSString *message;
/** 消息类型
 0 普通消息
 1 进入直播间消息
 2 离开直播间消息
 3 禁言
 4 解禁
 5 主播离开
 6 主播回来
 7 发送在线人数
 8 设置管理员
 9 取消管理员
 10 直播公告
 
 */
@property (nonatomic, assign) NSInteger messageType;
/** 消息发送人  */
@property (nonatomic, copy) NSDictionary *senderUser;

@property (nonatomic, copy) NSArray *recipientUserList;

@end

NS_ASSUME_NONNULL_END
