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
    [V2TXLivePlayerClass injectionExchangeInstanceMethod:@selector(startPlay:) withMethod:@selector(injection_v2_startPlay:)];
}

- (NSInteger)injection_v2_startPlay:(NSString *)url {
    NSLog(@"injection_v2_startPlay:%@",url);
    return [self injection_v2_startPlay:url];
}
@end
