//
//  MainViewController.m
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//
#import "MainViewController.h"

@implementation MainViewController
@synthesize button1,button2,buttonLang;

#pragma-mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    sin=[Sin sharedInstance];
    [sin initial];
    sin.idioma=0;
    sin.stat=[[Stat alloc] init];
    [sin.stat initial];
    client=[UDPClient sharedInstance];
    client.delegate=self;
    download=[Download sharedInstance];
    download.delegate=self;
    button1.hidden=YES;

//        [Res filesFromDir:@""];
//        [Res removeFromDir:@"Teatro Romano"];
//        [sin.user removeObjectForKey:[NSString stringWithFormat:@"CODIGO%@",@"Teatro Romano"]];
//        [sin.user removeObjectForKey:[NSString stringWithFormat:@"PRI%@",@"Teatro Romano"]];
//        [sin.user removeObjectForKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,@"Teatro Romano"]];
//
    UIImage * image=[UIImage imageNamed:@"fondo2.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [button2 setTitle:[NSString stringWithFormat:@"  %@ »  ",NSLocalizedString(@"selecciona museo", @"")] forState:UIControlStateNormal];
    
    //Si no están las cosas cosas comunes hay que pedir la URL del común
    if (![Res existeFicheroRutaRelativa:@"COMUN"]){
        [Res generateIDEN];
        if (![Res connected]) [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no conexion", @"") withDuaration:2.0];
        else [client send:@"URL" withType:URL];
    } else{
        //Si ya están, simplemente se leen de disco
        if ([Res obtenerCosasComunes]){
            lang=true;
            //Nos vamos a elegir idioma
            [self performSegueWithIdentifier:@"MainListSegue" sender:nil];
        }
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage * im=[Res loadImageString:[NSString stringWithFormat:@"COMUN/IDIOMA%d.jpg",sin.idioma]];
    if (im) [self.buttonLang setImage:im forState:UIControlStateNormal];
    else{
        if (![Res existeFicheroRutaRelativa:@"COMUN"]){
            if (![Res connected]) [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no conexion", @"") withDuaration:2.0];
            else [client send:@"URL" withType:URL];
        }
    }
    if(sin.museo){ //Si hay algun museo localizado
        button1.hidden=NO;
        [button1 setTitle:[NSString stringWithFormat:@"  %@ »  ",[[NSString alloc] initWithFormat:NSLocalizedString(@"comenzar %@", @""),sin.museo]] forState:UIControlStateNormal];
        [self descargaPRI];
        //if ([self descargaPRI]&&[sin.user objectForKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,sin.museo]];
        //[self performSegueWithIdentifier:@"MainMuseoSegue" sender:nil];
    }else{
        
        sin.museo=[sin.user objectForKey:@"ULTIMO"];
        if (sin.museo){
            button1.hidden=NO;
            [button1 setTitle:[NSString stringWithFormat:@"  %@ »  ",[[NSString alloc] initWithFormat:NSLocalizedString(@"comenzar %@", @""),sin.museo]] forState:UIControlStateNormal];
        }
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestWhenInUseAuthorization];
        [self startMonitoring];
    }
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self stopMonitoring];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Dependiendo si se va a elegir idioma o museo
    if([[segue identifier] isEqualToString:@"MainListSegue"])
    {
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
            controller.opciones=sin.mapaMuseosBeacon.allKeys;
            controller.tipo=MUSEOS;
        }
    }
}
#pragma mark - Button Methods
- (IBAction)buttonEvent:(UIButton *)sender {
    NSLog(@"boton1 pulsado");
    NSString* aux=[sin.user objectForKey:[NSString stringWithFormat:@"CODIGO%@",sin.museo]];
    if ([sin.museo isEqualToString:@"infoArt"]) aux=@"code";
    if (!aux) [self alertaCodigo];
    else if([self descargaPRI]&&[self descargaINFO]) [self performSegueWithIdentifier:@"MainMuseoSegue" sender:nil];
}

