//
//  InjectionFunction.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/1.
//

#import "InjectionFunction.h"
#import "NSObject+TRTCCloud.h"
#import "NSObject+TXLivePlayer.h"
#import "NSObject+V2TXLivePusher.h"
#import "NSObject+TXLivePush.h"
#import "NSObject+V2TXLivePlayer.h"
#import "NSObject+WXTRTCCloud.h"
#import "NSObject+TXLiveBase.h"
#import "NSObject+Xmagic.h"
#import "NSObject+TXCRenderAndDec.h"

@implementation InjectionFunction
+ (void)load {
    [NSObject injectionTRTCCloud];
    [NSObject injectionTXLivePlayer];
    [NSObject injectionTXLivePush];
    [NSObject injectionTXLivePush];
    [NSObject injectionV2TXLivePlayer];
    [NSObject injectionV2TXLivePusher];
    [NSObject injectionTXLiveBase];
    [NSObject injectionXmagic];
    [NSObject injectionWXTRTCCloud];
    [NSObject injectionTXCRenderAndDec];
    NSLog(@"Injection Function");
}
@end
