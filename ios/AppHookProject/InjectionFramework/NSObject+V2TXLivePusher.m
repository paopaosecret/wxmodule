//
//  NSObject+V2TXLivePusher.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import "NSObject+V2TXLivePusher.h"
#import "NSObject+injection_exchange.h"
@implementation NSObject (V2TXLivePusher)

+ (void)injectionV2TXLivePusher {
    Class V2TXLivePusherClass = NSClassFromString(@"V2TXLivePusher");
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(startPush:) withMethod:@selector(injection_v2_startPush:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(startVirtualCamera:) withMethod:@selector(injection_v2_startVirtualCamera:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(stopVirtualCamera) withMethod:@selector(injection_v2_stopVirtualCamera)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(showDebugView:) withMethod:@selector(injection_v2_showDebugView:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(setObserver:) withMethod:@selector(injection_v2_setObserver:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(setRenderView:) withMethod:@selector(injection_v2_setRenderView:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(startCamera:) withMethod:@selector(injection_v2_startCamera:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(setMixTranscodingConfig:) withMethod:@selector(injection_v2_setMixTranscodingConfig:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(initWithLiveMode:) withMethod:@selector(injection_v2_initWithLiveMode:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(enableCustomVideoProcess:pixelFormat:bufferType:) withMethod:@selector(injection_v2_enableCustomVideoProcess:pixelFormat:bufferType:)];
    [V2TXLivePusherClass injectionExchangeInstanceMethod:@selector(enableCustomVideoCapture:) withMethod:@selector(injection_v2_enableCustomVideoCapture:)];
    
    Class observerClass = NSClassFromString(@"GCLivePush");
    [observerClass injectionExchangeInstanceMethod:@selector(onProcessVideoFrame:dstFrame:) withMethod:@selector(injection_v2_onProcessVideoFrame:dstFrame:)];
    [observerClass injectionExchangeInstanceMethod:@selector(onCaptureFirstVideoFrame) withMethod:@selector(injection_v2_onCaptureFirstVideoFrame)];
    [observerClass injectionExchangeInstanceMethod:@selector(onCaptureFirstAudioFrame) withMethod:@selector(injection_v2_onCaptureFirstAudioFrame)];
    
}

- (NSInteger)injection_v2_startPush:(NSString *)url {
    NSLog(@"injection_v2_startPush:%@",url);
    return [self injection_v2_startPush:url];
}

- (NSInteger)injection_v2_startVirtualCamera:(id)image {
    NSLog(@"injection_v2_startVirtualCamera:%@",image);
    return [self injection_v2_startVirtualCamera:image];
}

- (NSInteger)injection_v2_stopVirtualCamera {
    NSLog(@"injection_v2_stopVirtualCamera");
    return [self injection_v2_stopVirtualCamera];
}

/**
 * 显示仪表盘。
 *
 * @param isShow 是否显示。【默认值】：NO
 */
- (void)injection_v2_showDebugView:(BOOL)isShow {
    NSLog(@"injection_v2_showDebugView");
    [self injection_v2_showDebugView:YES];
}

/**
 * 设置推流器回调。
 *
 * 通过设置回调，可以监听 V2TXLivePusher 推流器的一些回调事件，
 * 包括推流器状态、音量回调、统计数据、警告和错误信息等。
 *
 * @param observer 推流器的回调目标对象，更多信息请查看 {@link V2TXLivePusherObserver}
 */
- (void)injection_v2_setObserver:(id)observer {
    NSLog(@"injection_v2_setObserver");
    [self injection_v2_setObserver:observer];
}


- (NSInteger)injection_v2_setRenderView:(id)view {
    NSLog(@"injection_v2_setRenderView");
    NSInteger value = [self injection_v2_setRenderView:view];
//    [self injection_v2_startCamera:YES];
    return value;
}

- (NSInteger)injection_v2_startCamera:(BOOL)frontCamera {
    NSLog(@"injection_v2_startCamera");
    return [self injection_v2_startCamera:frontCamera];
}

- (NSInteger)injection_v2_setMixTranscodingConfig:(id)config {
    NSLog(@"injection_v2_setMixTranscodingConfig");
    return [self injection_v2_setMixTranscodingConfig:config];
    
}

- (instancetype)injection_v2_initWithLiveMode:(NSInteger)liveMode {
    NSLog(@"injection_v2_initWithLiveMode");
    return [self injection_v2_initWithLiveMode:liveMode];
}

/**
 * 开启/关闭自定义视频处理。
 *
 * @note RTMP 协议下仅支持 OpenGL 纹理格式的回调。
 * @param enable YES: 开启; NO: 关闭。【默认值】：NO
 * @param pixelFormat 指定回调的像素格式，【注意】：RTMP 协议下仅支持 V2TXLivePixelFormatTexture2D
 * @param bufferType 指定回调的数据格式，【注意】：RTMP 协议下仅支持 V2TXLiveBufferTypeTexture
 * @return 返回值 {@link V2TXLiveCode}
 *         - V2TXLIVE_OK: 成功
 *         - V2TXLIVE_ERROR_NOT_SUPPORTED: 不支持的格式
 */
- (NSInteger)injection_v2_enableCustomVideoProcess:(BOOL)enable pixelFormat:(NSInteger)pixelFormat bufferType:(NSInteger)bufferType {
    NSLog(@"injection_v2_enableCustomVideoProcess enable:%@  pixelFormat:%@  bufferType:%@",@(enable),@(pixelFormat),@(bufferType));
    return [self injection_v2_enableCustomVideoProcess:enable pixelFormat:pixelFormat bufferType:bufferType];
}

/**
 * 开启/关闭自定义视频采集。
 *
 * 在自定义视频采集模式下，SDK 不再从摄像头采集图像，只保留编码和发送能力。
 * @note  需要在 [startPush](@ref V2TXLivePusher#startPush:) 之前调用，才会生效。
 * @param enable YES：开启自定义采集；NO：关闭自定义采集。【默认值】：NO
 * @return 返回值 {@link V2TXLiveCode}
 *         - V2TXLIVE_OK: 成功
 */
- (NSInteger)injection_v2_enableCustomVideoCapture:(BOOL)enable {
    NSLog(@"injection_v2_enableCustomVideoCapture enable:%@",@(enable));
    return [self injection_v2_enableCustomVideoCapture:enable];
}

#pragma mark --V2TXLivePusherObserver
- (void)injection_v2_onProcessVideoFrame:(id)srcFrame dstFrame:(id)dstFrame {
    NSLog(@"injection_v2_onProcessVideoFrame");
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
