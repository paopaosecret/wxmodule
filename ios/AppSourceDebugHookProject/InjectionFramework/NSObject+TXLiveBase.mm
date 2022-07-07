//
//  NSObject+TXLiveBase.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/22.
//

#import "NSObject+TXLiveBase.h"
#import "NSObject+injection_exchange.h"
#import "InjectionFrameworkManage.h"

@implementation NSObject (TXLiveBase)
+ (void)injectionTXLiveBase {
    Class TXLiveBaseClass = NSClassFromString(@"TXLiveBase");
    
    [TXLiveBase injectionExchangeInstanceMethod:@selector(setDelegate:) withMethod:@selector(injection_TXLiveBase_setDelegate:)];
    [TXLiveBaseClass injectionExchangeInstanceMethod:@selector(setDelegate:) withMethod:@selector(injection_TXLiveBase_setDelegate:)];
    
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(sharedInstance) withMethod:@selector(injection_TXLiveBase_sharedInstance)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setGlobalEnv:) withMethod:@selector(injection_setGlobalEnv:)];
    
    
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setLogLevel:) withMethod:@selector(injection_setLogLevel:)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setConsoleEnabled:) withMethod:@selector(injection_setConsoleEnabled:)];
    
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setAppVersion:) withMethod:@selector(injection_setAppVersion:)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setAudioSessionDelegate:) withMethod:@selector(injection_setAudioSessionDelegate:)];
    
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(getSDKVersionStr) withMethod:@selector(injection_getSDKVersionStr)];
    
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(getPituSDKVersion) withMethod:@selector(injection_getPituSDKVersion)];
    
    
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setAppID:) withMethod:@selector(injection_setAppID:)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setLicenceURL:key:) withMethod:@selector(injection_setLicenceURL:key:)];
    
    
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setUserId:) withMethod:@selector(injection_setUserId:)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(getLicenceInfo:) withMethod:@selector(injection_getLicenceInfo)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setExternalDecoderFactory:) withMethod:@selector(injection_setExternalDecoderFactory:)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(updateNetworkTime) withMethod:@selector(injection_updateNetworkTime)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(getNetworkTimestamp) withMethod:@selector(injection_getNetworkTimestamp)];

    
    Class TCUtilClass = NSClassFromString(@"TCUtil");
    [TCUtilClass injectionExchangeClassMethod:@selector(getPackageName) withMethod:@selector(injection_getPackageName)];
    
    
    Class TXLiveBaseDelegateClass = NSClassFromString(@"GCThirdPlatformSDKManager");
    [TXLiveBaseDelegateClass injectionExchangeInstanceMethod:@selector(onLicenceLoaded:Reason:) withMethod:@selector(injection_onLicenceLoaded:Reason:)];
    
}


/// 通过这个delegate将全部log回调给SDK使用者，由SDK使用者来决定log如何处理
- (void)injection_TXLiveBase_setDelegate:(id)delegate {
    NSLog(@"injection_TXLiveBase_setDelegate delegate:%@",delegate);
    if ([InjectionFrameworkManage sharedInstance].delegate != delegate) {
        [InjectionFrameworkManage sharedInstance].delegate = delegate;
    }
    [self injection_TXLiveBase_setDelegate:[InjectionFrameworkManage sharedInstance]];
}

+ (TXLiveBase *)injection_TXLiveBase_sharedInstance {
    return [TXLiveBase sharedInstance];
}

/**
 * 设置 liteav SDK 接入的环境。
 * 腾讯云在全球各地区部署的环境，按照各地区政策法规要求，需要接入不同地区接入点。
 *
 * @param env_config 需要接入的环境，SDK 默认接入的环境是：默认正式环境。
 * @return 0：成功；其他：错误
 *
 * @note
 * 目标市场为中国大陆的客户请不要调用此接口，如果目标市场为海外用户，请通过技术支持联系我们，了解
 * env_config 的配置方法，以确保 App 遵守 GDPR 标准。
 */
