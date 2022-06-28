//
//  NSObject+injection_exchange.h
//  InjectionFramework
//
//  Created by WesleyLei on 2022/3/2.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
//#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [Line %d] ------ %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif
@interface NSObject (injection_exchange)
+ (void)injectionExchangeClassMethod:(SEL)origSelector withMethod:(SEL)newSelector;
+ (void)injectionExchangeInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector;
- (void)showAllClassFunction;
@end

NS_ASSUME_NONNULL_END
