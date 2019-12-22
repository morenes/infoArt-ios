
#import "MapController.h"

@interface MapController ()

@end

@implementation MapController
@synthesize mapView;
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    sin=[Sin sharedInstance];
    CLLocation * loc=[sin.mapaMuseosLoc objectForKey:sin.museo];
    mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
                                  WithLocation:[[CLLocation alloc] initWithLatitude:loc.coordinate.latitude longitude:loc.coordinate.longitude].coordinate];
    //  [[mapView contents] setZoom:10.0];
    [mapView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:mapView];
   
    [mapView setDelegate:self];
    [mapView setDeceleration:YES];
    [mapView setEnableRotate:NO];
    
    //MARCADOR
    UIImage * xMarkerImage = [UIImage imageNamed:@"marker-C.png"];
    
    for(NSString * museos in sin.mapaMuseosLoc.allKeys){
        CLLocation * loc=[sin.mapaMuseosLoc objectForKey:museos];
        myMarker=[[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
        [myMarker changeLabelUsingText:museos font:[UIFont boldSystemFontOfSize:16]];
        [mapView.contents.markerManager addMarker:myMarker AtLatLong:loc.coordinate];
    }

}

#pragma mark Delegate methods

#pragma mark - gesture recognizer
-(void) tapOnMarker:(RMMarker *)marker onMap:(RMMapView *)map{
    UILabel * lab=(UILabel *)[marker label];
    museo=lab.text;
    [self goInfo];
    
}
-(void) tapOnLabelForMarker:(RMMarker *)marker onMap:(RMMapView *)map{
    UILabel * lab=(UILabel *)[marker label];
    museo=lab.text;
    [self goInfo];
}
-(void) goInfo
{
    NSLog(@"%@",museo);
    [self performSegueWithIdentifier:@"MapTextSegue" sender:nil];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"MapTextSegue"])
    {
        TextViewController* controller=[segue destinationViewController];
        controller.texto=[NSString stringWithFormat:@"COMUN/%@-INFOMUSEO%d.txt",museo,sin.idioma];
    }
}

-(void) afterMapMove: (RMMapView*) map {
}
-(void) afterMapZoom: (RMMapView*) map byFactor: (float) zoomFactor near:(CGPoint) center {
}
-(void) afterMapTouch:(RMMapView *)map{
}
-(void) singleTapOnMap:(RMMapView *)map At:(CGPoint)point{
}


@end