//
//  RangeViewController.h
//  infoArt
//
//  Created by mac mini on 6/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Res.h"
#import "Sin.h"
#import "PictureCell.h"
#import "MediaViewController.h"

extern const int TAM;
extern const int IMAGENES;
extern const int MAX;

@interface RangeViewController : UIViewController
{
    Sin * sin;
    NSMutableDictionary * mapList;
    NSMutableDictionary * mapPunt;
    NSMutableArray* imagenesOcupadas;
    NSMutableArray* rssiImagenes;
    NSArray* vistas;
    NSDictionary * mapaCuadros;
    NSString * clavePulsada;
}
@end