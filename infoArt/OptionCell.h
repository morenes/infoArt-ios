//
//  OptionCell.h
//  infoArt
//
//  Created by mac mini on 18/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionCell : UITableViewCell
- (void)configWithOption:(UIImage*)image title:(NSString*)title;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelValoracion;
@property (weak, nonatomic) IBOutlet UIButton *buttonGo;
@end
