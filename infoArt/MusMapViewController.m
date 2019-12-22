//
//  MusMapViewController.m
//  infoArt
//
//  Created by mac mini on 18/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "MusMapViewController.h"

@interface MusMapViewController () <UIGestureRecognizerDelegate,UIScrollViewDelegate>

@end

@implementation MusMapViewController
@synthesize imageMap;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sin=[Sin sharedInstance];
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=CGSizeMake(1280, 960);
    self.scrollView.delegate=self;
    indice=1;
    NSString * ruta=[NSString stringWithFormat:@"%@/PRI/MAPA%d.jpg",sin.museo,indice];
    if([Res existeFicheroRutaRelativa:ruta]){
        imageMap.image=[Res loadImageString:ruta];
        imageMap.contentMode=UIViewContentModeScaleAspectFit;
    } else [self.navigationController popToRootViewControllerAnimated:YES];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageMap;
}

- (IBAction)NextEvent:(UIBarButtonItem *)sender {
    indice++;
    NSString * ruta=[NSString stringWithFormat:@"%@/PRI/MAPA%d.jpg",sin.museo,indice];
    if([Res existeFicheroRutaRelativa:ruta]){
        imageMap.image=[Res loadImageString:ruta];
    } else{
        indice=1;
        ruta=[NSString stringWithFormat:@"%@/PRI/MAPA%d.jpg",sin.museo,indice];
        imageMap.image=[Res loadImageString:ruta];
    }
}
@end
