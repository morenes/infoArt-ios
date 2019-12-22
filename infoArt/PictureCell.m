//
//  PictureCell.m
//  infoArt
//
//  Created by mac mini on 13/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell

@synthesize labelName;
@synthesize labelValoracion;
@synthesize imagePerfil;
#pragma mark - View lifecycle

- (void)awakeFromNib
{

    labelValoracion.textColor =[UIColor blackColor];
    labelValoracion.font = [UIFont systemFontOfSize:11];
}


- (void)configWithPicture:(UIImage*)image title:(NSString*)title val:(NSString*)val{
    labelName.text=title;
    labelValoracion.text=val;
    
    
    //PONE LA FOTO POR DEFECTO Y LA RECORTA EN FORMA DE CIRCULO
    CGFloat w1=image.size.width;
    CGFloat h1=image.size.height;
    CGFloat w2=imagePerfil.frame.size.width;
    CGFloat h2=imagePerfil.frame.size.height;
    CGFloat r1=w1/h1;
    CGFloat r2=w2/h2;
//    NSLog(@"r1=%f",r1);
//    NSLog(@"r2=%f",r2);
    CGRect rect;
    //NSLog(@"%f %f %f %f",imagePerfil.frame.origin.x,imagePerfil.frame.origin.y,imagePerfil.frame.size.width,imagePerfil.frame.size.height);
    if(r2>r1){
        CGFloat w3=imagePerfil.frame.size.height*r1;
        rect=CGRectMake(((imagePerfil.frame.size.width-w3)/2)+imagePerfil.frame.origin.x, imagePerfil.frame.origin.y,w3, imagePerfil.frame.size.height);
    }else{
        CGFloat h3= (imagePerfil.frame.size.height*r2)/r1;
        rect=CGRectMake(imagePerfil.frame.origin.x, imagePerfil.frame.origin.y,imagePerfil.frame.size.width,h3);
    }
    
    
    imagePerfil.frame=rect;
    //NSLog(@"%f %f %f %f",imagePerfil.frame.origin.x,imagePerfil.frame.origin.y,imagePerfil.frame.size.width,imagePerfil.frame.size.height);
    imagePerfil.image =image;
    imagePerfil.layer.cornerRadius =  imagePerfil.frame.size.width / 5;
    imagePerfil.clipsToBounds = YES;
    imagePerfil.layer.borderWidth = 1.0f;
    imagePerfil.layer.borderColor = [UIColor blackColor].CGColor;
}


@end