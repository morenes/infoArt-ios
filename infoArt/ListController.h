//
//  ListController.h
//  infoArt
//
//  Created by mac mini on 17/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionCell.h"
#import "Res.h"
#import "MediaViewController.h"
#import "MusMapViewController.h"
#import "TextViewController.h"
#import "MapController.h"


@interface ListController : UIViewController

@property (strong,nonatomic) NSArray * opciones;
@property (nonatomic) int tipo;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAll;
@end
