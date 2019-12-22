//
//  MuseoViewController.m
//  infoArt
//
//  Created by mac mini on 6/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "MuseoViewController.h"

@interface MuseoViewController ()

@end

@implementation MuseoViewController
@synthesize button1,button2,button3;

- (void)viewDidLoad {
    [super viewDidLoad];
    sin=[Sin sharedInstance];
    client=[UDPClient sharedInstance];
    download=[Download sharedInstance];
    download.delegate=self;
    [button1 setTitle:[NSString stringWithFormat:@"  %@ »  ",NSLocalizedString(@"comenzar visita", @"")] forState:UIControlStateNormal];
    [button2 setTitle:[NSString stringWithFormat:@"  %@ »  ",NSLocalizedString(@"buscar por numero", @"")] forState:UIControlStateNormal];
    [button3 setTitle:[NSString stringWithFormat:@"  %@ »  ",NSLocalizedString(@"mapas e informacion", @"")] forState:UIControlStateNormal];
    
    [sin.user setObject:sin.museo forKey:@"ULTIMO"];
}
-(void)viewWillAppear:(BOOL)animated{
    UIImage* foto=[Res loadImageString:[NSString stringWithFormat:@"%@/PRI/PORTADA.jpg",sin.museo]];
    [self.image setImage:foto];
    [client send:[NSString stringWithFormat:@"%@\\LIKES\\%@<%@",sin.museo,[Res info],[sin.stat sendToServer]] withType:ESTADISTIC];
    NSString * texto=[sin.user objectForKey:@"BUZON"];
    if (texto!=nil) [client send:[NSString stringWithFormat:@"%@\\BUZON\\%@<%@",sin.museo,[Res info],texto] withType:UDP_BUZON];
    
    [self.buttonLang setImage:[Res loadImageString:[NSString stringWithFormat:@"COMUN/IDIOMA%d.jpg",sin.idioma]] forState:UIControlStateNormal];
    if (![sin.user objectForKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,sin.museo]])
        [self descargaINFO];
    
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"MuseoListSegue"])
    {
        //Elegir idioma
        ListController * controller=[segue destinationViewController];
        if (lang){
            lang=false;
            NSMutableArray * array=[[NSMutableArray alloc] init];
            for (NSString * num in [[sin.mapaMuseosIdiomas objectForKey:sin.museo] componentsSeparatedByString:@"<"]){
                [array addObject:sin.arrayIdiomas[num.intValue]];
            }
            controller.opciones=array;
            controller.tipo=IDIOMAS;
        }else{
            //Elegir opciones
            controller.tipo=OPCIONES;
            controller.opciones=[[NSArray alloc] initWithObjects:NSLocalizedString(@"mapa museo", @""),NSLocalizedString(@"destacados", @""),NSLocalizedString(@"mis favoritos", @""),NSLocalizedString(@"informacion del museo", @""),NSLocalizedString(@"museos visitados", @""),NSLocalizedString(@"mapa museos infoart", @""),NSLocalizedString(@"buzon sugerencias", @""),NSLocalizedString(@"sobre la app", @""), nil];
        }
    } else if([[segue identifier] isEqualToString:@"MuseoMediaSegue"])//Ir al audioguia
    {
        MediaViewController * controller=[segue destinationViewController];
        controller.clave=clavePulsada;
    }
}

#pragma mark - Button methods
- (IBAction)buttonEvent1:(UIButton *)sender {
    [self performSegueWithIdentifier:@"RangeSegue" sender:nil];
}

- (IBAction)buttonEvent2:(UIButton *)sender {
    [self dialogBuscarNumero];
}

- (IBAction)buttonEvent3:(UIButton *)sender {
    [self performSegueWithIdentifier:@"MuseoListSegue" sender:nil];
}

- (IBAction)buttonLangEvent:(UIButton *)sender {
    lang=true;
    [self performSegueWithIdentifier:@"MuseoListSegue" sender:nil];
}

#pragma mark - Dialog code
-(void) dialogBuscarNumero
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"buscar guia", @"") message:NSLocalizedString(@"introducir numero", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancelar", @"") otherButtonTitles:NSLocalizedString(@"aceptar", @""), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[alertView textFieldAtIndex:0] endEditing:YES];
    NSString * codigo = [alertView textFieldAtIndex:0].text;
    if ((codigo.length>0)&&[self comprobarNumero:codigo])
        [self performSegueWithIdentifier:@"MuseoMediaSegue" sender:nil];
}

-(BOOL) comprobarNumero:(NSString*)numero
{
    NSString* clave=[sin.mapaNumeros[0] objectForKey:numero];
    if (clave!=NULL) [sin.stat add:true Lista:4 elem:numero];
    clavePulsada=clave;
    return clave;
}

#pragma mark - Download methods
-(BOOL) descargaINFO
{
    if (![sin.user objectForKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,sin.museo]]) {
        archivoRecibido=[NSString stringWithFormat:@"%@/INFO%d.zip",sin.museo,sin.idioma];
        NSString * url=[Res loadTextString:[NSString stringWithFormat:@"%@/PRI/INFO%d.txt",sin.museo,sin.idioma]];
        NSLog(@"%@",url);
        [Download download:url withPath:archivoRecibido];
        return false;
    } else{
        return true;
    }
}
//Muestra la barra de progreso
-(void) startProgress
{
    av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"descargando",@"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancelar", @"") otherButtonTitles:nil];
    av.tag = 2;
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.frame = CGRectMake(15, 0, 170, 25);
    progressView.bounds = CGRectMake(15, 0, 170, 25);
    progressView.backgroundColor = [UIColor blackColor];
    [progressView setUserInteractionEnabled:NO];
    [progressView setTrackTintColor:[UIColor lightGrayColor]];
    [progressView setProgressTintColor:[UIColor blueColor]];
    [av setValue:progressView forKey:@"accessoryView"];
    [av show];
}
#pragma-mark DownloadDelegate
//HTTP RECEIVER
- (void) didReceiveData: (NSData *) theData{
    NSLog(@"han llegado los datos bien");
    [av dismissWithClickedButtonIndex:0 animated:NO];
    progressView=nil;
    NSLog(@"%@",[archivoRecibido substringToIndex:archivoRecibido.length-4]);
    [Res descomprimir:[archivoRecibido substringToIndex:archivoRecibido.length-4]];
    [sin.user setObject:@"OK" forKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,sin.museo]];
}
- (void) didReceiveFilename: (NSString *) aName{
    NSLog(@"FILENAME: %@",aName);
}
- (void) dataDownloadFailed: (NSString *) reason{
    NSLog(@"%@",reason);
}
- (void) dataDownloadAtPercent: (NSNumber *) aPercent{
    NSLog(@"%@",aPercent);
    float aux=[aPercent floatValue];
    if(!progressView) [self startProgress];
    progressView.progress=aux;
    av.message=[NSString stringWithFormat:@"%d%%",(int)(aux*100)];
}

- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"MuseoMainSegue" sender:nil];
}
@end



