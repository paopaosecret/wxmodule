//
//  NSObject+TXLiveBase.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/22.
//

#import "NSObject+TXLiveBase.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (TXLiveBase)
+ (void)injectionTXLiveBase {
    Class TXLiveBaseClass = NSClassFromString(@"TXLiveBase");
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setLogLevel:) withMethod:@selector(injection_setLogLevel:)];
    [TXLiveBaseClass injectionExchangeClassMethod:@selector(setConsoleEnabled:) withMethod:@selector(injection_setConsoleEnabled:)];
    
}

/**
 *  设置 log 输出级别
 *  @param level 参见 LOGLEVEL
 */
+ (void)injection_setLogLevel:(int)level {
    [self injection_setLogLevel:0];
    [self performSelector:@selector(setConsoleEnabled:) withObject:nil];
}

/**
 * 启用或禁用控制台日志打印
 * @param enabled 指定是否启用
 */
+ (void)injection_setConsoleEnabled:(BOOL)enabled {
    [self injection_setConsoleEnabled:YES];
}

@end
