//
//  MainViewController.h
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Download.h"
#import "UDPClient.h"
#import "Res.h"
#import "Main.h"
#import "ToastView.h"
#import "ListController.h"

@interface MainViewController : UIViewController <DownloadHelperDelegate,UDPReceiverDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    Download * download;
    NSString * archivoRecibido;
    Sin * sin;
    BOOL lang;
    UDPClient * client;
    NSString * codigoActual;
    UIProgressView * progressView;
    UIAlertView * av;
}
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *buttonLang;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)buttonEvent:(UIButton *)sender;
- (IBAction)buttonEvent2:(UIButton *)sender;
- (IBAction)buttonLang:(UIButton *)sender;
-(BOOL) descargaINFO;
@end
