//
//  NSObject+WXTRTCCloud.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/4.
//

#import "NSObject+WXTRTCCloud.h"
#import "NSObject+injection_exchange.h"

@implementation NSObject (WXTRTCCloud)
+ (void)injectionWXTRTCCloud {
    Class WXTRTCCloudClass = NSClassFromString(@"WXTRTCCloud");
    [WXTRTCCloudClass injectionExchangeInstanceMethod:@selector(registerLivePlayListener:subStream:listener:) withMethod:@selector(injection_registerLivePlayListener:subStream:listener:)];
    
    [WXTRTCCloudClass injectionExchangeInstanceMethod:@selector(unregisterLivePlayListener:subStream:) withMethod:@selector(injection_unregisterLivePlayListener:subStream:)];
    
    [WXTRTCCloudClass injectionExchangeInstanceMethod:@selector(onNotifyEvent:withParams:) withMethod:@selector(injection_onNotifyEvent:withParams:)];
}


- (NSInteger)injection_v2_startPush:(NSString *)url {
    return [self injection_v2_startPush:url];
}

- (void)injection_registerLivePlayListener:(NSString *)userId subStream:(BOOL)subStream listener:(id)listener {
    [self injection_registerLivePlayListener:userId subStream:subStream listener:listener];
    NSLog(@"injection_registerLivePlayListener userId:%@ subStream:%@ listener:%@",userId,@(subStream),listener);
}

- (void)injection_unregisterLivePlayListener:(NSString *)userId subStream:(BOOL)subStream {
    [self injection_unregisterLivePlayListener:userId subStream:subStream];
    NSLog(@"injection_unregisterLivePlayListener userId:%@ subStream:%@",userId,@(subStream));
}


- (void)injection_onNotifyEvent:(int)event withParams:(NSDictionary*)params {
    [self injection_onNotifyEvent:event withParams:params];
    NSLog(@"injection_onNotifyEvent event:%@ withParams:%@",@(event),params);
}
@end
