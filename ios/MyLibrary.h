#import <React/RCTBridgeModule.h>
#import <React/RCTBridgeModule.h>


NS_ASSUME_NONNULL_BEGIN


@interface MyLibrary : NSObject <RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END


// CalendarManagerBridge.m
@interface RCT_EXTERN_REMAP_MODULE(RNDemo, DemoSwift, NSObject)

//@interface RCT_EXTERN_MODULE(demo, NSObject)

//RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(nonnull NSNumber *)date callback: (RCTResponseSenderBlock)callback);
RCT_EXTERN_METHOD(showName)
@end
