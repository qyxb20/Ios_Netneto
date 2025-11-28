//
//  RTC.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <Foundation/Foundation.h>
#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^rtcSuccessBlock)(NSInteger code,NSString *msg);
@interface RTC : NSObject<AgoraRtcEngineDelegate,AgoraVideoFrameDelegate,CXCallObserverDelegate>

+ (RTC *)sharedRTCTool;

@property (nonatomic, strong) AgoraRtcEngineKit *rtcKit;

@property (nonatomic, copy, nullable) void (^joinChannelSuccessBlock) (NSInteger uid);
@property (nonatomic, copy, nullable) void (^leaveChannelSuccessBlock) (NSInteger uid);
@property (nonatomic, copy, nullable) void (^didAudioMutedBlock) (NSInteger uid,BOOL ismute);
@property (nonatomic, copy, nullable) void (^KitOutBlock) (void);
@property (nonatomic, copy, nullable) void (^reportAudioVolumeIndicationOfSpeakersBlock) (NSInteger uid,BOOL isPlayAnimate);
@property (nonatomic, copy, nullable) void (^remoteUserJoinChannelBlock) (NSInteger uid);
@property (nonatomic, copy, nullable) void (^RtcChangeToStateBlock) (AgoraConnectionChangedReason reason);
@property (nonatomic, copy, nullable) void (^actorLeaveBlock) (void);
@property (nonatomic, assign) AgoraClientRole role;
@property (nonatomic, assign) BOOL isMute;
@property (nonatomic, assign) BOOL isUpmic;
@property (nonatomic, assign) BOOL isTorch;

@property (nonatomic, strong) UIView *localPreview;
/// 垫片url
@property (nonatomic, copy, nullable) NSString *virtualBgUrl;

- (void)joinChannel:(NSString *)channelId token:(NSString *)rtcToken role:(AgoraClientRole)role codeBloc:(rtcSuccessBlock)isSuccess;
- (void)leaveChannel;
- (void)startPreview;
- (void)stopPreview;
- (void)setRemoteViewWithUser:(NSInteger)userId remoteView:(UIView *)remoteView;
- (void)setRemoteViewWithUid:(NSInteger)userId view:(UIView *)view showType:(NSString *)showtype;
- (void)setLocalVideoEnable:(BOOL)enable;
- (void)destroyAgora;

/// 开启或关闭垫片
- (int)openVirtualBackground:(NSString * _Nullable)url;

/// 切换摄像头
- (void)switchCamera;
/// 切换镜像
- (void)openOrCloseMirror;
/// 闪光灯
- (void)swithTorch;


@end

NS_ASSUME_NONNULL_END
