//
//  MuseoViewController.h
//  infoArt
//
//  Created by mac mini on 6/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Download.h"
#import "UDPClient.h"
#import "Res.h"
#import "ListController.h"
#import "MainViewController.h"

@interface MuseoViewController : UIViewController <UITextFieldDelegate,DownloadHelperDelegate>
{
    Download * download;
    Sin * sin;
    BOOL lang;
    NSString* clavePulsada;
    UDPClient * client;
    NSString * archivoRecibido;
    UIProgressView * progressView;
    UIAlertView * av;
}
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *buttonLang;


- (IBAction)buttonEvent1:(UIButton *)sender;
- (IBAction)buttonEvent2:(UIButton *)sender;
- (IBAction)buttonEvent3:(UIButton *)sender;
- (IBAction)buttonLangEvent:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (IBAction)backButton:(UIBarButtonItem *)sender;



@end
