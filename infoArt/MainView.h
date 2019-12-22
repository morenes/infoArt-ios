//
//  MainView.h
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Download.h"

@interface MainView : UIViewController <DownloadHelperDelegate>
{
    Download * download;
}
@property (strong, nonatomic) IBOutlet UIView *view;
- (IBAction)button1:(UIButton *)sender;

@end
