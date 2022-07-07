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
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(init) withMethod:@selector(injection_TXLivePlayer_init)];
    
    
    [TXLivePlayer injectionExchangeInstanceMethod:@selector(setDelegate:) withMethod:@selector(injection_TXLivePlayer_setDelegate:)];
    [TXLivePlayerClass injectionExchangeInstanceMethod:@selector(setDelegate:) withMethod:@selector(injection_TXLivePlayer_setDelegate:)];
}

- (TXLivePlayer *)injection_TXLivePlayer_init {
    TXLivePlayer *obj = [[TXLivePlayer alloc]init];
    [[InjectionFrameworkManage sharedInstance].cache setObject:obj forKey:[obj getNSObjectId]];
    return obj;
}


/**
 * 1.1 设置播放回调，见 “TXLivePlayListener.h” 文件中的详细定义
 */
- (void)injection_TXLivePlayer_setDelegate:(id)observer {
    NSLog(@"injection_TXLivePlayer_setDelegate");
    [self injection_TXLivePlayer_setDelegate:observer];
}


@end

@implementation TXLivePlayer (TXLivePlayer)

- (void)dealloc {
    [[InjectionFrameworkManage sharedInstance].cache removeObjectForKey:[self getNSObjectId]];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
