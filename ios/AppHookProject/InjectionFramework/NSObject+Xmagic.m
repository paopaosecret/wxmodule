//
//  NSObject+Xmagic.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/23.
//

#import "NSObject+Xmagic.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (Xmagic)
+ (void)injectionXmagic {
    Class TELicenseCheckClass = NSClassFromString(@"TELicenseCheck");
    [TELicenseCheckClass injectionExchangeClassMethod:@selector(setTELicense:key:completion:) withMethod:@selector(injection_setTELicense:key:completion:)];
    
    
    Class XMagicAuthManagerClass = NSClassFromString(@"XMagicAuthManager");
    [XMagicAuthManagerClass injectionExchangeClassMethod:@selector(initAuthByString:withSecretKey:) withMethod:@selector(injection_initAuthByString:withSecretKey:)];
    
}

#pragma mark --TELicenseCheck
typedef void(^injection_xmagic_callback)(NSInteger authresult, NSString *errorMsg);
/// 加载license信息并鉴权，如果completion为nil，则仅触发下载更新缓存
/// @param url 在腾讯云控制台申请到的 LicenseURL
/// @param key 在腾讯云控制台申请到的 LicenseKEY
/// @param completion 鉴权结果回调
+ (void)injection_setTELicense:(NSString *)url key:(NSString *)key completion:(injection_xmagic_callback)completion {
    NSLog(@"injection_setTELicense");
    [self injection_setTELicense:url key:key completion:^(NSInteger authresult, NSString *errorMsg) {
        if(completion){
            completion(authresult,errorMsg);
        }
        NSLog(@"code:%@ errorMsg:%@",@(authresult),errorMsg);
    }];
}

#pragma mark --XMagicAuthManager
+ (int)injection_initAuthByString:(NSString*)license_string withSecretKey:(NSString*)secret_key {
    NSLog(@"injection_initAuthByString");
    int result = [self injection_initAuthByString:license_string withSecretKey:secret_key];
    return result;
}

@end
