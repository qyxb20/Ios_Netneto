//
//  RTC.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "RTC.h"

static RTC *_manager = nil;

@interface RTC ()

@property (nonatomic, strong) AgoraVideoEncoderConfiguration *encoderConfig;


@end
@implementation RTC
+ (RTC *)sharedRTCTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[RTC alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"init rtc");
      
        _rtcKit = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraAppId delegate:self];
        _encoderConfig = [[AgoraVideoEncoderConfiguration alloc] initWithSize:AgoraVideoDimension1280x720 frameRate:AgoraVideoFrameRateFps15 bitrate:AgoraVideoBitrateStandard orientationMode:AgoraVideoOutputOrientationModeFixedPortrait mirrorMode:AgoraVideoMirrorModeEnabled];
        [_rtcKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        [_rtcKit setVideoEncoderConfiguration:_encoderConfig];
        [_rtcKit setDefaultAudioRouteToSpeakerphone:YES];
        [_rtcKit enableAudioVolumeIndication:2 smooth:3 reportVad:YES];
        [_rtcKit enableAudio];
        [_rtcKit enableVideo];
        [_rtcKit setVideoFrameDelegate:self];
        // 画面秒出关键帧
        [_rtcKit setParameters:@"{\"che.video.keyFrameInterval\":1"];
    }
    return self;
}

- (void)joinChannel:(NSString *)channelId token:(NSString *)rtcToken role:(AgoraClientRole)role codeBloc:(rtcSuccessBlock)isSuccess{
    NSLog(@"ChannelName:%@---%@----%@",rtcToken,channelId,account.userInfo.uid);

    int r = [self.rtcKit joinChannelByToken:rtcToken channelId:channelId info:nil uid:account.userInfo.uid.integerValue joinSuccess:nil];
 
    NSLog(@"joinChannel===%d,channelid: %@, token: %@",r,channelId,rtcToken);
    isSuccess(r,channelId);
    [self.rtcKit setClientRole:role];
}

- (void)leaveChannel {
    [self.rtcKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
    }];
    self.virtualBgUrl = nil;
}
- (void)destroyAgora {
    [AgoraRtcEngineKit destroy];
    
}

- (void)startPreview {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = account.userInfo.userId.integerValue;
    videoCanvas.view = self.localPreview;
    
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    
    AgoraBeautyOptions *beauty = [[AgoraBeautyOptions alloc] init];
    [beauty setLighteningLevel: 0.6];
    [beauty setLighteningContrastLevel:2];
    [beauty setSmoothnessLevel:0.6];
    [beauty setRednessLevel:0.6];
    [self.rtcKit setBeautyEffectOptions:YES options:beauty];
    [self.rtcKit setupLocalVideo:videoCanvas];
     [self.rtcKit startPreview];
    
}
- (void)setRemoteViewWithUid:(NSInteger)userId view:(UIView *)view showType:(NSString *)showtype {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = userId;
    videoCanvas.view = view;
    if ([showtype isEqual:@"1"] || [showtype isEqual:@"0"]) {
        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    }else{
        videoCanvas.renderMode = AgoraVideoRenderModeFit;
        videoCanvas.mirrorMode =AgoraVideoMirrorModeEnabled;
    }
   
    [self.rtcKit setupRemoteVideo:videoCanvas];
}
- (void)stopPreview {
    [self.rtcKit stopPreview];
    
}

/// 收到远端用户加入的回调后 渲染视图
- (void)setRemoteViewWithUser:(NSInteger)userId remoteView:(UIView *)remoteView {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = userId;
    videoCanvas.view = remoteView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.rtcKit setupRemoteVideo:videoCanvas];
}

- (void)setLocalVideoEnable:(BOOL)enable {
    [self.rtcKit enableLocalVideo:enable];
}

- (void)setRole:(AgoraClientRole)role {
    _role = role;
    [self.rtcKit setClientRole:role];
    self.isUpmic = role == AgoraClientRoleBroadcaster;
}

- (void)setIsMute:(BOOL)isMute {
    _isMute = isMute;
    [self.rtcKit muteLocalAudioStream:isMute];
}

