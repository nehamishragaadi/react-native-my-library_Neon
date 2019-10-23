#import "MyLibrary.h"
#import "MyLibrary-Swift.h"

@implementation MyLibrary
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
//    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
    
    NeoniosDemo *test = [[NeoniosDemo alloc]init];
    [test openNeutral];
}
@end
