//
//  NSObject+V2TXLivePlayer.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/4.
//

#import "NSObject+V2TXLivePlayer.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (V2TXLivePlayer)

+ (void)injectionV2TXLivePlayer {
    Class V2TXLivePlayerClass = NSClassFromString(@"V2TXLivePlayer");
    [V2TXLivePlayerClass injectionExchangeInstanceMethod:@selector(init) withMethod:@selector(injection_V2TXLivePlayer_init)];
    
    
    [V2TXLivePlayer injectionExchangeInstanceMethod:@selector(setObserver:) withMethod:@selector(injection_V2TXLivePlayer_setObserver:)];
    [V2TXLivePlayerClass injectionExchangeInstanceMethod:@selector(setObserver:) withMethod:@selector(injection_V2TXLivePlayer_setObserver:)];
}

- (V2TXLivePlayer *)injection_V2TXLivePlayer_init {
    id obj = [[V2TXLivePlayer alloc]init];
    [[InjectionFrameworkManage sharedInstance].cache setObject:obj forKey:[obj getNSObjectId]];
    return obj;
}


/**
 * 设置播放器回调。
 *
 * 通过设置回调，可以监听 V2TXLivePlayer 播放器的一些回调事件，
 * 包括播放器状态、播放音量回调、音视频首帧回调、统计数据、警告和错误信息等。
 *
 * @param observer 播放器的回调目标对象，更多信息请查看 {@link V2TXLivePlayerObserver}
 */
- (void)injection_V2TXLivePlayer_setObserver:(id)observer {
    NSLog(@"injection_V2TXLivePlayer_setObserver");
    [self injection_V2TXLivePlayer_setObserver:observer];
}


@end

@implementation V2TXLivePlayer (V2TXLivePlayer)

- (void)dealloc {
    [[InjectionFrameworkManage sharedInstance].cache removeObjectForKey:[self getNSObjectId]];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
