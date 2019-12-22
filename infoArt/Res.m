//
//  Res.m
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "Res.h"
#import "Main.h"

@import CoreLocation;
@implementation Res

#pragma-mark File methods

+ (NSString *)getDirWithString:(NSString*)string {
    NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir  = [documentPaths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:string];
    
}

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

+(BOOL) existeFicheroRutaRelativa:(NSString*)ruta
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *file = [Res getDirWithString:ruta];
    NSLog(@"%@",file);
    if ([fileManager fileExistsAtPath:file])
    {
        NSLog(@"FOUND FILE");
        return YES;
    } else{
        NSLog(@"NOT FOUND FILE");
        return NO;
    }
}

+(BOOL) existeFicheroRutaAbsoluta:(NSString*)file
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSLog(@"%@",file);
    if ([fileManager fileExistsAtPath:file])
    {
        NSLog(@"FOUND FILE");
        return YES;
    } else{
        NSLog(@"NOT FOUND FILE");
        return NO;
    }
}

+(NSArray*) filesFromDir:(NSString*)dir
{
    dir=[Res getDirWithString:dir];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError * error;
    NSLog(@"%@",dir);
    NSArray * array=[fileManager contentsOfDirectoryAtPath:dir error:&error];
    for(NSObject * elem in array){
        NSLog(@"%@",elem);
    }
    return array;
}
+(void) removeFile:(NSString*)file
{
    NSLog(@"Deleting: %@",file);
    file=[Res getDirWithString:file];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError * error;
    BOOL exito=[fileManager removeItemAtPath:file error:&error];
    if (!exito|| error) NSLog(@"No se ha podido borrar: %@ por: %@",file,error);

}
+(void) removeFromDir:(NSString*)dir
{
    dir=[Res getDirWithString:dir];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError * error;
    NSArray * array=[fileManager contentsOfDirectoryAtPath:dir error:&error];
    for(NSObject * elem in array){
        NSLog(@"Deleting: %@",elem);
        BOOL exito=[fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",dir,elem] error:&error];
        if (!exito|| error) NSLog(@"No se ha podido borrar: %@ por: %@",elem,error);
    }
}

+(void) descomprimir:(NSString*)dir
{
    NSString *destination=[Res getDirWithString:dir];
    NSString *zipPath =[destination stringByAppendingString:@".zip"];
    if ([Res existeFicheroRutaAbsoluta:zipPath]){
        [Main unzipFileAtPath:zipPath toDestination:destination];
        [Res filesFromDir:dir];
        [Res removeFile:[dir stringByAppendingString:@".zip"]];
    }
    else NSLog(@"No existe el fichero %@, no se puede descomprimir",zipPath);
}

#pragma-mark IMAGE METHODS
+(UIImage *) loadImageString:(NSString *)string{
    NSString *imgPath = [Res getDirWithString:string];
    if ([Res existeFicheroRutaAbsoluta:imgPath]){
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imgPath]];
        return [[UIImage alloc] initWithData:imgData];
    }
    return nil;
}

