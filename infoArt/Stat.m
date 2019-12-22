//
//  Stat.m
//  infoArt
//
//  Created by mac mini on 17/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "Stat.h"
#import "UDPClient.h"
@implementation Stat
@synthesize vistosBeacon,vistosBuscar,vistosDes,vistosFav,favoritos;
-(void) initial
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    vistosBeacon=[[user objectForKey:@"vistosBeacon"] mutableCopy];
    if (vistosBeacon==nil){
        vistosBeacon=[[NSMutableArray alloc] init];
        vistosFav=[[NSMutableArray alloc] init];
        vistosDes=[[NSMutableArray alloc] init];
        vistosBuscar=[[NSMutableArray alloc] init];
        favoritos=[[NSMutableArray alloc] init];
        [self makePersistant];
    } else{
        vistosFav=[[user objectForKey:@"vistosFav"] mutableCopy];
        vistosDes=[[user objectForKey:@"vistosDes"] mutableCopy];
        vistosBuscar=[[user objectForKey:@"vistosBuscar"] mutableCopy];
        favoritos=[[user objectForKey:@"favoritos"] mutableCopy];
    }
}

-(void) makePersistant
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    [user setObject:vistosBeacon forKey:@"vistosBeacon"];
    [user setObject:vistosFav forKey:@"vistosFav"];
    [user setObject:vistosDes forKey:@"vistosDes"];
    [user setObject:vistosBuscar forKey:@"vistosBuscar"];
    [user setObject:favoritos forKey:@"favoritos"];
}

-(NSString*) sendToServer
{
    
    NSString * salida=[vistosBeacon componentsJoinedByString:@","];
    NSLog(@"%@",salida);
    salida=[salida stringByAppendingString:@">"];
    salida=[salida stringByAppendingString:[vistosFav componentsJoinedByString:@","]];
    salida=[salida stringByAppendingString:@">"];
    salida=[salida stringByAppendingString:[vistosDes componentsJoinedByString:@","]];
    salida=[salida stringByAppendingString:@">"];
    salida=[salida stringByAppendingString:[vistosBuscar componentsJoinedByString:@","]];
    salida=[salida stringByAppendingString:@">"];
    salida=[salida stringByAppendingString:[favoritos componentsJoinedByString:@","]];
    salida=[salida stringByAppendingString:@">"];
    salida=[salida stringByAppendingString:@"true"];
    return salida;
    
}

-(BOOL) add:(BOOL)add Lista:(int)lista elem:(NSString*)elem
{
    NSMutableArray * array;
    switch(lista){
        case 1: array=vistosBeacon; break;
        case 2: array=vistosFav; break;
        case 3: array=vistosDes; break;
        case 4: array=vistosBuscar; break;
        case 5: array=favoritos; break;
    }
    if((add&&(![array containsObject:elem]))||(!add&&[array containsObject:elem])){
        if (add) [array addObject:elem];
        else [array removeObject:elem];
        NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
        switch(lista){
            case 1: [user setObject:array forKey:@"vistosBeacon"]; break;
            case 2: [user setObject:array forKey:@"vistosFav"]; break;
            case 3: [user setObject:array forKey:@"vistosDes"]; break;
            case 4: [user setObject:array forKey:@"vistosBuscar"]; break;
            case 5: [user setObject:array forKey:@"favoritos"]; break;
        }
        return true;
    }
    return false;
}
@end
