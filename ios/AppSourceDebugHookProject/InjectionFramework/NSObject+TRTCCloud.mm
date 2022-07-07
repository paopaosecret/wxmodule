//
//  NSObject+TRTCCloud.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import "NSObject+TRTCCloud.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (TRTCCloud)

+ (void)injectionTRTCCloud {
    Class TRTCCloudClass = NSClassFromString(@"TRTCCloud");
    [TRTCCloudClass injectionExchangeClassMethod:@selector(sharedInstance) withMethod:@selector(injection_TRTCCloud_sharedInstance)];
    [TRTCCloudClass injectionExchangeClassMethod:@selector(destroySharedIntance) withMethod:@selector(injection_TRTCCloud_destroySharedIntance)];
}

+ (TRTCCloud *)injection_TRTCCloud_sharedInstance {
    return [TRTCCloud sharedInstance];
}

+ (void)injection_TRTCCloud_destroySharedIntance {
    [TRTCCloud destroySharedIntance];
}

@end
