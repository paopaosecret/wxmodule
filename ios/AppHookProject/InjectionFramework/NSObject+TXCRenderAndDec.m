//
//  NSObject+TXCRenderAndDec.m
//  InjectionFramework
//
//  Created by WesleyLei on 2022/6/10.
//

#import "NSObject+TXCRenderAndDec.h"
#import "NSObject+injection_exchange.h"

@protocol TXCRenderAndDecProtocol <NSObject>
@property(nonatomic, assign) BOOL enableVideoHWAcceleration;
@end


@implementation NSObject (TXCRenderAndDec)
+ (void)injectionTXCRenderAndDec {
    Class TXCRenderAndDecClass = NSClassFromString(@"TXCRenderAndDec");
    [TXCRenderAndDecClass injectionExchangeInstanceMethod:@selector(onDecodeFrame:FrameType:StreamType:FrameIndex:FramePTS:FrameDTS:FrameRotation:ErrorCode:) withMethod:@selector(injection_TXCRenderAndDec_onDecodeFrame:FrameType:StreamType:FrameIndex:FramePTS:FrameDTS:FrameRotation:ErrorCode:)];
    
    [TXCRenderAndDecClass injectionExchangeInstanceMethod:@selector(createDecoder) withMethod:@selector(injection_TXCRenderAndDec_createDecoder)];
    
    [TXCRenderAndDecClass injectionExchangeInstanceMethod:@selector(init) withMethod:@selector(injection_TXCRenderAndDec_init)];
    
    [TXCRenderAndDecClass injectionExchangeInstanceMethod:@selector(getCurrentDecoderFactory) withMethod:@selector(injection_TXCRenderAndDec_getCurrentDecoderFactory)];
    
    
    
    Class TXCSWCustomVideoDecoderClass = NSClassFromString(@"TXCSWCustomVideoDecoder");
    
    [TXCSWCustomVideoDecoderClass injectionExchangeInstanceMethod:@selector(start:) withMethod:@selector(injection_TXCSWCustomVideoDecoder_start:)];
}

- (void)injection_TXCRenderAndDec_onDecodeFrame:(id)sampleBuffer
            FrameType:(NSUInteger)frameType
           StreamType:(NSUInteger)streamType
           FrameIndex:(NSUInteger)frameIndex
             FramePTS:(UInt64)pts
             FrameDTS:(UInt64)dts
        FrameRotation:(UInt8)rotation
            ErrorCode:(NSUInteger)errCode {
    errCode = [self getErrocoe];
    NSLog(@"injection_TXCRenderAndDec_onDecodeFrame");
    [self injection_TXCRenderAndDec_onDecodeFrame:sampleBuffer
                                        FrameType:frameType
                                       StreamType:streamType
                                       FrameIndex:frameIndex
                                         FramePTS:pts
                                         FrameDTS:dts
                                    FrameRotation:rotation
                                        ErrorCode:errCode];
}

- (void)injection_TXCRenderAndDec_createDecoder {
    NSLog(@"injection_TXCRenderAndDec_createDecoder");
    [self injection_TXCRenderAndDec_createDecoder];
}

- (id)injection_TXCRenderAndDec_init {
    NSLog(@"injection_TXCRenderAndDec_init");
    id <TXCRenderAndDecProtocol> obj = [self injection_TXCRenderAndDec_init];
//    obj.enableVideoHWAcceleration = YES;
    return obj;
}

- (NSInteger)injection_TXCSWCustomVideoDecoder_start:(BOOL)bH265 {
    NSLog(@"injection_TXCSWCustomVideoDecoder_start:%@",@(bH265));
    return [self injection_TXCSWCustomVideoDecoder_start:bH265];
}

- (id)injection_TXCRenderAndDec_getCurrentDecoderFactory {
    id obj = [self injection_TXCRenderAndDec_getCurrentDecoderFactory];
    NSLog(@"injection_TXCRenderAndDec_getCurrentDecoderFactory :%@",obj);
    return obj;
}



- (NSInteger) getErrocoe {
    static NSInteger code = 10010007;
    NSInteger errorCode = code;
    if (code != 0) {
        code = 0;
    }
    return  errorCode;
}
@end
