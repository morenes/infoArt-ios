//
//  Res.h
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Sin.h"
#define MUSEOS 1
#define IDIOMAS 2
#define FAVORITOS 3
#define DESTACADOS 4
#define VISITADOS 5
#define OPCIONES 6

#define MAPA_MUSEO 0
#define CUADROS_DESTACADOS 1
#define MIS_FAVORITOS 2
#define INFO_MUSEO 3
#define MUSEOS_VISITADOS 4
#define MAPA_INFOART 5
#define BUZON_SUGERENCIAS 6
#define SOBRE_APP 7

#define CODIGO_CHECK 0
#define CODIGO 1
#define ESTADISTIC 2
#define UDP_BUZON 3
#define URL 4
#define PAYPAL 6
#define UDP_DESTACADOS 5
@interface Res : NSObject{
    
}

+ (NSString *)getDirWithString:(NSString*)string;
+(BOOL) existeFicheroRutaAbsoluta:(NSString*)file;
+(BOOL) existeFicheroRutaRelativa:(NSString*)ruta;
+(NSArray*) filesFromDir:(NSString*)dir;
+(void) removeFromDir:(NSString*)dir;
+(void) removeFile:(NSString*)file;
+(void) descomprimir:(NSString*)dir;

+(NSString *) loadTextString:(NSString *)string;
+(UIImage *) loadImageString:(NSString *)string;
+(NSString*) info;
+(void) obtenerListado;
+(BOOL) obtenerCosasComunes;
+(void)generateIDEN;
+(BOOL)connected;
@end
