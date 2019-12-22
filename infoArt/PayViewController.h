//
//  PayViewController.h
//  infoArt
//
//  Created by mac mini on 27/12/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "PayPalMobile.h"
#import "Sin.h"
#import "UDPClient.h"
#import "Res.h"
#import "ToastView.h"
@interface PayViewController : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate,PayPalPaymentDelegate,UIPopoverControllerDelegate,UDPReceiverDelegate>{
    Sin * sin;
    UDPClient * client;
    NSString * token;
    int estado;
}

//PAYPAL
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
//@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
- (IBAction)paypayPress:(UIButton *)sender;
- (IBAction)applePress:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *paypalLabel;
@property (weak, nonatomic) IBOutlet UILabel *appleLabel;
@property (weak, nonatomic) IBOutlet UIButton *paypalButton;
@property (weak, nonatomic) IBOutlet UIButton *appleButton;
@end

