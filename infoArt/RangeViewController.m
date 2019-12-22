//
//  RangeViewController.m
//  infoArt
//
//  Created by mac mini on 6/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "RangeViewController.h"
const int TAM=5;
const int MAX=-5000;
const int IMAGENES=8;
@import CoreLocation;
@interface RangeViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation RangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemsTableView.delegate=self;
    sin=[Sin sharedInstance];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self inicializacion];
    UIImageView * temp=[[UIImageView alloc]initWithImage:[Res loadImageString:[NSString stringWithFormat:@"%@/PRI/FONDO.jpg",sin.museo]]];
    [temp setFrame:self.itemsTableView.frame];
    self.itemsTableView.backgroundView=temp;
    //self.itemsTableView.backgroundColor=[UIColor colorWithPatternImage:[Res loadImageString:[NSString stringWithFormat:@"%@/PRI/FONDO.jpg",sin.museo]]];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    if (![sin.museo isEqualToString:@"infoArt"]) [self startMonitoring];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self stopMonitoring];
}
-(void) inicializacion
{
    if ([sin.museo isEqualToString:@"infoArt"]){
        imagenesOcupadas=[sin.mapaCuadros allValues];
        [self.itemsTableView reloadData];
    }else{
        mapaCuadros=sin.mapaCuadros;
        NSLog(@"%@",mapaCuadros);
        if (mapaCuadros==nil) [self.navigationController popToRootViewControllerAnimated:YES];
        mapList=[[NSMutableDictionary alloc]init];
        mapPunt=[[NSMutableDictionary alloc]init];
        NSArray * conjunto=[mapaCuadros allKeys];
        NSMutableArray * aux;
        for(NSString * string in conjunto){
            aux=[[NSMutableArray alloc] init];
            for(int i=0;i<5;i++)
                aux[i]=[NSNumber numberWithInt:MAX];
            [mapList setValue:aux forKey:string];
            [mapPunt setValue:[NSNumber numberWithInt:0] forKey:string];
        }
        imagenesOcupadas=[[NSMutableArray alloc] init];
        rssiImagenes=[[NSMutableArray alloc] init];
    }
}


-(NSInteger) tratarBeacon:(CLBeacon *)beacon
{
    NSString * iden=[NSString stringWithFormat:@"%@,%@",beacon.minor,beacon.major];
    NSNumber * punt=[mapPunt valueForKey:iden];
    NSMutableArray * lista=[mapList valueForKey:iden];
    NSInteger dis=beacon.rssi;
    //NSLog(@"disRssi=%ld",(long)dis);
    [lista insertObject:[NSNumber numberWithInteger:dis] atIndex:[punt integerValue]];
    [mapPunt setValue:[[NSNumber alloc] initWithInteger:([punt integerValue]+1)%TAM]forKey:iden];
    NSInteger distancia=0;
    for(int i=0;i<TAM;i++){
        NSInteger value=[[lista objectAtIndex:i] integerValue];
        //NSLog(@"value=%ld",(long)value);
        distancia+=value;
    }
    
    return distancia/TAM;
}

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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"RangeMediaSegue"])
    {
        MediaViewController * controller=[segue destinationViewController];
        controller.clave=clavePulsada;
    }
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
    [imagenesOcupadas removeAllObjects];
    [rssiImagenes removeAllObjects];
    NSInteger size=[beacons count];
    if (size>0){
        NSMutableArray *distancias=[[NSMutableArray alloc] init];
        NSMutableArray *claves=[[NSMutableArray alloc] init];
        NSInteger index=0;
        for (CLBeacon *beacon in beacons) {
            //            NSString *uuid = beacon.proximityUUID.UUIDString;
            //            NSString *major = [NSString stringWithFormat:@"%@", beacon.major];
            //            NSString *minor = [NSString stringWithFormat:@"%@", beacon.minor];
            //            NSString *rssi = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:beacon.rssi]];
            
            NSString * aux=[mapaCuadros valueForKey:[NSString stringWithFormat:@"%@,%@",beacon.minor,beacon.major]];
            if (aux!=nil){
                [claves insertObject:aux atIndex:index];
                NSInteger dis=[self tratarBeacon:beacon];
                //                NSLog(@"dis=%ld",(long)dis);
                [distancias insertObject:[NSNumber numberWithInteger:dis] atIndex:index];
                index++;
            }
        }
        NSInteger mayor;
        NSInteger indiceMayor=0;
        NSMutableArray *  auxiliar=[[NSMutableArray alloc] init];
        NSInteger i=0;
        while(indiceMayor!=-1)
        {
            indiceMayor=-1;
            mayor=MAX;
            for(NSInteger j=0;j<index;j++){
                if ([distancias objectAtIndex:j]>[NSNumber numberWithInteger:mayor]){
                    mayor=[[distancias objectAtIndex:j] integerValue];
                    indiceMayor=j;
                }
            }
            if (indiceMayor!=-1){
                NSString* key=[claves objectAtIndex:indiceMayor];
                if (![auxiliar containsObject:key]){
                    [imagenesOcupadas insertObject:key atIndex:i];
                    [rssiImagenes insertObject:[NSNumber numberWithInteger:mayor] atIndex:i];
                    i++;
                    [auxiliar addObject:key];
                }
                [distancias replaceObjectAtIndex:indiceMayor withObject:[NSNumber numberWithInteger:MAX]];
            }
        }
        [self.itemsTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return imagenesOcupadas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PCell";
    PictureCell *cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString* key=imagenesOcupadas[indexPath.row];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureCell" owner:self options:nil] objectAtIndex:0];
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = [UIColor clearColor];
        //cell.alpha=0.1f;
        cell.buttonGo.tag=indexPath.row;
        [cell.buttonGo addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSString * aux=[sin.mapaNumerosInv[0] objectForKey:key];
    [cell configWithPicture:[Res loadImageString:[NSString stringWithFormat:@"%@/PRI/%@.jpg",sin.museo,key]] title:[sin.mapaNumeros[sin.idioma] objectForKey:aux] val:aux];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//-(void) didSelect:(UIButton*)sender
{
    NSInteger index=[indexPath row];//sender.tag;
    clavePulsada = [imagenesOcupadas objectAtIndex:index];//sender.tag];
    NSString * aux=[sin.mapaNumerosInv[0] objectForKey:clavePulsada];
    [sin.stat add:true Lista:1 elem:aux];
    NSLog(@"%@",[sin.stat sendToServer]);
    [self performSegueWithIdentifier:@"RangeMediaSegue" sender:nil];
}

@end