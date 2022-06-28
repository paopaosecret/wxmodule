//
//  NSObject+TRTCCloud.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import "NSObject+TRTCCloud.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (TRTCCloud)

+ (void)injectionTRTCCloud {
    Class TRTCCloudClass = NSClassFromString(@"TRTCCloud");
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(enterRoom:appScene:) withMethod:@selector(injection_enterRoom:appScene:)];
    
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(startRemoteView:streamType:view:) withMethod:@selector(injection_startRemoteView:streamType:view:)];
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(stopRemoteView:streamType:) withMethod:@selector(injection_stopRemoteView:streamType:)];
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(muteRemoteVideoStream:streamType:mute:) withMethod:@selector(injection_muteRemoteVideoStream:streamType:mute:)];
    
    
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(stopPublishing) withMethod:@selector(injection_stopPublishing)];
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(stopLocalAudio) withMethod:@selector(injection_stopLocalAudio)];
    
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(muteLocalAudio:) withMethod:@selector(injection_muteLocalAudio:)];
    
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(muteLocalVideo:) withMethod:@selector(injection_muteLocalVideo:)];
    
    [TRTCCloudClass injectionExchangeInstanceMethod:@selector(muteLocalVideo:mute:) withMethod:@selector(injection_muteLocalVideo:mute:)];
    
    //是TRTCCloud的代理
    Class V2TRTCCloud = NSClassFromString(@"V2TRTCCloud");
    [V2TRTCCloud injectionExchangeInstanceMethod:@selector(onRemoteUserEnterRoom:) withMethod:@selector(injection_onRemoteUserEnterRoom:)];
    [V2TRTCCloud injectionExchangeInstanceMethod:@selector(onRemoteUserLeaveRoom:reason:) withMethod:@selector(injection_onRemoteUserLeaveRoom:reason:)];
}

- (void)injection_enterRoom:(id)param appScene:(NSInteger)scene {
    [self injection_enterRoom:param appScene:scene];
}

- (void)injection_startRemoteView:(NSString *)userId streamType:(NSInteger)streamType view:(id)view {
    [self injection_startRemoteView:userId streamType:streamType view:view];
    NSLog(@"userId:%@ streamType:%@",userId,@(streamType));
}

- (void)injection_stopRemoteView:(NSString *)userId streamType:(NSInteger)streamType {
    [self injection_stopRemoteView:userId streamType:streamType];
    NSLog(@"userId:%@ streamType:%@",userId,@(streamType));
}

- (void)injection_muteRemoteVideoStream:(NSString *)userId streamType:(NSInteger)streamType mute:(BOOL)mute {
    [self injection_muteRemoteVideoStream:userId streamType:streamType mute:mute];
    NSLog(@"userId:%@ streamType:%@ mute:%@",userId,@(streamType),@(mute));
}

- (void)injection_stopPublishing {
    [self injection_stopPublishing];
    NSLog(@"injection_stopPublishing");
}

- (void)injection_stopLocalAudio {
    [self injection_stopLocalAudio];
    NSLog(@"injection_stopLocalAudio");
}


- (void)injection_muteLocalAudio:(BOOL)mute {
    [self injection_muteLocalAudio:mute];
    NSLog(@"injection_muteLocalAudio:%@",@(mute));
}

- (void)injection_muteLocalVideo:(BOOL)mute {
    [self injection_muteLocalVideo:mute];
    NSLog(@"injection_muteLocalVideo:%@",@(mute));
}

- (void)injection_muteLocalVideo:(NSInteger)streamType mute:(BOOL)mute {
    [self injection_muteLocalVideo:streamType mute:mute];
    NSLog(@"injection_muteLocalVideo:%@:%@",@(streamType),@(mute));
}

#pragma mark --TRTCCloudDelegate
- (void)injection_onRemoteUserEnterRoom:(NSString *)userId {
    [self injection_onRemoteUserEnterRoom:userId];
    NSLog(@"userId:%@",userId);
}

- (void)injection_onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason {
    [self injection_onRemoteUserLeaveRoom:userId reason:reason];
    NSLog(@"userId:%@ reason:%@",userId,@(reason));
}


@end