#pragma-mark TEXT METHODS
+(NSString *) loadTextString:(NSString *)string{
    NSString *path = [Res getDirWithString:string];
    if ([Res existeFicheroRutaAbsoluta:path]){
        NSData *textData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
        return [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark ObtenerListado
+(BOOL) obtenerCosasComunes
{
    Sin * sin=[Sin sharedInstance];
    NSString * idiomas=[Res loadTextString:@"COMUN/IDIOMAS.txt"];
    idiomas=[idiomas stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    idiomas=[idiomas stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //Se guarda en arrayIdiomas los idiomas que hay disponibles
    sin.arrayIdiomas=[idiomas componentsSeparatedByString:@">"];
    NSInteger numIdiomas=sin.arrayIdiomas.count;
    NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
    int i=0;
    for(NSString* string in sin.arrayIdiomas){
        [dic setObject:[NSNumber numberWithInt:i] forKey:string];
        i++;
    }
    sin.dicIdiomas=dic;
    NSString* locale=[[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode] uppercaseString];
    NSLog(@"%@",locale);
    
    //Lectura del fichero MAP
    NSString * museos=[Res loadTextString:@"COMUN/MAP.txt"];
    museos=[museos stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    museos=[museos stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSArray * array=[museos componentsSeparatedByString:@">"];
    NSMutableDictionary* dic1=[[NSMutableDictionary alloc] init];
    NSMutableDictionary* dic2=[[NSMutableDictionary alloc] init];
    NSMutableDictionary* dic3=[[NSMutableDictionary alloc] init];
    for(NSString* string in array){
        NSArray * array2=[string componentsSeparatedByString:@","];
        NSString * nombre=array2[0];
        [dic1 setObject:[[CLLocation alloc] initWithLatitude:[array2[1] floatValue] longitude:[array2[2] floatValue]]  forKey:nombre];
        [dic2 setObject:[NSString stringWithFormat:@"%@,%@",array2[4],array2[5]] forKey:nombre];
        [dic3 setObject:array2[6] forKey:nombre];
    }
    sin.mapaMuseosLoc=dic1;
    sin.mapaMuseosBeacon=dic2;
    sin.mapaMuseosIdiomas=dic3;
    NSString * idiom=[sin.user objectForKey:@"IDIOMA"];
    if (idiom!=nil){
        sin.idioma=[idiom intValue];
        return false;
    }
    if ([locale isEqualToString:@"ES"]) sin.idioma=0;
    else if (([locale isEqualToString:@"EN"])&&(numIdiomas>1)) sin.idioma=1;
    else return true;
    [sin.user setObject:[NSString stringWithFormat:@"%d",sin.idioma] forKey:@"IDIOMA"];
    //true significa que hay que escoger idioma
    return false;
    
}
+(void) obtenerListado
{
    NSLog(@"obtener listado");
    Sin * sin=[Sin sharedInstance];
    sin.mapaNumeros=[[NSMutableArray alloc] init];
    sin.mapaNumerosInv=[[NSMutableArray alloc] init];
    for(int j=0;j<sin.arrayIdiomas.count;j++){
        [sin.mapaNumeros addObject:[[NSMutableDictionary alloc] init]];
        [sin.mapaNumerosInv addObject:[[NSMutableDictionary alloc] init]];
    }
    
    NSString * texto=[Res loadTextString:[NSString stringWithFormat:@"%@/PRI/LISTADO.txt",sin.museo]];
    texto=[texto stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    texto=[texto stringByReplacingOccurrencesOfString:@"\r" withString:@""];
   // NSLog(@"texto=%@",texto);
    NSArray * array=[texto componentsSeparatedByString:@">"];
    sin.mapaCuadros=[[NSMutableDictionary alloc] init];
    for(int i=0;i<array.count;i++){
        NSArray * array2=[array[i] componentsSeparatedByString:@"<"];
        NSArray * aux=[array2[1] componentsSeparatedByString:@","];
        [sin.mapaCuadros setValue:array2[2] forKey:[NSString stringWithFormat:@"%@,%@",aux[1],aux[2]]];
        NSString* num=array2[0];
        for(int j=0;j<array2.count-2;j++){
            NSString* nombre=array2[j+2];
            [sin.mapaNumeros[j] setObject:nombre forKey:num];
            [sin.mapaNumerosInv[j] setObject:num forKey:nombre];
        }
    }
}

+(NSString*) info
{
    UIDevice * dev=[UIDevice currentDevice];
    NSString *aux =[NSString stringWithFormat:@"%@-%@,%@,%@-%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"IDEN"], [dev model],[dev name],[dev systemVersion],[[NSLocale currentLocale] localeIdentifier]];
    return aux;
}
+(void)generateIDEN
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]] forKey:@"IDEN"];
}
@end
