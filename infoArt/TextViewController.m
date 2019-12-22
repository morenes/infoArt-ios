//
//  TextViewController.m
//  infoArt
//
//  Created by mac mini on 23/12/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "TextViewController.h"
#import "ToastView.h"
@interface TextViewController ()
@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sin=[Sin sharedInstance];
    //self.texto=@"COMUN/INFOART0.txt";
    NSLog(@"1.1%@",self.texto);
    //self.textView.backgroundColor=[UIColor blueColor];
    
    if (![self.texto isEqual:@""]){
        self.textView.text=[[Res loadTextString:self.texto] stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSLog(@"2%@",[[Res loadTextString:self.texto] stringByReplacingOccurrencesOfString:@">" withString:@""]);
        [self.textView setEditable:false];
        [self.sendButton setEnabled:false];
    }
    else{
        client=[[UDPClient alloc] init];
        client.delegate=self;
        self.textView.text=NSLocalizedString(@"escribe...",@"");
        [self.textView setEditable:true];
        [self.sendButton setTitle:NSLocalizedString(@"enviar",@"")];
        [self.sendButton setEnabled:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)sendEvent:(UIBarButtonItem *)sender {
    [sin.user setObject:self.textView.text forKey:@"BUZON"];
    if (![Res connected]) [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no conexion", @"") withDuaration:2.0];
    else{
        [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"enviando...", @"") withDuaration:1.0];
        [client send:[NSString stringWithFormat:@"%@\\BUZON\\%@<%@",sin.museo,[Res info],self.textView.text] withType:UDP_BUZON];
    }
    [self.textView resignFirstResponder];

}

-(void) didReceiveString:(NSString *)string ofType:(int)tipo
{
    NSLog(@"String: %@ de tipo %d",string,tipo);
    if (tipo==UDP_BUZON&&[string isEqual:@"OK"]){
        [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"enviado", @"") withDuaration:2.0];
        [sin.user removeObjectForKey:@"BUZON"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else{
        [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"enviando...", @"") withDuaration:1.0];
        [client send:[NSString stringWithFormat:@"%@\\BUZON\\%@<%@",sin.museo,[Res info],self.textView.text] withType:UDP_BUZON];
    }
}
@end
