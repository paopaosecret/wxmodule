//
//  InjectionFrameworkManage.h
//  InjectionFramework
//
//  Created by WesleyLei on 2022/5/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FrameworkHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface InjectionFrameworkManage : NSObject<TXLiveBaseDelegate>

@property (strong, nonatomic) NSMutableDictionary *cache;
@property(nonatomic, weak, nullable) id<TXLiveBaseDelegate> delegate;
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
