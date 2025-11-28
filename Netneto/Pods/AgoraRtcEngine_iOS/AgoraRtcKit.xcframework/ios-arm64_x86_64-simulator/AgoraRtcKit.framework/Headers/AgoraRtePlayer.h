/**
 *
 * Agora Real Time Engagement
 * Copyright (c) 2024 Agora IO. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "AgoraRteEnumerates.h"

@class AgoraRteError;
@class AgoraRte;
@class AgoraRtePlayerCustomSourceProvider;
@class AgoraRteStream;
@class AgoraRteCanvas;
@class AgoraRtePlayerObserver;

/**
 * The PlayerInitialConfig class is used to initialize the Player object.
 * @since v4.4.0
 * @technical preview
 */
__attribute__((visibility("default"))) @interface AgoraRtePlayerInitialConfig : NSObject

-(instancetype _Nonnull)init;

@end

/** 
 * Player configuration class
 * @since v4.4.0
 */
__attribute__((visibility("default"))) @interface AgoraRtePlayerConfig : NSObject

-(instancetype _Nonnull)init;

/** 
 * Whether to automatically play after a successful call to [AgoraRtePlayer openWithUrl:startTime:cb:].
 * If not set, the default value is YES.
 * @since v4.4.0
 * @param autoPlay 
 * - YES: Automatically start streaming and playing after a successful opening.
 * - NO: After a successful open with [AgoraRtePlayer openWithUrl:startTime:cb:], you need to actively call [AgoraRtePlayer play:] to play the audio and video stream.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *   - AgoraRteOk: Success
 * @return void
 */
- (void)setAutoPlay:(BOOL)autoPlay error:(AgoraRteError * _Nullable)error;

/**
 * Get the auto-play setting
 * @since v4.4.0
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *   - AgoraRteOk: Success  
 * @return BOOL 
 */
- (BOOL)autoPlay:(AgoraRteError * _Nullable)error;

- (void)setPlaybackSpeed:(int32_t)speed error:(AgoraRteError * _Nullable)error;
- (int32_t)playbackSpeed:(AgoraRteError * _Nullable)error;

- (void)setPlayoutAudioTrackIdx:(int)idx error:(AgoraRteError * _Nullable)error;
- (int)playoutAudioTrackIdx:(AgoraRteError * _Nullable)error;

- (void)setPublishAudioTrackIdx:(int)idx error:(AgoraRteError * _Nullable)error;
- (int)publishAudioTrackIdx:(AgoraRteError * _Nullable)error;

- (void)setAudioTrackIdx:(int)idx error:(AgoraRteError * _Nullable)error;
- (int)audioTrackIdx:(AgoraRteError * _Nullable)error;

- (void)setSubtitleTrackIdx:(int)idx error:(AgoraRteError * _Nullable)error;
- (int)subtitleTrackIdx:(AgoraRteError * _Nullable)error;

- (void)setExternalSubtitleTrackIdx:(int)idx error:(AgoraRteError * _Nullable)error;
- (int)externalSubtitleTrackIdx:(AgoraRteError * _Nullable)error;

- (void)setAudioPitch:(int32_t)pitch error:(AgoraRteError * _Nullable)error;
- (int32_t)audioPitch:(AgoraRteError * _Nullable)error;

- (void)setPlayoutVolume:(int32_t)volume error:(AgoraRteError * _Nullable)error;
- (int32_t)playoutVolume:(AgoraRteError * _Nullable)error;

- (void)setAudioPlaybackDelay:(int32_t)delay error:(AgoraRteError * _Nullable)error;
- (int32_t)audioPlaybackDelay:(AgoraRteError * _Nullable)error;

- (void)setAudioDualMonoMode:(int)mode error:(AgoraRteError * _Nullable)error;
- (int)audioDualMonoMode:(AgoraRteError * _Nullable)error;

- (void)setPublishVolume:(int32_t)volume error:(AgoraRteError * _Nullable)error;
- (int32_t)publishVolume:(AgoraRteError * _Nullable)error;

- (void)setLoopCount:(int32_t)count error:(AgoraRteError * _Nullable)error;
- (int32_t)loopCount:(AgoraRteError * _Nullable)error;

/**
  * Set player private parameters. This parameter setting can be done according to actual needs, referring to the suggestions of Agora SA.
  * @since v4.4.0
  * @param jsonParameter JSON formatted string
  * @param error AgoraRteError object may return the following AgoraRteErrorCode
  *  - AgoraRteOk: Success
  *  - AgoraRteErrorInvalidArgument: Indicates that the jsonParameter parameter is empty.
  * @return void
  */
- (void)setJsonParameter:(NSString * _Nonnull)jsonParameter error:(AgoraRteError * _Nullable)error;

