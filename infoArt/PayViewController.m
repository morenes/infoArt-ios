//
//  PayViewController.m
//  infoArt
//
//  Created by mac mini on 27/12/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "PayViewController.h"
#define kPayPalEnvironment PayPalEnvironmentProduction

@interface PayViewController ()
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sin=[Sin sharedInstance];
    NSString * text;
    estado=[[sin.user objectForKey:@"estados"] intValue];
    NSLog(@"estado %@",[sin.user objectForKey:@"estados"]);
    
    if (estado==4) text=NSLocalizedString(@"descripcion pago no",@"");
    else text=NSLocalizedString(@"descripcion pago",@"");
    NSMutableAttributedString * at=[[NSMutableAttributedString alloc] initWithString:text];
    [at addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] range:NSMakeRange(0,text.length)];
    [self.descriptionText setAttributedText:at];
    if (estado==4){
        [self.paypalLabel setText:@""];
        [self.paypalButton setHidden:YES];
    }
    else{
        [self.paypalLabel setText:NSLocalizedString(@"paypal",@"")];
        [self.paypalButton setHidden:NO];
    }
    
//    text=NSLocalizedString(@"apple",@"");
//    at=[[NSMutableAttributedString alloc] initWithString:text];
//    [at addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] range:NSMakeRange(0,text.length)];
//    [self.appleLabel setAttributedText:at];
    [self.appleLabel setText:@""];
    [self.appleButton setHidden:YES];
    
    
    client=[[UDPClient alloc] init];
    client.delegate=self;
    [self inicializarPaypal];
    [self comprobarPagoPaypal];
    [self comprobarPagoApple];
}

#pragma mark - Paypal methods
-(BOOL) comprobarPagoPaypal
{
    NSString * idPago=[sin.user objectForKey:[NSString stringWithFormat:@"%@idpagoP",sin.museo]];
    if (idPago!=nil){
        [self contactarServidorWithId:[NSString stringWithFormat:@"P%@",idPago]];
        return true;
    }
    return false;
}

-(void) inicializarPaypal
{
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"infoArt";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.environment = kPayPalEnvironment;
    [self setPayPalEnvironment:self.environment];
    //    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : sin.cuenta,
    //                                                           PayPalEnvironmentSandbox : @"AVP3_RmX-c3bM-sE2sVbirNlNbS6hTjahmS96updlW90l8x6uDzqflWM4VsN0mOkkOFle66ykkcFZmbB"}];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}


#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    [self sendCompletedPaymentToServer:completedPayment];
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    NSDictionary * response=[completedPayment.confirmation objectForKey:@"response"];
    NSString * idPago=[response objectForKey:@"id"];
    [sin.user setObject:idPago forKey:[NSString stringWithFormat:@"%@idpagoP",sin.museo]];
    [self contactarServidorWithId:[NSString stringWithFormat:@"P%@",idPago]];
}


#pragma mark - Apple methods
#pragma mark - InApp Purchase Methods

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"%@",response);
    if(response.products.count > 0)
    {
        SKProduct *product = [response.products objectAtIndex:0];
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        NSLog(@"No hay productos");
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"%@",transaction);
                NSLog(@"%@",[transaction transactionIdentifier]);
                NSLog(@"%@",[transaction payment]);
                NSLog(@"%@",[[transaction payment] productIdentifier]);
                [self paymentFinishedWithId:[transaction transactionIdentifier]];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
                
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"Transaction Failed");
                NSLog(@"%ld",(long)[[transaction payment] quantity]);
                NSLog(@"%@",[[transaction payment] productIdentifier]);
                //[self contactarServidorWithId:[NSString stringWithFormat:@"A%@",[[transaction payment] productIdentifier]]];
                NSLog(@"%@",transaction.transactionIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
                
            default:
                break;
        }
    }
}
-(bool) comprobarPagoApple
{
    NSString * idPago=[sin.user objectForKey:[NSString stringWithFormat:@"%@idpagoA",sin.museo]];
    if (idPago!=nil){
        [self contactarServidorWithId:idPago];
        return true;
    }
    return false;
}

- (void)paymentFinishedWithId:(NSString *)order
{
    [sin.user setObject:order forKey:[NSString stringWithFormat:@"%@idpagoA",sin.museo]];
    [self contactarServidorWithId:[NSString stringWithFormat:@"A%@",order]];
}
#pragma mark -  PaypalPressButton

- (IBAction)paypayPress:(UIButton *)sender {
    if (![self comprobarPagoPaypal]){
        PayPalItem *item1 = [PayPalItem itemWithName:NSLocalizedString(@"comprar codigo",@"")
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"2.2"]
                                        withCurrency:@"EUR"
                                             withSku:@"infoArt"];
        NSArray *items = @[item1];
        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = subtotal;
        payment.currencyCode =@"EUR";
        payment.shortDescription =NSLocalizedString(@"comprar codigo",@"");
        payment.items = items;
        
        if (!payment.processable) {
        }
        self.payPalConfig.acceptCreditCards = true;
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                    configuration:self.payPalConfig
                                                                                                         delegate:self];
        if (paymentViewController!=nil)[self presentViewController:paymentViewController animated:YES completion:nil];
    }
}
#pragma mark -  ApplePressButton
- (IBAction)applePress:(UIButton *)sender {
    if (![self comprobarPagoApple]){
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        NSArray *array = @[@"infoArt_payment_3"];
        if([SKPaymentQueue canMakePayments])
        {
            SKProductsRequest *skpr = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:array]];
            skpr.delegate = self;
            [skpr start];
        }
        else {
            NSLog(@"In-App Purcharse deshabilitado");
        }
    }
}
#pragma mark - server methods
- (void) contactarServidorWithId:(NSString *)order
{
    token=order;
    [client send:[NSString stringWithFormat:@"%@\\CODES\\<%@<%@",sin.museo,token,[Res info]] withType:PAYPAL];
    [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"obteniendo codigo", @"") withDuaration:1.0];
}
-(void) didReceiveString:(NSString *)string ofType:(int)tipo
{
    NSLog(@"String: %@ de tipo %d",string,tipo);
    NSArray * cad=[string componentsSeparatedByString:@"<"];
    NSString * code;
    NSString * tokenRec;
    if ([cad count]>=2){
        code=cad[0];
        tokenRec=cad[1];
    }
    if (tipo==PAYPAL&&code!=nil&&tokenRec!=nil&&[tokenRec isEqualToString:token]){
        [ToastView showToastInParentView:self.view withText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"codigo recibido", @""),code] withDuaration:2.0];
        if ([[token substringToIndex:1] isEqualToString:@"A"])[sin.user removeObjectForKey:[NSString stringWithFormat:@"%@idpagoA",sin.museo]];
        else [sin.user removeObjectForKey:[NSString stringWithFormat:@"%@idpagoP",sin.museo]];
        
        [sin.user setObject:code forKey:[NSString stringWithFormat:@"CODIGO%@",sin.museo]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else{
        [client send:[NSString stringWithFormat:@"%@\\CODES\\<%@<%@",sin.museo,token,[Res info]] withType:PAYPAL];
    }
}

@end