/// 开启或关闭垫片
- (int)openVirtualBackground:(NSString * _Nullable)url {
    BOOL closeCamera = url != nil;
    AgoraImageTrackOptions *option = [[AgoraImageTrackOptions alloc] init];
    option.imageUrl = url;
    option.fps = 15;
    int r = [self.rtcKit enableVideoImageSource:closeCamera options:option];
    if (r == 0) {
        [self.rtcKit enableLocalVideo:!closeCamera];
        self.virtualBgUrl = url;
    }
    NSLog(@"openVirtualBackground==%d,url:%@",r,url);
    return r;
}

- (void)switchCamera {
    [self.rtcKit switchCamera];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openOrCloseMirror];
    });
    _isTorch = NO;
}

- (void)openOrCloseMirror {
    BOOL mirror = self.encoderConfig.mirrorMode == AgoraVideoMirrorModeEnabled;
    self.encoderConfig.mirrorMode = mirror ? AgoraVideoMirrorModeDisabled : AgoraVideoMirrorModeEnabled;
    [self.rtcKit setVideoEncoderConfiguration:self.encoderConfig];
    [self.rtcKit setLocalRenderMode:AgoraVideoRenderModeHidden mirror:mirror ? AgoraVideoMirrorModeDisabled : AgoraVideoMirrorModeEnabled];
}

- (void)swithTorch {
    if ([self.rtcKit isCameraTorchSupported]) {
        _isTorch = !_isTorch;
        [self.rtcKit setCameraTorchOn:_isTorch];
    }
}

#pragma mark - rtc delegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"didJoinChannel === %@ uid===%ld 自己uid=%@  elapsed:%ld",channel,uid,account.userInfo.uid,elapsed);
    ExecBlock(self.joinChannelSuccessBlock,uid);
    if (self.virtualBgUrl) {
        [self openVirtualBackground:self.virtualBgUrl];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didLeaveChannelWithStats:(AgoraChannelStats *)stats {
    NSLog(@"didLeaveChannelWithStats === %@",stats);
}
-(void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine{
    ExecBlock(self.actorLeaveBlock);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"远端用户加入频道: %ld",elapsed);
   
//    [engine getDeviceId:AgoraMediaDeviceTypeVideoRender];
    
//    [self setRemoteViewWithUid:uid view:self.localPreview];

    ExecBlock(self.remoteUserJoinChannelBlock,uid);
}
-(void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    NSLog(@"重新加入频道: %ld",uid);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    NSLog(@"远端用户离开rtc频道");
    if (reason == AgoraUserOfflineReasonDropped) {
        //主播离开
        ExecBlock(self.actorLeaveBlock);
       
    }
    else if (reason == AgoraUserOfflineReasonQuit){
        ExecBlock(self.leaveChannelSuccessBlock,uid);
    }
}

/// 用户网络状态改变回调
-(void)rtcEngine:(AgoraRtcEngineKit *)engine connectionChangedToState:(AgoraConnectionState)state reason:(AgoraConnectionChangedReason)reason{

//- (void)rtcEngine:(AgoraRtcEngineKit *)engine connectionStateChanged:(AgoraConnectionState)state reason:(AgoraConnectionChangedReason)reason {
    
    switch (state) {
        case 1:
            NSLog(@"网络连接断开");
            break;
        case 2:
            NSLog(@"建立网络连接中");
            break;
        case 3:
            NSLog(@"网络已连接");
            break;
        case 4:
            NSLog(@"重新建立网络连接中");
            break;
        case 5:
            NSLog(@"网络连接失败");
            break;
        default:
            break;
    }
    if (reason == AgoraConnectionChangedReasonBannedByServer) {
        ExecBlock(self.KitOutBlock);
    }
    ExecBlock(self.RtcChangeToStateBlock,reason);
    NSLog(@"connectionStateChanged以下:\nstate:%ld\nreason:%ld",state,reason);
}

/// 其他用户通过回调执行
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid {
    ExecBlock(self.didAudioMutedBlock,uid,muted);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo *> *)speakers totalVolume:(NSInteger)totalVolume {
   
    for (AgoraRtcAudioVolumeInfo *info in speakers) {
        ExecBlock(self.reportAudioVolumeIndicationOfSpeakersBlock,info.uid,info.volume > 3);
    }
}

@end
