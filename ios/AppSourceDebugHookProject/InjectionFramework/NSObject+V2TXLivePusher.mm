//
//  NSObject+V2TXLivePusher.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import "NSObject+V2TXLivePusher.h"
@implementation NSObject (V2TXLivePusher)

+ (void)injectionV2TXLivePusher {
    Class V2TXLivePusherClass = NSClassFromString(@"V2TXLivePusher");
    [V2TXLivePusher injectionExchangeInstanceMethod:@selector(setObserver:) withMethod:@selector(injection_V2TXLivePusher_setObserver:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(setObserver:) withMethod:@selector(injection_V2TXLivePusher_setObserver:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(initWithLiveMode:) withMethod:@selector(injection_v2_initWithLiveMode:)];
    
    Class observerClass = NSClassFromString(@"GCLivePush");
    [observerClass injectionExchangeInstanceMethod:@selector(onProcessVideoFrame:dstFrame:) withMethod:@selector(injection_v2_onProcessVideoFrame:dstFrame:)];
    [observerClass injectionExchangeInstanceMethod:@selector(onCaptureFirstVideoFrame) withMethod:@selector(injection_v2_onCaptureFirstVideoFrame)];
    [observerClass injectionExchangeInstanceMethod:@selector(onCaptureFirstAudioFrame) withMethod:@selector(injection_v2_onCaptureFirstAudioFrame)];
    
}

- (V2TXLivePusher *)injection_v2_initWithLiveMode:(V2TXLiveMode)liveMode {
    V2TXLivePusher *obj = [[V2TXLivePusher alloc]initWithLiveMode:liveMode];
    [[InjectionFrameworkManage sharedInstance].cache setObject:obj forKey:[obj getNSObjectId]];
    return obj;
}

/**
 * 设置推流器回调。
 *
 * 通过设置回调，可以监听 V2TXLivePusher 推流器的一些回调事件，
 * 包括推流器状态、音量回调、统计数据、警告和错误信息等。
 *
 * @param observer 推流器的回调目标对象，更多信息请查看 {@link V2TXLivePusherObserver}
 */
- (void)injection_V2TXLivePusher_setObserver:(id)observer {
    NSLog(@"injection_V2TXLivePusher_setObserver");
    [self injection_V2TXLivePusher_setObserver:observer];
}


#pragma mark --V2TXLivePusherObserver
- (void)injection_v2_onProcessVideoFrame:(id)srcFrame dstFrame:(id)dstFrame {
//    NSLog(@"injection_v2_onProcessVideoFrame");
    [self injection_v2_onProcessVideoFrame:srcFrame dstFrame:dstFrame];
}

/**
 * 首帧视频采集完成的回调通知
 */
- (void)injection_v2_onCaptureFirstVideoFrame {
    NSLog(@"injection_v2_onCaptureFirstVideoFrame");
    [self injection_v2_onCaptureFirstVideoFrame];
}

/**
 * 首帧音频采集完成的回调通知
 */
- (void)injection_v2_onCaptureFirstAudioFrame {
    NSLog(@"injection_v2_onCaptureFirstAudioFrame");
    [self injection_v2_onCaptureFirstAudioFrame];
}

@end

@implementation V2TXLivePusher (V2TXLivePusher)

- (void)dealloc {
    [[InjectionFrameworkManage sharedInstance].cache removeObjectForKey:[self getNSObjectId]];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