/**
  * Get the currently configured private parameters of the AgoraRtePlayer.
  * @since v4.4.0
  * @param error AgoraRteError object may return the following AgoraRteErrorCode
  *  - AgoraRteOk: Success
  * @return NSString
  */
- (NSString * _Nullable)jsonParameter:(AgoraRteError * _Nullable)error;

/**
  * Set the ABR subscription layer.
  * If ABR is not enabled, the audience can only switch the high and low video stream  in the origin channel. After enabling it, the audience can switch any layer in the abr channel.
  * @since v4.4.0
  * @param layer The layer to subscribe to. Refer to the AgoraRteAbrSubscriptionLayer enumeration values for details.
  * @param error AgoraRteError object may return the following AgoraRteErrorCode
  *  - AgoraRteOk: Success
  *  - AgoraRteErrorInvalidArgument: An illegal AgoraRteAbrSubscriptionLayer value was set.
  * @return void
  */
- (void)setAbrSubscriptionLayer:(AgoraRteAbrSubscriptionLayer)layer error:(AgoraRteError * _Nullable)error;

/**
  * Get the ABR subscription layer.
  * @since v4.4.0
  * @param error AgoraRteError object may return the following AgoraRteErrorCode
  *  - AgoraRteOk: Success
  * @return AgoraRteAbrSubscriptionLayer The currently set subscription layer.
  */
- (AgoraRteAbrSubscriptionLayer)abrSubscriptionLayer:(AgoraRteError * _Nullable)error;

/**
  * Set the ABR fallback layer option.
  * If ABR is not enabled, after calling this method, the audience can only set AgoraRteAbrFallbackDisabled ~ AgoraRteAbrFallbackAudioOnly in the original channel. 
  * After enabling it, the audience can switch all values of AbrFallbackLayer in the abr channel.
  * @since v4.4.0
  * @param layer The ABR fallback option to set. Refer to the AgoraRteAbrFallbackLayer enumeration values for details.
  * @param error AgoraRteError object may return the following AgoraRteErrorCode
  *  - AgoraRteOk: Success
  *  - AgoraRteErrorInvalidArgument: An illegal AgoraRteAbrFallbackLayer value was set. Check the value of the passed layer parameter.
  * @return void
  */
- (void)setAbrFallbackLayer:(AgoraRteAbrFallbackLayer)layer error:(AgoraRteError * _Nullable)error;

/**
  * Get the ABR fallback layer option.
  * @since v4.4.0
  * @param error AgoraRteError object may return the following AgoraRteErrorCode
  *  - AgoraRteOk: Success
  * @return AgoraRteAbrFallbackLayer The currently set ABR fallback option.
  */
- (AgoraRteAbrFallbackLayer)abrFallbackLayer:(AgoraRteError * _Nullable)error;

@end

/**
 * Player statistics. Can be actively obtained through the [AgoraRtePlayer getStats:] interface.
 * @since v4.4.0
 */
__attribute__((visibility("default"))) @interface AgoraRtePlayerStats : NSObject

- (instancetype _Nonnull)init;

/**
 * Decoding frame rate
 */
- (int)videoDecodeFrameRate;

/**
 * Rendering frame rate
 */
- (int)videoRenderFrameRate;

/**
 * Video bitrate
 */
- (int)videoBitrate;

/**
 * Audio bitrate
 */
- (int)audioBitrate;

@end

/**
 * Player information.
 * When playerInfo changes, it will be notified through the [AgoraRtePlayerObserver onPlayerInfoUpdated:] callback interface. It can also be actively obtained through the [AgoraRtePlayer getInfo:error] interface.
 * @since v4.4.0
 */
__attribute__((visibility("default"))) @interface AgoraRtePlayerInfo : NSObject
- (instancetype _Nonnull)init;

/**
 * Current player state
 */
- (int)state;

/**
 * Reserved parameter.
 */
- (long)duration;

/**
 * Reserved parameter.
 */
- (int)streamCount;

/**
 * Whether there is an audio stream. When opening an rte URL, it indicates whether the broadcaster has pushed audio.
 */
- (BOOL)hasAudio;

/**
 * Whether there is a video stream. When opening an rte URL, it indicates whether the broadcaster has pushed video.
 */
- (BOOL)hasVideo;

/**
 * Whether the audio is muted. Indicates whether the audience has subscribed to the audio stream.
 */
- (BOOL)isAudioMuted;

/**
 * Whether the video is muted. Indicates whether the audience has subscribed to the video stream.
 */
- (BOOL)isVideoMuted;

/**
 * Video resolution height
 */
- (int)videoHeight;

/**
 * Video resolution width
 */
