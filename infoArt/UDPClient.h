#import <UIKit/UIKit.h>
#import "Res.h"


@protocol UDPReceiverDelegate <NSObject>
@required
- (void) didReceiveString:(NSString*)string ofType:(int)tipo;
@end

@interface UDPClient : NSObject
{
}
@property (strong,nonatomic) id <UDPReceiverDelegate> delegate;
+ (UDPClient *) sharedInstance;
- (void)send:(NSString *)string withType:(int)tipo;
@end
