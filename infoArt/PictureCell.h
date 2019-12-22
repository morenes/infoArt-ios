//
//  PictureCell.h
//  infoArt
//
//  Created by mac mini on 13/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCell : UITableViewCell
- (void)configWithPicture:(UIImage*)image title:(NSString*)title val:(NSString*)val;
@property (strong, nonatomic) IBOutlet UIImageView *imagePerfil;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelValoracion;
@property (weak, nonatomic) IBOutlet UIButton *buttonGo;
@end
