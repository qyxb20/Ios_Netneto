//
//  Socket.h
//  Netneto
//
//  Created by apple on 2025/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Socket : NSObject<SRWebSocketDelegate>
+ (Socket *)sharedSocketTool;
@property (strong, nonatomic) NSTimer *heatBeat;
@property (nonatomic, strong) SRWebSocket *websocket;
@property (nonatomic, copy, nullable) void (^LoginSuccessBlock) (void);
@property (nonatomic, copy, nullable) void (^leaveSocketSuccessBlock) (void);
@property (nonatomic, copy, nullable) void (^didReceiveMessageBlock) (NSData *data);
@property (nonatomic,assign) BOOL autoReconnect;//是否已连接
@property (nonatomic,assign) BOOL isLogin;//是否登录
- (void)initSocket;
- (void)uninitSocket;
-(void)loginSocket;

#pragma mark -获取聊天列表
-(void)getImmsgList;
#pragma mark -获取发货列表列表
-(void)getDvyMsgList:(NSInteger)pageNum pagesize:(NSInteger)pageSize;
#pragma mark -获取发货详情
-(void)getImDvyMsgInfo:(NSInteger)pageNum pagesize:(NSInteger)pageSize channel:(NSString *)imChannel;
#pragma mark -获取退货列表
-(void)getRefundMsgList:(NSInteger)pageNum pagesize:(NSInteger)pageSize;
#pragma mark -获取退款详情
-(void)ImRefundMsgInfo:(NSInteger)pageNum pagesize:(NSInteger)pageSize channel:(NSString *)imChannel;
#pragma mark -获取聊天记录
-(void)getMsgRecordList:(NSString *)imsgChannel page:(int)page userid:(NSString *)userId;
#pragma mark -发送消息
-(void)sendMess:(NSString *)content FromUserId:(NSString *)formUserId toUserId:(NSString *)toUserId  contentType:(int)contentType imsgChannel:(NSString *)imsgChannel;
#pragma mark -发送链接
-(void)sendLink:(NSDictionary *)dataDic FromUserId:(NSString *)formUserId toUserId:(NSString *)toUserId imsgChannel:(NSString *)imsgChannel selDic:(NSDictionary *)selDic;
#pragma mark -发送词条
-(void)sendLabelInfo:(NSInteger)imLabelId;
#pragma mark -删除聊天列表
-(void)deleMsgList:(NSString *)imsgChannel userId:(NSString *)userId;
#pragma mark -删除发货列表
-(void)DvyListDelete:(NSString *)imsgChannel userId:(NSString *)userId page:(int)page pagesize:(NSInteger)pageSize;
#pragma mark -删除退款列表
-(void) RefundListDelete:(NSString *)imsgChannel userId:(NSString *)userId page:(int)page pagesize:(NSInteger)pageSize;
#pragma mark -加入房间
-(void)JoinRoomReq:(NSString *)imChannel shopId:(NSString *)shopId userId:(NSString *)UserId toUserid:(NSString *)toUserId fromUserId:(NSString *)fromUserId name:(NSString *)name userImg:(NSString *)userImg;
#pragma mark -离开房间
-(void)leaveRoom:(NSString *)imsgChannel userId:(NSString *)userId;
#pragma mark -退出socket
-(void)LeaveSocket:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
