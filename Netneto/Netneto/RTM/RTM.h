//
//  RTM.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MessageModel;
@interface RTM : NSObject<AgoraRtmClientDelegate>

+ (RTM *)sharedRtmTool;

@property (nonatomic, strong) AgoraRtmClientKit *rtmKit;

@property (nonatomic, copy, nullable) void (^joinChannelSuccessBlock) (NSString *channel);
@property (nonatomic, copy, nullable) void (^leaveChannelSuccessBlock) (NSString *channel);
@property (nonatomic, copy, nullable) void (^didReceiveMessageBlock) (MessageModel *model);
@property(nonatomic, strong)NSString *channel;
- (void)initRtm;
- (void)uninitRtm;
- (void)joinChannel:(NSString *)channel;
- (void)leaveChannel:(NSString *)channel;
- (void)leaveAllChannel;
- (void)loginRtm:(BOOL)isRelogin channel:(NSString *)channel;
- (void)signoutRtm;
- (void)getRtmTokenwithChannel:(NSString *)channel Succes:(void (^)(NSString *token))block;
- (void)sendMessageWithDictionary:(NSDictionary *)dic withChannel:(NSString *)channel;
-(void)getOnlineUserCountWithChannel:(NSString*)channel Success:(void (^)(NSString *num))block;
@end

NS_ASSUME_NONNULL_END
