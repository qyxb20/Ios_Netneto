//
//  Socket.m
//  Netneto
//
//  Created by apple on 2025/1/2.
//

#import "Socket.h"
static Socket *_manager = nil;

@implementation Socket
+ (Socket *)sharedSocketTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[Socket alloc] init];
    });
    return _manager;
}
- (instancetype)init {
    if (self = [super init]) {
        [self initSocket];
    }
    return self;
}
-(void)initSocket{
    self.autoReconnect = YES;
    self.isLogin = NO;
//    self.websocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://netty.yueran.vip"]];
    self.websocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:SOCKETURL]];
      
    
  self.websocket.delegate = self;
  [self.websocket open];

}
#pragma mark -登录
-(void)loginSocket{
    if (account.isLogin) {
        NSLog(@"开始登录");
        if ([[NSString isNullStr:account.userInfo.nickName] length] == 0) {
            
//            [self loginSocket];
            return;
        }
        WebClientJoinReq *dic = [[WebClientJoinReq alloc] init];
         [dic setUserId:account.userInfo.userId];
         [dic setName:account.userInfo.nickName];
         [dic setUserImg:account.userInfo.pic];
         [dic setIsMerchant:[account.userInfo.merchant intValue]];
        
        NSLog(@"登录信息:%@\n%@\n%@\n%@",account.userInfo.userId,account.userInfo.nickName,account.userInfo.pic,account.userInfo.merchant);
      
         NSData* data = [dic data];
     
      ImMsgBody *immsg = [[ImMsgBody alloc] init];
      [immsg setMsgType:1];
      [immsg setBytesData:data];
     
      [self.websocket send:[immsg data]];
       
    }
    else{
        NSLog(@"不能登录");
        self.isLogin = NO;
    }
}
#pragma mark -心跳
-(void)heartbeatAction{
    WebClientHeartBeatReq *dic = [[WebClientHeartBeatReq alloc] init];
     [dic setUserId:account.userInfo.userId];
    [dic setImChannel:@""];
    
     NSData* data = [dic data];
 
  ImMsgBody *immsg = [[ImMsgBody alloc] init];
  [immsg setMsgType:4];
  [immsg setBytesData:data];
 
  [self.websocket send:[immsg data]];
   
}
#pragma mark -获取聊天列表
-(void)getImmsgList{
    MsgListReq *dic = [[MsgListReq alloc] init];
    [dic setUserId:account.userInfo.userId];
    NSData* data = [dic data];

 ImMsgBody *immsg = [[ImMsgBody alloc] init];
 [immsg setMsgType:100];
 [immsg setBytesData:data];

 [self.websocket send:[immsg data]];

}
#pragma mark -获取发货列表
-(void)getDvyMsgList:(NSInteger)pageNum pagesize:(NSInteger)pageSize{
    DvyMsgListReq *dic = [[DvyMsgListReq alloc] init];
    [dic setUserId:account.userInfo.userId];
    [dic setPageNum:pageNum];
    [dic setPageSize:pageSize];
    NSData* data = [dic data];

 ImMsgBody *immsg = [[ImMsgBody alloc] init];
 [immsg setMsgType:10002];
 [immsg setBytesData:data];

 [self.websocket send:[immsg data]];

}
#pragma mark -获取发货详情
-(void)getImDvyMsgInfo:(NSInteger)pageNum pagesize:(NSInteger)pageSize channel:(NSString *)imChannel{
    ImDvyMsgInfoReq *dic = [[ImDvyMsgInfoReq alloc] init];
    [dic setUserId:account.userInfo.userId];
    [dic setImChannelId:imChannel];
    [dic setPageNum:pageNum];
    [dic setPageSize:pageSize];
    NSData* data = [dic data];

 ImMsgBody *immsg = [[ImMsgBody alloc] init];
 [immsg setMsgType:10004];
 [immsg setBytesData:data];

 [self.websocket send:[immsg data]];

}

