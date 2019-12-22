//
//  MapController.h
//  WhatsDog
//
//  Created by secondlemon on 21/08/15.
//  Copyright (c) 2015 SecondLemon. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RMMapView.h"
#import "RMMarkerManager.h"
#import "Sin.h"
#import "TextViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapController : UIViewController <RMMapViewDelegate>
{
    RMMarker *myMarker;
    RMMapContents *contents;
    CLLocationManager *locationManager;
    Sin * sin;
    NSString * museo;
    
}
@property (strong, nonatomic) RMMapView *mapView;


@end