- (int)videoWidth;

/**
 * The currently subscribed video layer
 */
- (AgoraRteAbrSubscriptionLayer)abrSubscriptionLayer;

/**
 * Audio sample rate
 */
- (int)audioSampleRate;

/**
 * Number of audio channels
 */
- (int)audioChannels;

/**
 * Reserved parameter.
 */
- (int)audioBitsPerSample;

@end


/*
 * Player class, can be used to play URL resources.
 * @since v4.4.0
 */
__attribute__((visibility("default"))) @interface AgoraRtePlayer : NSObject

/**
 * Preload URL, only valid for rte type URLs. This interface can speed up the [AgoraRtePlayer openWithUrl:startTime:cb] operation. Up to 20 URLs can be preloaded. 
 * If the limit is exceeded, new preloads will replace old ones.
 * @since v4.4.0
 * @param url rte type URL
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidArgument: The passed URL is empty or has an invalid format.
 * @return BOOL Whether the preload operation was successful.
 *  - YES: Successfully preload the Rte URL.
 *  - NO: Failed to preload the Rte URL.
 */
+ (BOOL)preloadWithUrl:(NSString * _Nonnull)url error:(AgoraRteError * _Nullable)error;

/**
 * Construct an AgoraRtePlayer object.
 * @since v4.4.0
 * @param rte AgoraRte object.
 * @param config AgoraRtePlayerInitialConfig initialization configuration object. Currently, a null pointer can be passed.
 */
- (instancetype _Nonnull)initWithRte:(AgoraRte * _Nonnull)rte initialConfig:(AgoraRtePlayerInitialConfig * _Nullable)config;

/** 
 * Open URL resource. Currently, only rte URLs are supported, and cdn URLs and files are not supported.
 * This interface can also be used to refresh the token of an already opened URL.
 * For URL format definition and token refresh method description, refer to the doc:
 *  https://doc.shengwang.cn/doc/rtc/android/best-practice/playing-url
 * @since v4.4.0
 * @param url The URL resource to open
 * @param startTime Start time [currently not supported]
 * @param cb Asynchronous callback to notify the result of the open operation. If an error occurs during open, it will enter the AgoraRtePlayerStateFailed state. 
 *  You need to call the stop method before calling [AgoraRtePlayer openWithUrl:startTime:cb] again.
 *    @param err Possible ErrorCode returns. At this time, the new_state value corresponds to AgoraRtePlayerStateFailed.
 *      - AgoraRteOk: Success
 *      - AgoraRteErrorDefault: For specific reasons, see Error.message, including the following situations:
 *        - Failed to connect to the channel
 *      - AgoraRteErrorInvalidArgument:
 *        - Invalid appid
 *        - Invalid channelid
 *        - Invalid uid
 *      - AgoraRteErrorAuthenticationFailed:
 *        - Invalid token
 *        - Token expired
 *      - AgoraRteErrorInvalidOperation:
 *        - Engine not initialized
 * @return void
 */
- (void)openWithUrl:(NSString * _Nonnull)url startTime:(uint64_t)startTime cb:(void (^_Nullable)(AgoraRteError* _Nullable err))cb;

- (void)openWithCustomSourceProvider:(AgoraRtePlayerCustomSourceProvider * _Nonnull)provider startTime:(uint64_t)startTime cb:(void (^_Nullable)(AgoraRteError* _Nullable err))cb;

- (void)openWithStream:(AgoraRteStream * _Nonnull)stream cb:(void (^_Nullable)(AgoraRteError* _Nullable err))cb;

/**
 * Get player playback statistics.
 * @since v4.4.0
 * @param cb Asynchronous callback for statistical data.
 *    @param stats Statistical values.
 *    @param err AgoraRteError object may return the following AgoraRteErrorCode
 *      - AgoraRteOk: Success
 * @return void
 */
- (void)getStats:(void (^_Nonnull)(AgoraRtePlayerStats* _Nonnull stats, AgoraRteError* _Nullable err))cb;

/**
 * Set canvas. After the stream is successfully pulled, the video frame will be rendered on the set canvas.
 * @since v4.4.0
 * @param canvas The canvas object used to render video frames.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidArgument: The canvas is null.
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 * @return BOOL The result of the setCanvas operation. If it fails, you can check the specific error through err.
 *  - YES: Successfully set the canvas.
 *  - NO: Failed to set the canvas.
 */
- (BOOL)setCanvas:(AgoraRteCanvas *_Nonnull)canvas error:(AgoraRteError * _Nullable)error;

/**
 * Start stream playback.
 * @since v4.4.0
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 * @return BOOL The result of the play operation. If it fails, you can check the specific error through err.
 *  - YES: Successfully play.
 *  - NO: Failed to play.
 */