+ (int)injection_setGlobalEnv:(const char *)env_config {
    return [TXLiveBase setGlobalEnv:env_config];
}


/**
 *  设置 log 输出级别
 *  @param level 参见 LOGLEVEL
 */
+ (void)injection_setLogLevel:(int)level {
    [TXLiveBase setLogLevel:LOGLEVEL_VERBOSE];
    [self performSelector:@selector(setConsoleEnabled:) withObject:nil];
}
/**
 * 启用或禁用控制台日志打印
 * @param enabled 指定是否启用
 */
+ (void)injection_setConsoleEnabled:(BOOL)enabled {
    [TXLiveBase setConsoleEnabled:YES];
}


+ (void)injection_setAppVersion:(NSString *)verNum {
    [TXLiveBase setAppVersion:verNum];
}

+ (void)injection_setAudioSessionDelegate:(nullable id<TXLiveAudioSessionDelegate>)delegate {
    [TXLiveBase setAudioSessionDelegate:delegate];
}

/**
 * @brief 获取 SDK 版本信息
 * @return SDK 版本信息
 */
+ (NSString *)injection_getSDKVersionStr {
    return [TXLiveBase getSDKVersionStr];
}

/**
 * @brief 获取 pitu 版本信息
 * @return pitu 版本信息
 */
+ (NSString *)injection_getPituSDKVersion {
    return [TXLiveBase getPituSDKVersion];
}

/**
 * @brief 设置 appID，云控使用
 */
+ (void)injection_setAppID:(NSString *)appID {
    NSLog(@"injectionsetAppID appID:%@",appID);
    [TXLiveBase setAppID:appID];
}

/**
 * @brief 设置 sdk 的 Licence 下载 url 和 key
 */
+ (void)injection_setLicenceURL:(NSString *)url key:(NSString *)key {
    NSLog(@"injection_setLicenceURL url:%@ key:%@",url,key);
    [TXLiveBase setLicenceURL:url key:key];
}

/**
 * @brief 设置 userId，用于数据上报
 */
+ (void)injection_setUserId:(NSString *)userId {
    NSLog(@"injection_setUserId userId:%@",userId);
    [TXLiveBase setUserId:userId];
}

/**
 * @brief 获取 Licence 信息
 * @return Licence 信息
 */
+ (NSString *)injection_getLicenceInfo {
    NSLog(@"injection_getLicenceInfo");
    return [TXLiveBase getLicenceInfo];
}

/**
 * @brief 设置 HEVC 外部解码器工厂实例
 */
+ (void)injection_setExternalDecoderFactory:(id)decoderFactory {
    NSLog(@"injection_setExternalDecoderFactory");
    [TXLiveBase setExternalDecoderFactory:decoderFactory];
}

/**
 * 启动 NTP 校时服务
 *
 * @return 0：启动成功；< 0：启动失败
 */
+ (NSInteger)injection_updateNetworkTime {
    NSLog(@"injection_updateNetworkTime");
    return [TXLiveBase updateNetworkTime];
    
}

/**
 * 获取 NTP 时间戳（毫秒），请在收到 onUpdateNetworkTime 回调后使用
 *
 * @return NTP 时间戳（毫秒），若返回 0：未启动 NTP 校时或校时失败，请重启校时
 */
+ (NSInteger)injection_getNetworkTimestamp {
    NSLog(@"injection_getNetworkTimestamp");
    return [TXLiveBase getNetworkTimestamp];
}

#pragma mark --TCUtil
+ (NSString *)injection_getPackageName {
    return [self injection_getPackageName];
}

#pragma mark --TXLiveBaseDelegateClass
- (void)injection_onLicenceLoaded:(int)result Reason:(NSString *)reason {
    NSLog(@"injection_onLicenceLoaded result:%@ Reason:%@",@(result),reason);
    [self injection_onLicenceLoaded:result Reason:reason];
}

@end
