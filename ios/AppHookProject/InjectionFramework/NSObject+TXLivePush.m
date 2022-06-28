//
//  NSObject+TXLivePush.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import "NSObject+TXLivePush.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (TXLivePush)
+ (void)injectionTXLivePush {
    Class TXLivePushClass = NSClassFromString(@"TXLivePush");
    [TXLivePushClass injectionExchangeInstanceMethod:@selector(startPush:) withMethod:@selector(injection_v1_startPush:)];
    [TXLivePushClass injectionExchangeInstanceMethod:@selector(stopPush) withMethod:@selector(injection_v1_stopPush)];
    [TXLivePushClass injectionExchangeInstanceMethod:@selector(pausePush) withMethod:@selector(injection_v1_pausePush)];
    [TXLivePushClass injectionExchangeInstanceMethod:@selector(resumePush) withMethod:@selector(injection_v1_resumePush)];
    [TXLivePushClass injectionExchangeInstanceMethod:@selector(initWithConfig:) withMethod:@selector(injection_v1_initWithConfig:)];
    [TXLivePushClass injectionExchangeInstanceMethod:@selector(startPreview:) withMethod:@selector(injection_v1_startPreview:)];
    
    
}

- (NSInteger)injection_v1_startPush:(NSString *)rtmpURL {
    NSLog(@"injection_v1_startPush:%@",rtmpURL);
    return [self injection_v1_startPush:rtmpURL];
}

/**
 * 2.4 停止 RTMP 推流
 */
- (void)injection_v1_stopPush {
    NSLog(@"injection_v1_stopPush");
    [self injection_v1_stopPush];
}

/**
 * 2.5 暂停摄像头采集并进入垫片推流状态
 *
 */
- (void)injection_v1_pausePush {
    NSLog(@"injection_v1_pausePush");
    [self injection_v1_pausePush];
}

/**
 * 2.6 恢复摄像头采集并结束垫片推流状态
 */
- (void)injection_v1_resumePush {
    NSLog(@"injection_v1_resumePush");
    [self injection_v1_resumePush];
}

- (instancetype)injection_v1_initWithConfig:(id)config {
    NSLog(@"injection_v1_initWithConfig");
    return [self injection_v1_initWithConfig:config];
}

- (NSInteger)injection_v1_startPreview:(id)view {
    NSLog(@"injection_v1_startPreview:%@",view);
    return [self injection_v1_startPreview:view];
}


@end
