//
//  Stat.h
//  infoArt
//
//  Created by mac mini on 17/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stat : NSObject

@property (strong,nonatomic) NSMutableArray * vistosBeacon;
@property (strong,nonatomic) NSMutableArray * vistosFav;
@property (strong,nonatomic) NSMutableArray * vistosDes;
@property (strong,nonatomic) NSMutableArray * vistosBuscar;
@property (strong,nonatomic) NSMutableArray * favoritos;

-(void) initial;
-(void) makePersistant;
-(NSString*) sendToServer;
-(BOOL) add:(BOOL)add Lista:(int)lista elem:(NSString*)elem;
@end
