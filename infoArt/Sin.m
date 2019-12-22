//
//  Sin.m
//  infoArt
//
//  Created by mac mini on 7/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "Sin.h"

static Sin *sharedInstance = nil;

@implementation Sin
@synthesize user;
+ (Sin *) sharedInstance
{
    if(!sharedInstance){
        sharedInstance = [[self alloc] init];
        [sharedInstance initial];
    }
    return sharedInstance;
}
-(void) initial
{
    user=[NSUserDefaults standardUserDefaults];
}
@end
