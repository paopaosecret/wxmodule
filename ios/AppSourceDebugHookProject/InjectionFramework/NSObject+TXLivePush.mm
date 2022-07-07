//
//  NSObject+V2TXLivePusher.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import "NSObject+TXLivePush.h"
@implementation NSObject (TXLivePush)

+ (void)injectionTXLivePush {
    Class TXLivePushClass = NSClassFromString(@"TXLivePush");
    [TXLivePushClass injectionExchangeInstanceMethod:@selector(initWithConfig:) withMethod:@selector(injection_initWithConfig:)];
}

- (TXLivePush *)injection_initWithConfig:(TXLivePushConfig *)config {
    TXLivePush *obj = [[TXLivePush alloc]initWithConfig:config];
    [[InjectionFrameworkManage sharedInstance].cache setObject:obj forKey:[obj getNSObjectId]];
    return obj;
}

@end

@implementation TXLivePush (TXLivePush)

- (void)dealloc {
    [[InjectionFrameworkManage sharedInstance].cache removeObjectForKey:[self getNSObjectId]];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
