//
//  NSObject+NSBundle.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/4/3.
//

#import "NSObject+NSBundle.h"
#import "NSObject+injection_exchange.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

@implementation NSObject (NSBundle)
+ (void)injectionNSBundle {
    Class NSBundleClass = NSClassFromString(@"NSBundle");
    [NSBundleClass injectionExchangeInstanceMethod:@selector(infoDictionary) withMethod:@selector(injection_infoDictionary)];
}

#pragma mark --获取infoDictionary
- (NSDictionary *)injection_infoDictionary {
    void* callstack[256];
    //来获取程序中当前函数的回溯信息，即一系列的函数调用关系，获取到的信息被放在参数buffer中
    int frames = backtrace(callstack, 256);
    //返回地址都对应到具体的函数名
    char **strs = backtrace_symbols(callstack, frames);
    BOOL isShowIpaBundleId = NO;
    for (NSInteger i = 0;i < 4;i++){
        NSString *name = [NSString stringWithUTF8String:strs[i]];
        if ([name containsString:@"TXLiteAVSDK"] || [name containsString:@"libdispatch.dylib"] || [name containsString:@"Foundation"]  || [name containsString:@"QQ"]) {
            isShowIpaBundleId = YES;
        } else if ([name containsString:@"UIKitCore"]) {
            //因为CFBundleIdentifier和Assets有加解密关系，所以不能乱修改
            isShowIpaBundleId = NO;
        }
    }
    free(strs);
    NSDictionary *infoDictionary = [self injection_infoDictionary];
    if (isShowIpaBundleId) {
        NSMutableDictionary *muInfoDictionary = [NSMutableDictionary dictionaryWithDictionary:infoDictionary];
        if (infoDictionary[@"Ipa_CFBundleIdentifier"]) {
            muInfoDictionary[@"CFBundleIdentifier"] = infoDictionary[@"Ipa_CFBundleIdentifier"];
        }
        return muInfoDictionary;
    } else {
        return infoDictionary;
    }
}

@end
