//
//  NSObject+TXLivePlayer.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import "NSObject+TXLivePlayer.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (TXLivePlayer)

+ (void)injectionTXLivePlayer {
    Class TXLivePlayerClass = NSClassFromString(@"TXLivePlayer");
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(startPlay:type:)
                                            withMethod:@selector(injection_v1_startPlay:appScene:)];
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(prepareLiveSeek:bizId:)
                                            withMethod:@selector(injection_v1_prepareLiveSeek:bizId:)];
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(switchStream:)
                                            withMethod:@selector(injection_v1_switchStream:)];
    
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(onNotifyEvent:withParams:)
                                            withMethod:@selector(injection_v1_onNotifyEvent:withParams:)];
    
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(pause)
                                            withMethod:@selector(injection_v1_pause)];
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(resume)
                                            withMethod:@selector(injection_v1_resume)];
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(setConfig)
                                            withMethod:@selector(injection_v1_setConfig)];
}

- (int)injection_v1_startPlay:(NSString *)url type:(NSInteger)playType {
    NSLog(@"injection_v1_startPlay:%@",url);
    return [self injection_v1_startPlay:url type:playType];
}


- (int)injection_v1_prepareLiveSeek:(NSString*)domain bizId:(NSInteger)bizId {
    NSLog(@"domain :%@ bizId:%d",domain,bizId);
    return [self injection_v1_prepareLiveSeek:domain bizId:bizId];
}

- (int)injection_v1_switchStream:(NSString *)playUrl {
    NSLog(@"playUrl:%@",playUrl);
    return [self injection_v1_switchStream:playUrl];
}

- (void)injection_v1_onNotifyEvent:(int)event withParams:(NSDictionary *)params {
    [self injection_v1_onNotifyEvent:event withParams:params];
    if ((event != 2005) && (event != 200001 )) {
        NSLog(@"event :%d params:%@",event,params);
    }
}

- (void)injection_v1_pause {
    [self injection_v1_pause];
    NSLog(@"injection_v1_pause");
}

- (void)injection_v1_resume {
    [self injection_v1_resume];
    NSLog(@"injection_v1_resume");
}

- (void)injection_v1_setConfig:(id)config {
    [self injection_v1_setConfig:config];
    NSLog(@"config:%@",config);
}

@end