- (IBAction)buttonEvent2:(UIButton *)sender {
    //    [Res filesFromDir:@""];
    //    [Res filesFromDir:@"COMUN"];
    //    [Res filesFromDir:sin.museo];
    //    [Res filesFromDir:[NSString stringWithFormat:@"%@/PRI",sin.museo]];
    
    [self performSegueWithIdentifier:@"MainListSegue" sender:nil];
    
}
- (IBAction)buttonLang:(UIButton *)sender {
    lang=true;
    [self performSegueWithIdentifier:@"MainListSegue" sender:nil];
}

#pragma mark - Dialog code
-(void) alertaCodigo
{
    int estado=[[sin.user objectForKey:@"estados"] intValue];
    UIAlertView *alert;
    if (estado==4)
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codigo de verificacion", @"") message:NSLocalizedString(@"introducir codigo", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancelar", @"") otherButtonTitles:NSLocalizedString(@"comprobar", @""),nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codigo de verificacion", @"") message:NSLocalizedString(@"introducir codigo", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancelar", @"") otherButtonTitles:NSLocalizedString(@"comprobar", @""), NSLocalizedString(@"obtener", @""),nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[alertView textFieldAtIndex:0] endEditing:YES];
    if(alertView.tag == 1){
        if (buttonIndex==1){
            NSString * codigo = [alertView textFieldAtIndex:0].text;
            if ((codigo.length>0)&&[self comprobarCodigo:codigo]&&[self descargaPRI]&&[self descargaINFO])
                [self performSegueWithIdentifier:@"MainMuseoSegue" sender:nil];
        }else if (buttonIndex==2){
            if (![Res connected]) [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no conexion", @"") withDuaration:2.0];
            else [self performSegueWithIdentifier:@"MainPaySegue" sender:nil];

        }
    } else if(alertView.tag == 2){
        NSLog(@"Ha cancelado");
        progressView=nil;
        [Download cancel];
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

-(BOOL) comprobarCodigo:(NSString*)codigo
{
    NSString* aux=[sin.user objectForKey:[NSString stringWithFormat:@"CODIGO%@",sin.museo]];
    if (!aux){
        NSString * mensaje=[NSString stringWithFormat:@"%@\\CODES\\%@<%@",sin.museo,codigo,[Res info]];
        NSLog(@"%@",mensaje);
        codigoActual=codigo;
        if (![Res connected]) [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no conexion", @"") withDuaration:2.0];
        else [client send:mensaje withType:CODIGO];
        return false;
    } return true;
}
#pragma mark - Descargas
-(BOOL) descargaPRI
{
    if (![sin.user objectForKey:[NSString stringWithFormat:@"PRI%@",sin.museo]]) {
        if (![Res connected]) [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no conexion", @"") withDuaration:2.0];
        else{
            [client send:[NSString stringWithFormat:@"%@\\PRI",sin.museo] withType:URL];
        }
        return false;
    } else{
        [Res obtenerListado];
        return true;
    }
}

-(BOOL) descargaINFO
{
    if (![sin.user objectForKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,sin.museo]]) {
        archivoRecibido=[NSString stringWithFormat:@"%@/INFO%d.zip",sin.museo,sin.idioma];
        NSString * url=[Res loadTextString:[NSString stringWithFormat:@"%@/PRI/INFO%d.txt",sin.museo,sin.idioma]];
        NSLog(@"%@",url);
        if (![Res connected]) [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no conexion", @"") withDuaration:2.0];
        else [Download download:url withPath:archivoRecibido];
        return false;
    } else{
        return true;
    }
}
#pragma-mark DownloadDelegate
//HTTP RECEIVER
- (void) didReceiveData: (NSData *) theData{
    NSLog(@"han llegado los datos bien");
    [av dismissWithClickedButtonIndex:0 animated:NO];
    progressView=nil;
    NSLog(@"%@",[archivoRecibido substringToIndex:archivoRecibido.length-4]);
    [Res descomprimir:[archivoRecibido substringToIndex:archivoRecibido.length-4]];
    
    //Dependiendo de lo que se haya recibido se actua de una manera o de otra
    
    if ([archivoRecibido containsString:@"PRI"]){
        [Res obtenerListado];
        [sin.user setObject:@"OK" forKey:[NSString stringWithFormat:@"PRI%@",sin.museo]];

    } else if([archivoRecibido containsString:@"COMUN"]){
        if ([Res obtenerCosasComunes]){
            lang=true;
            [self performSegueWithIdentifier:@"MainListSegue" sender:nil];
        }
        
    } else if ([archivoRecibido containsString:@"INFO"]){
        [sin.user setObject:@"OK" forKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,sin.museo]];
        [self performSegueWithIdentifier:@"MainMuseoSegue" sender:nil];
    }
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

#pragma-mark UDPDelegate
//UDP RECEIVER
-(void) didReceiveString:(NSString *)string ofType:(int)tipo
{
    NSLog(@"String: %@ de tipo %d",string,tipo);
    switch (tipo) {
        case URL:{
            //Cuando recibe la URL del común, la descarga automaticamente
            if ([[string componentsSeparatedByString:@"<"] count]>1){
                archivoRecibido=@"COMUN.zip";
                [Download download:[string substringFromIndex:4] withPath:archivoRecibido];
                NSLog(@"estado %@",[string substringToIndex:3]);
                NSLog(@"estado2 %@",[[string substringToIndex:3] substringFromIndex:2]);
                [sin.user setObject:[[string substringToIndex:3] substringFromIndex:2] forKey:@"estados"];
                NSLog(@"estado3 %@",[sin.user objectForKey:@"estados"]);

            }else{
                archivoRecibido=[NSString stringWithFormat:@"%@",sin.museo];
                [[NSFileManager defaultManager] createDirectoryAtPath:[Res getDirWithString:archivoRecibido] withIntermediateDirectories:NO attributes:nil error:nil];
                archivoRecibido=[archivoRecibido stringByAppendingString:@"/PRI.zip"];
                NSLog(@"Voy a descargar %@",archivoRecibido);
                [Download download:string withPath:archivoRecibido];

            }
            break;
        }
        case CODIGO:{
            if((string!=nil)&&([string isEqualToString:@"vacio"]||[string isEqualToString:[Res info]])){
                //guarda el codigo en la persistencia
                [sin.user setObject:codigoActual forKey:[NSString stringWithFormat:@"CODIGO%@",sin.museo]];
                
                //descarga lo que falte
                if ([self descargaPRI]&&[self descargaINFO])
                    [self performSegueWithIdentifier:@"MainMuseoSegue" sender:nil];
            }
            break;
        }
        case ESTADISTIC:
            [sin.user setObject:string forKey:@"DESTACADOS"];
            break;
        case UDP_BUZON:
            [sin.user removeObjectForKey:@"BUZON"];
        default:
            break;
    }
}
#pragma mark - Beacon methods
- (void)startMonitoring {
    CLBeaconRegion *beaconRegion =[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] identifier:@"local"];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoring {
    CLBeaconRegion *beaconRegion =[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] identifier:@"local"];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}
- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Ha entrado: %@",region.description);
}
-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Ha salido: %@",region.description);
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    NSInteger size=[beacons count];
    if (size>0)
        for (CLBeacon *beacon in beacons)
            for(NSString * museo in [sin.mapaMuseosBeacon allKeys])
                if ([[sin.mapaMuseosBeacon valueForKey:museo] isEqualToString:[NSString stringWithFormat:@"%@,%@",beacon.minor,beacon.major]]){
                    sin.museo=museo;
                    [self stopMonitoring];
                    button1.hidden=NO;
                    [button1 setTitle:[NSString stringWithFormat:@"  %@ »  ",[[NSString alloc] initWithFormat:NSLocalizedString(@"comenzar %@", @""),sin.museo]] forState:UIControlStateNormal];
                    return;
                }
        
}
@end