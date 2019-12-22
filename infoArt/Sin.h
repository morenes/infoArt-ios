//
//  Sin.h
//  infoArt
//
//  Created by mac mini on 7/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stat.h"

@interface Sin : NSObject
@property (strong,nonatomic) NSString * museo;
@property (nonatomic) int idioma;
@property (strong,nonatomic) NSMutableDictionary * mapaCuadros;
@property (strong,nonatomic) NSMutableArray * mapaNumeros;
@property (strong,nonatomic) NSMutableArray * mapaNumerosInv;
@property (strong,nonatomic) NSArray * arrayIdiomas;
@property (strong,nonatomic) NSDictionary* dicIdiomas;

@property (strong,nonatomic) NSDictionary* mapaMuseosLoc;
@property (strong,nonatomic) NSDictionary* mapaMuseosBeacon;
@property (strong,nonatomic) NSDictionary* mapaMuseosIdiomas;
@property (strong,nonatomic) NSString * cuenta;
@property (strong,nonatomic) Stat * stat;
@property (strong,nonatomic) NSUserDefaults * user;

@property (strong,nonatomic) NSString* codigo;
+ (Sin *) sharedInstance;
-(void) initial;
@end
