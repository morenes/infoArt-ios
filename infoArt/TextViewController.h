//
//  TextViewController.h
//  infoArt
//
//  Created by mac mini on 23/12/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Res.h"
#import "UDPClient.h"

@interface TextViewController : UIViewController <UDPReceiverDelegate>
{
    UDPClient * client;
    Sin * sin;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (strong, nonatomic) NSString *texto;
- (IBAction)sendEvent:(UIBarButtonItem *)sender;
@end
