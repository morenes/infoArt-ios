//
//  ToastView.h
//  WhatsDog
//
//  Created by Puesto Tres on 30/10/14.
//  Copyright (c) 2014 Zapp-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) UILabel *textLabel;

+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration;

@end