- (BOOL)play:(AgoraRteError * _Nullable)error;

/**
 * Stop playback.
 * @since v4.4.0
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 * @return BOOL The result of the stop operation. If it fails, you can check the specific error through err.
 *  - YES: Successfully stop.
 *  - NO: Failed to stop.
 */
- (BOOL)stop:(AgoraRteError * _Nullable)error;

/**
 * Pause playback.
 * @since v4.4.0
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 * @return BOOL The result of the pause operation. If it fails, you can check the specific error through err.
 *  - YES: Successfully pause.
 *  - NO: Failed to pause.
 */
- (BOOL)pause:(AgoraRteError * _Nullable)error;

- (BOOL)seek:(uint64_t)newTime error:(AgoraRteError * _Nullable)error;

/**
 * Mute/unmute audio separately.
 * @since v4.4.0
 * @param mute Whether to mute.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 * @return BOOL The result of the muteAudio operation. If it fails, you can check the specific error through err.
 *  - YES: The mute operation was successful.
 *  - NO: The mute operation failed.
 */
- (BOOL)muteAudio:(BOOL)mute error:(AgoraRteError * _Nullable)error;

/**
 * Mute/unmute video separately.
 * @since v4.4.0
 * @param mute Whether to mute.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 * @return BOOL The result of the muteVideo operation. If it fails, you can check the specific error through err.
 *  - YES: The mute operation was successful.
 *  - NO: The mute operation failedl.
 */
- (BOOL)muteVideo:(BOOL)mute error:(AgoraRteError * _Nullable)error;

/**
 * Get the current playback position.
 * @since v4.4.0
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 * @return uint64_t The current playback position.
 * @technical preview
 */
- (uint64_t)getPosition:(AgoraRteError * _Nullable)error;

/**
 * Get player information.
 * @since v4.4.0
 * @param info The object used to receive player information. After the interface call is successful, the player information will be copied to the info object.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 *  - AgoraRteErrorInvalidArgument: The info object is null.
 * @return BOOL The result of the getInfo operation. If it fails, you can check the specific error through err.
 *  - YES: Successfully get the player information.
 *  - NO: Failed to get the player information. 
 */
- (BOOL)getInfo:(AgoraRtePlayerInfo * _Nonnull)info error:(AgoraRteError * _Nullable)error;

/**
 * Get the configuration of AgoraRtePlayer object.
 * @since v4.4.0
 * @param config The object used to receive PlayerConfig information.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 *  - AgoraRteErrorInvalidArgument: The config object is null.
 * @return BOOL The result of the getConfigs operation. If it fails, you can check the specific error through err.
 *  - YES: Successfully retrieved.
 *  - NO: Failed to retrieve.
 */
- (BOOL)getConfigs:(AgoraRtePlayerConfig * _Nonnull)config error:(AgoraRteError * _Nullable)error;

/**
 * Configure the AgoraRtePlayer object.
 * @since v4.4.0
 * @param config The object used to change the player configuration.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 *  - AgoraRteErrorInvalidArgument: The config object is null.
 * @return BOOL The result of the setConfigs operation. If it fails, you can check the specific error through err.
 *  - YES: Successfully set the configuration.
 *  - NO: Failed to set the configuration.
 */
- (BOOL)setConfigs:(AgoraRtePlayerConfig * _Nonnull)config error:(AgoraRteError * _Nullable)error;

/**
 * Register player observer.
 * @since v4.4.0
 * @param observer The object used to receive player-related callbacks.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 *  - AgoraRteErrorInvalidArgument: The observer object is null.
 * @return BOOL The result of the registerObserver operation. If it fails, you can check the specific error through err.
 *  - YES: Registration is successful.
 *  - NO: Registration failed.
 */
- (BOOL)registerObserver:(AgoraRtePlayerObserver *_Nonnull)observer error:(AgoraRteError * _Nullable)error;

/**
 * Unregister player observer.
 * @since v4.4.0
 * @param observer The object used to receive player-related callbacks.
 * @param error AgoraRteError object may return the following AgoraRteErrorCode
 *  - AgoraRteOk: Success
 *  - AgoraRteErrorInvalidOperation: The corresponding internal AgoraRtePlayer object has been destroyed or is invalid.
 *  - AgoraRteErrorInvalidArgument: The observer object is null.
 * @return BOOL The result of the unregisterObserver operation. If it fails, you can check the specific error through err.
 *  - YES: Unregistration is successful.
 *  - NO: Unregistration failed.
 */
- (BOOL)unregisterObserver:(AgoraRtePlayerObserver * _Nullable)observer error:(AgoraRteError * _Nullable)error;

@end
