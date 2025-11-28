//
//  RTM.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "RTM.h"


static RTM *_manager = nil;

@interface RTM ()

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSMutableArray *channelMarr;

@end
@implementation RTM
+ (RTM *)sharedRtmTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[RTM alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initRtm];
    }
    return self;
}

- (void)initRtm {
    
    if ([account.user.userId isEqual:@"-9999"] || account.user.userId.length <= 0) {
        return;
        

    }
        AgoraRtmClientConfig *rtm_config = [[AgoraRtmClientConfig alloc] initWithAppId:AgoraAppId userId:account.user.userId];
        _rtmKit = [[AgoraRtmClientKit alloc] initWithConfig:rtm_config delegate:self error:nil];
        /// 私有参数 拉长rtm超时时间
        [_rtmKit setParameters:@"{\"rtm.channel.join_limit\":[2000,5]}"];
    
}

- (void)uninitRtm {
    [self leaveAllChannel];
    [self signoutRtm];
    [self.rtmKit destroy];
    _rtmKit = nil;
    _isLogin = NO;
}

- (void)getRtmTokenwithChannel:(NSString *)channel Succes:(void (^)(NSString *token))block {
    [NetwortTool getRoomRtmTokenWithChannel:channel Success:^(id  _Nonnull responseObject) {
        NSString *rtmToken = [NSString stringWithFormat:@"%@",responseObject[@"rtmToken"]];
        NSLog(@"rtmToken:%@",rtmToken);
        if (rtmToken.length > 0) {
            block(rtmToken);
        }else {
            block(@"");
            [self getRtmTokenwithChannel:channel Succes:^(NSString * _Nonnull token) {
                
            
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
   
}

- (void)loginRtm:(BOOL)isRelogin channel:(NSString *)channel {
    if (account.userInfo.userId.length <= 0) {
        return;
    }
    if (!_rtmKit) {
        [self initRtm];
    }
    @weakify(self)
    [self getRtmTokenwithChannel:channel Succes:^(NSString * _Nonnull token) {
       
     @strongify(self)
        if (token.length > 0) {
            [self.rtmKit loginByToken:token completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
                @strongify(self)
                
                if (errorInfo.errorCode == AgoraRtmErrorOk) {
                    self.isLogin = YES;
                    [self joinChannel:channel];
//                    if (isRelogin) {
//                        [self joinChannelAgain];
//                    }
                }
            }];
        }
    }];
}

- (void)signoutRtm {
    @weakify(self)
    [_rtmKit logout:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        @strongify(self)
        self.isLogin = NO;
    }];
}

- (void)connectRtmAgain {
//    if (self.isLogin) {
//        return;
//    }
    @weakify(self)
    [_rtmKit logout:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
           @strongify(self)
        if (errorInfo.errorCode != AgoraRtmErrorOk) {
            return;
        }
//        [self loginRtm:YES];
    }];
}

- (void)joinChannel:(NSString *)channel {
    AgoraRtmSubscribeOptions *option = [[AgoraRtmSubscribeOptions alloc] init];
    option.features = AgoraRtmSubscribeChannelFeatureMetadata | AgoraRtmSubscribeChannelFeatureMessage;
    @weakify(self)
    
    [_rtmKit subscribeWithChannel:channel option:option completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        NSLog(@"返回值：%ld",(long)errorInfo.code);
        @strongify(self)
        if ((errorInfo.code == AgoraRtmErrorChannelSubscribeFailed || errorInfo.code == AgoraRtmErrorChannelSubscribeTimeout) && self.isLogin) {
            [self.rtmKit unsubscribeWithChannel:channel completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
                @strongify(self)
                if (errorInfo.code == AgoraRtmErrorOk) {
                    [self joinChannel:channel];
                }
            }];
        }else if (errorInfo.errorCode == AgoraRtmErrorOk) {
            if (![self.channelMarr containsObject:channel]) {
                [self.channelMarr addObject:channel];
            }
            ExecBlock(self.joinChannelSuccessBlock,channel);
        }
    }];
}

- (void)joinChannelAgain {
    [self.channelMarr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self joinChannel:obj];
    }];
}

- (void)leaveChannel:(NSString *)channel {
    @weakify(self)
    [_rtmKit unsubscribeWithChannel:channel completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        @strongify(self)
        if (errorInfo.errorCode == AgoraRtmErrorOk) {
            if ([self.channelMarr containsObject:channel]) {
                [self.channelMarr removeObject:channel];
            }
            ExecBlock(self.leaveChannelSuccessBlock,channel);
        }
    }];
}

- (void)leaveAllChannel {
    [[_rtmKit getPresence] whereNow:account.userInfo.userId completion:^(AgoraRtmWhereNowResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        if (errorInfo.errorCode != AgoraRtmErrorOk) {
            return;
        }
        NSArray<AgoraRtmChannelInfo *> *arr = response.channels;
        [arr enumerateObjectsUsingBlock:^(AgoraRtmChannelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self leaveChannel:obj.channelName];
        }];
    }];
}