#pragma mark -获取退货列表
-(void)getRefundMsgList:(NSInteger)pageNum pagesize:(NSInteger)pageSize{
    RefundMsgListReq *dic = [[RefundMsgListReq alloc] init];
    [dic setUserId:account.userInfo.userId];
    [dic setPageNum:pageNum];
    [dic setPageSize:pageSize];
    NSData* data = [dic data];

 ImMsgBody *immsg = [[ImMsgBody alloc] init];
 [immsg setMsgType:11002];
 [immsg setBytesData:data];

 [self.websocket send:[immsg data]];

}
#pragma mark -获取退款详情
-(void)ImRefundMsgInfo:(NSInteger)pageNum pagesize:(NSInteger)pageSize channel:(NSString *)imChannel{
    ImRefundMsgInfoReq *dic = [[ImRefundMsgInfoReq alloc] init];
    [dic setUserId:account.userInfo.userId];
    [dic setImChannelId:imChannel];
    [dic setPageNum:pageNum];
    [dic setPageSize:pageSize];
    NSData* data = [dic data];

 ImMsgBody *immsg = [[ImMsgBody alloc] init];
 [immsg setMsgType:11004];
 [immsg setBytesData:data];

 [self.websocket send:[immsg data]];

}
#pragma mark -获取聊天记录
-(void)getMsgRecordList:(NSString *)imsgChannel page:(int)page userid:(NSString *)userId{
    MsgRecordReq *im = [[MsgRecordReq alloc] init];
    [im setImChannel:imsgChannel];
    [im setUserId:userId];
    [im setPageNum:page];
    [im setPageSize:100];
    NSData* data = [im data];

 ImMsgBody *immsg = [[ImMsgBody alloc] init];
 [immsg setMsgType:103];
 [immsg setBytesData:data];

    [self.websocket send:[immsg data]];

}
#pragma mark -加入房间
-(void)JoinRoomReq:(NSString *)imChannel shopId:(NSString *)shopId userId:(NSString *)UserId toUserid:(NSString *)toUserId fromUserId:(NSString *)fromUserId name:(NSString *)name userImg:(NSString *)userImg{
    RoomJoinReq *dic = [[RoomJoinReq alloc] init];
    [dic setShopId:[shopId intValue]];
    [dic setImChannel:imChannel];
    [dic setUserId:UserId];
//    self.dataDic[@"shopUserId"]
    [dic setToUserId:toUserId];
    [dic setFromUserId:fromUserId];
    [dic setName:name];
    [dic setUserImg:userImg];
    NSData* data = [dic data];

   ImMsgBody *immsg = [[ImMsgBody alloc] init];
   [immsg setMsgType:6];
   [immsg setBytesData:data];

    [self.websocket send:[immsg data]];

}
#pragma mark -发送消息
-(void)sendMess:(NSString *)content FromUserId:(NSString *)formUserId toUserId:(NSString *)toUserId  contentType:(int)contentType imsgChannel:(NSString *)imsgChannel{
    ImMsg *im = [[ImMsg alloc] init];
    [im setImChannel:imsgChannel];
    [im setFromUserId:formUserId];
    [im setToUserId:toUserId];
    [im setContent:content];
    [im setCreateTime:[Tool getCurtenTimeStrWithString]];
    [im setReadStatus:0];
    [im setContentType:contentType];
    NSData* data = [im data];
 
    ImMsgBody *immsg = [[ImMsgBody alloc] init];
    [immsg setMsgType:105];
    [immsg setBytesData:data];

    [self.websocket send:[immsg data]];

}
#pragma mark -发送链接
-(void)sendLink:(NSDictionary *)dataDic FromUserId:(NSString *)formUserId toUserId:(NSString *)toUserId imsgChannel:(NSString *)imsgChannel selDic:(NSDictionary *)selDic{
    prodMsg *im = [[prodMsg alloc] init];
    [im setImChannel:imsgChannel];
    [im setFromUserId:formUserId];
    [im setToUserId:toUserId];
    [im setProdId:[dataDic[@"prodId"] intValue]];
    [im setProdName:dataDic[@"prodName"]];
    [im setSkuName:selDic[@"skuName"]];
    [im setPrice:[selDic[@"price"] intValue]];
    [im setProdImg:selDic[@"pic"]];

    [im setReadStatus:0];
    NSData* data = [im data];

 ImMsgBody *immsg = [[ImMsgBody alloc] init];
 [immsg setMsgType:108];
 [immsg setBytesData:data];

    [self.websocket send:[immsg data]];

}
#pragma mark -发送词条
-(void)sendLabelInfo:(NSInteger)imLabelId{
    MsgLabelInfoReq *dic = [[MsgLabelInfoReq alloc] init];
    [dic setImLabelId:imLabelId];
      NSData* data = [dic data];

   ImMsgBody *immsg = [[ImMsgBody alloc] init];
   [immsg setMsgType:111];
   [immsg setBytesData:data];

    [self.websocket send:[immsg data]];

}
#pragma mark -删除聊天列表
-(void)deleMsgList:(NSString *)imsgChannel userId:(NSString *)userId{
   
    MsgListDeletedReq *dic = [[MsgListDeletedReq alloc] init];
     [dic setUserId:userId];
    [dic setImChannel:imsgChannel];
    
     NSData* data = [dic data];
 
  ImMsgBody *immsg = [[ImMsgBody alloc] init];
  [immsg setMsgType:102];
  [immsg setBytesData:data];
 
    [self.websocket send:[immsg data]];
}
#pragma mark -删除发货列表
-(void)DvyListDelete:(NSString *)imsgChannel userId:(NSString *)userId page:(int)page pagesize:(NSInteger)pageSize{
   
    DvyListDeleteReq *dic = [[DvyListDeleteReq alloc] init];
     [dic setUserId:userId];
    [dic setImChannelId:imsgChannel];
    [dic setPageNum:page];
    [dic setPageSize:pageSize];
     NSData* data = [dic data];
 
  ImMsgBody *immsg = [[ImMsgBody alloc] init];
  [immsg setMsgType:10006];
  [immsg setBytesData:data];
 
    [self.websocket send:[immsg data]];
}
#pragma mark -删除退款列表
-(void) RefundListDelete:(NSString *)imsgChannel userId:(NSString *)userId page:(int)page pagesize:(NSInteger)pageSize{
   
    RefundListDeleteReq *dic = [[RefundListDeleteReq alloc] init];
     [dic setUserId:userId];
    [dic setImChannelId:imsgChannel];
    [dic setPageNum:page];
    [dic setPageSize:pageSize];
     NSData* data = [dic data];
 
  ImMsgBody *immsg = [[ImMsgBody alloc] init];
  [immsg setMsgType:11006];
  [immsg setBytesData:data];
 
    [self.websocket send:[immsg data]];
}
#pragma mark -离开房间
-(void)leaveRoom:(NSString *)imsgChannel userId:(NSString *)userId{
    RoomLeaveReq *leve = [[RoomLeaveReq alloc] init];
    [leve setImChannel: imsgChannel];
    [leve setUserId:userId];
    NSData* data = [leve data];

   ImMsgBody *immsg = [[ImMsgBody alloc] init];
   [immsg setMsgType:8];
   [immsg setBytesData:data];

    [self.websocket send:[immsg data]];
}
#pragma mark -退出socket
-(void)LeaveSocket:(NSString *)userId{
    self.autoReconnect = NO;
    
    WebClientLeaveReq *im = [WebClientLeaveReq alloc];
    [im setUserId:userId];
    NSData* data = [im data];

   ImMsgBody *immsg = [[ImMsgBody alloc] init];
   [immsg setMsgType:3];
   [immsg setBytesData:data];
    [self.websocket send:[immsg data]];
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(NSData *)data{
    NSLog(@"收到消息数据data:%@",data);
    ImMsgBody *body = [ImMsgBody parseFromData:data error:nil];
   
    if (body.msgType == 2) {
        self.isLogin = YES;
        NSLog(@"登录成功");
    }
    NSLog(@"消息类型：%d",body.msgType);
//    if (body.msgType == 2 || body.msgType == 102 || body.msgType == 107 || body.msgType == 110) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadMsg" object:nil userInfo:nil];
    if (body.msgType == 11001) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadRefunMsg" object:nil userInfo:nil];
    }
    if (body.msgType == 10001) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadOrderMsg" object:nil userInfo:nil];
    }
    if ( body.msgType == 107 || body.msgType == 110 || body.msgType == 106) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadSixinMsg" object:nil userInfo:nil];
    }
//    }
    
    ExecBlock(self.didReceiveMessageBlock,data);
}

    // 打开websocket成功的回调
 - (void)webSocketDidOpen:(SRWebSocket *)webSocket{
     NSLog(@"连接成功");
     self.autoReconnect = YES;
     [self loginSocket];
     [self heartbeatAction];
    
     self.heatBeat = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(heartbeatAction) userInfo:nil repeats:YES];
     [self.heatBeat setFireDate:[NSDate distantPast]];
     [[NSRunLoop currentRunLoop] addTimer:_heatBeat forMode:NSRunLoopCommonModes];


        
 }
    // 发生错误的回调
 - (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
        NSLog(@"连接失败");
     self.autoReconnect = NO;
    }

 // websocket关闭的回调
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    self.autoReconnect = NO;
    self.isLogin = NO;
    [self.heatBeat invalidate];
    self.heatBeat = nil;
    
    NSLog(@"关闭");
    [account loadResource];
}
    //  来着服务器pong消息
 - (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
        
    }
@end
