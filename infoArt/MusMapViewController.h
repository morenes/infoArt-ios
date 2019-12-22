//
//  MusMapViewController.h
//  infoArt
//
//  Created by mac mini on 18/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Res.h"

@interface MusMapViewController : UIViewController{
    CGFloat lastScale;
    Sin * sin;
    int indice;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageMap;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)NextEvent:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonNext;

@end