- (void)rtmKit:(AgoraRtmClientKit *)rtmKit tokenPrivilegeWillExpire:(NSString *)channel {
    @weakify(self)
    [self getRtmTokenwithChannel:channel Succes:^(NSString * _Nonnull token) {
        
     @strongify(self)
        if (token.length > 0) {
            [self.rtmKit renewToken:token completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
            }];
        }
    }];
}

- (void)sendMessageWithDictionary:(NSDictionary *)dic withChannel:(NSString *)channel {
    
    NSString *json = [dic mj_JSONString];
    NSLog(@"发送消息字符串:%@",json);
    AgoraRtmPublishOptions *option = [[AgoraRtmPublishOptions alloc] init];
    option.channelType = AgoraRtmChannelTypeMessage;
    option.customType = @"PlainText";
    
    [self.rtmKit publish:channel message:json option:option completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        NSLog(@"sendMessageWithDictionary == %ld",(long)errorInfo.errorCode);
    }];
}

#pragma mark-获取在线人数
-(void)getOnlineUserCountWithChannel:(NSString*)channel Success:(void (^)(NSString *num))block{
    AgoraRtmSubscribeOptions *option = [[AgoraRtmSubscribeOptions alloc] init];
    option.features = AgoraRtmSubscribeChannelFeatureMetadata | AgoraRtmSubscribeChannelFeatureMessage;
 
    AgoraRtmPresence *presence = [self.rtmKit getPresence];
    [presence whoNow:channel channelType:AgoraRtmChannelTypeMessage options:nil completion:^(AgoraRtmWhoNowResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        if (errorInfo.errorCode == AgoraRtmErrorOk) {
            NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)response.userStateList.count];
            block(str);
        }
        
    }];
      
}
- (void)rtmKit:(AgoraRtmClientKit *)rtmKit didReceiveMessageEvent:(AgoraRtmMessageEvent *)event {
    NSMutableDictionary *dic = [event.message.stringData mj_JSONObject];
    NSLog(@"收到rtm消息：%@",dic);
//    收到rtm消息：{
//        isAdmin = 0;
//        message = "";
//        messageType = 1;//谁来了
//        senderUser =     {
//            userId = 158faa43372b4a648d9eb01b0864d394;
//            userName = jinchuan1023;
//        };
//    }
//    收到rtm消息：{
//        isAdmin = 0;
//        message = "\U7684\U5730\U65b9";
//        messageType = 0;//发送消息
//        senderUser =     {
//            userId = 158faa43372b4a648d9eb01b0864d394;
//            userName = jinchuan1023;
//        };
//    }
//    if ([[dic allKeys] containsObject:@"message"]) {
//        dic = [dic[@"type"] mj_JSONObject];
//    }
     MessageModel *model = [MessageModel mj_objectWithKeyValues:dic];
  
    ExecBlock(self.didReceiveMessageBlock,model);
    
}

- (void)rtmKit:(AgoraRtmClientKit *)kit channel:(NSString *)channelName connectionChangedToState:(AgoraRtmClientConnectionState)state reason:(AgoraRtmClientConnectionChangeReason)reason {
    if (reason == AgoraRtmClientConnectionChangedSameUidLogin) {
        
        return;
    }
    switch (state) {
        case AgoraRtmClientConnectionStateFailed:
            [self showDownLoadLog:[NSString stringWithFormat:@"rtm加入失败\n channelName：%ld",(long)reason]];
        case AgoraRtmClientConnectionStateDisconnected:
            self.isLogin = NO;
            [self showDownLoadLog:[NSString stringWithFormat:@"rtm链接断开了,开始重连\nchannelName：%ld",(long)reason]];
            if (reason != AgoraRtmClientConnectionChangedLogout) {
//                [self reconnectRtm];
            }
            break;
        case AgoraRtmClientConnectionStateConnecting:
            [self showDownLoadLog:[NSString stringWithFormat:@"rtm正在连接...\nchannelName：%ld",(long)reason]];
            break;
        case AgoraRtmClientConnectionStateConnected:
            [self showDownLoadLog:[NSString stringWithFormat:@"rtm已经连接\n：%ld",(long)reason]];
            break;
        case AgoraRtmClientConnectionStateReconnecting:
//            self.times += 1;
//            [self showDownLoadLog:self.times > 10 ? [NSString stringWithFormat:@"rtm开始重连了,第%ld次,换个网络再试吧!!\n",self.times] : [NSString stringWithFormat:@"rtm开始重连了,第%ld次\n",self.times]];
            break;
        default:
            break;
    }
    NSLog(@"connectionChangedToState\n state:%ld\nreason:%ld",state,reason);
}
- (void)showDownLoadLog:(NSString *)message {
    NSLog(@"rtm连接信息：%@",message);
}
- (NSMutableArray *)channelMarr {
    if (!_channelMarr) {
        _channelMarr = [NSMutableArray array];
    }
    return _channelMarr;
}

@end
