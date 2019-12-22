//
//  MediaViewController.h
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Res.h"

@interface MediaViewController : UIViewController <AVAudioPlayerDelegate> {
    AVAudioPlayer *audioPlayer;
    NSTimer *playbackTimer;
    Sin * sin;
}
#pragma mark UI OBJECTS
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *fondo;


- (IBAction)stopAudio:(UIButton *)sender;
- (IBAction)sliderChanged:(UISlider *)sender;
- (IBAction)buttonLikePress:(UIButton *)sender;
- (IBAction)buttonPostEvent:(UIButton *)sender;
- (IBAction)buttonAntEvent:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonPost;
@property (weak, nonatomic) IBOutlet UIButton *buttonAnt;


@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeTotal;

@property (weak, nonatomic) IBOutlet UISlider *progressBar;

@property (nonatomic, retain) NSTimer  *playbackTimer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

#pragma mark - OTHER PROPERTIES
@property (nonatomic, retain) NSString* clave;

@end