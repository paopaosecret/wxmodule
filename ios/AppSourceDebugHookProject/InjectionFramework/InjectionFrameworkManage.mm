//
//  InjectionFrameworkManage.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/5/4.
//

#import "InjectionFrameworkManage.h"
#import "NSObject+injection_exchange.h"
@implementation InjectionFrameworkManage

+ (instancetype)sharedInstance {
    static InjectionFrameworkManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cache = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptObserver:) name:@"InjectionFrameworkManageObserver" object:nil];
    }
    return self;
}

-(void)acceptObserver:(NSDictionary *)dict {
    NSString *log = [NSString stringWithFormat:@"_______%@",dict];
    int level = 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLog:LogLevel:WhichModule:)]) {
        [self.delegate onLog:log LogLevel:level WhichModule:@"InjectionFrameworkManage"];
    }
}

/**
 @brief Log回调
 @discussion
 1.实现TXLiveBaseDelegate，建议在一个比较早的初始化类中如AppDelegate
 2.在初始化中设置此回调，eg：[TXLiveBase sharedInstance].delegate = self;
 3.level类型参见TX_Enum_Type_LogLevel
 4.module值暂无具体意义，目前为固定值TXLiteAVSDK
 */
- (void)onLog:(NSString *)log LogLevel:(int)level WhichModule:(NSString *)module {
    if (level <= 0) {
        level = 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLog:LogLevel:WhichModule:)]) {
        [self.delegate onLog:log LogLevel:level WhichModule:module];
    }
    NSLog(@"%@",log);
}

/**
 * @brief NTP 校时回调，调用 TXLiveBase updateNetworkTime 后会触发
 * @param errCode 0：表示校时成功且偏差在30ms以内，1：表示校时成功但偏差可能在 30ms
 * 以上，-1：表示校时失败
 */
- (void)onUpdateNetworkTime:(int)errCode message:(NSString *)errMsg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onUpdateNetworkTime:message:)]) {
        [self.delegate onUpdateNetworkTime:errCode message:errMsg];
    }
}

/**
 @brief  setLicenceURL 接口回调, result = 0 成功，负数失败。
 @discussion
 需在调用 setLicenceURL 前设置 delegate
 */
- (void)onLicenceLoaded:(int)result Reason:(NSString *)reason {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLicenceLoaded:Reason:)]) {
        [self.delegate onLicenceLoaded:result Reason:reason];
    }
}
@end
