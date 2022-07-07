//
//  InjectionFunction.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/1.
//

#import "InjectionFunction.h"
#import "NSObject+TXLiveBase.h"
#import "NSObject+V2TXLivePusher.h"
#import "NSObject+V2TXLivePlayer.h"
#import "NSObject+TRTCCloud.h"
#import "NSObject+TXLivePlayer.h"
#import "NSObject+TXLivePush.h"
#import "NSObject+NSBundle.h"

@implementation InjectionFunction
+ (void)load {
    [NSObject injectionTXLiveBase];
    [NSObject injectionV2TXLivePusher];
    [NSObject injectionV2TXLivePlayer];
    [NSObject injectionNSBundle];
    [NSObject injectionTRTCCloud];
    [NSObject injectionTXLivePlayer];
    [NSObject injectionTXLivePush];
    NSLog(@"Injection Function");
}
@end
