//
//  OptionCell.m
//  infoArt
//
//  Created by mac mini on 18/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "OptionCell.h"

@implementation OptionCell

@synthesize labelName;
@synthesize labelValoracion;
#pragma mark - View lifecycle

- (void)awakeFromNib
{
    
    labelValoracion.textColor =[UIColor blackColor];
    labelValoracion.font = [UIFont systemFontOfSize:11];
}


- (void)configWithOption:(UIImage*)image title:(NSString*)title{
    labelName.text=title;
    labelValoracion.text=@"";
}


@end