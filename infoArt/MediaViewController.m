//  MediaViewController.m
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "MediaViewController.h"
#import "Res.h"
#import "ToastView.h"

@implementation MediaViewController{
    int duration_minutes;
    int duration_seconds;
    BOOL playing;
    int indice;
    bool multiple;
}

@synthesize labelTime,labelTimeTotal, playbackTimer, progressBar, audioPlayer,buttonPlay;
@synthesize image,labelTitle,textView,buttonLike;
@synthesize clave;
@synthesize buttonAnt,buttonPost;

- (void)viewDidLoad {
    [super viewDidLoad];
    indice=1;
    sin=[Sin sharedInstance];
    multiple=true;
    [self configurarAudio:[NSString stringWithFormat:@"%@/INFO%d/IDIOMA%d-%@",sin.museo,sin.idioma,sin.idioma,clave] index:indice];
    [self configurarTexto:[NSString stringWithFormat:@"%@/INFO%d/IDIOMA%d-%@",sin.museo,sin.idioma,sin.idioma,clave] index:indice];
    [self configurarImagen:[NSString stringWithFormat:@"%@/PRI/%@",sin.museo,clave] index:indice];
    if(multiple){
        buttonAnt.hidden=YES;
        buttonPost.hidden=NO;
    } else{
        buttonAnt.hidden=YES;
        buttonPost.hidden=YES;
    }
    if ([sin.stat.favoritos containsObject:[sin.mapaNumerosInv[0] valueForKey:clave]]) [self setHeart:true];
    [self.fondo setImage:[UIImage imageNamed:@"fondo.png"]];
}
-(void)viewDidUnload {
    audioPlayer = nil;
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"Stop");
    [playbackTimer invalidate];
    [audioPlayer stop];
    [buttonPlay setImage:[UIImage imageNamed:@"ic_play_circle_outline_2x.png"] forState:UIControlStateNormal];
    playing=false;
}
#pragma mark - Button methods
//BOTON DE ME GUSTA
-(void) setHeart:(BOOL)heart{
    NSString * imageName;
    if (heart) imageName=@"ic_favorite_3x.png";
    else imageName=@"ic_favorite_border_3x.png";
    
    buttonLike.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:2.5
                          delay:0.0
         usingSpringWithDamping:0.2
          initialSpringVelocity:6.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         buttonLike.transform = CGAffineTransformIdentity;
                         [buttonLike setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                         buttonLike.tintColor=[UIColor redColor];
                     }
                     completion:nil];
}
- (IBAction)buttonLikePress:(UIButton *)sender {
    NSString * key=[sin.mapaNumerosInv[0] objectForKey:clave];
    if (![sin.stat.favoritos containsObject:key]){
        [self setHeart:true];
        [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"me gusta", @"") withDuaration:2.0];
        [sin.stat add:true Lista:5 elem:key];
    } else{
        [self setHeart:false];
        [ToastView showToastInParentView:self.view withText:NSLocalizedString(@"no me gusta", @"") withDuaration:2.0];
        [sin.stat add:false Lista:5 elem:key];
    }
}
//avanzar imagen y volver en pantallas con mas de 1 imagen
- (IBAction)buttonPostEvent:(UIButton *)sender {
    indice++;
    buttonAnt.hidden=NO;
    if (![Res existeFicheroRutaRelativa:[NSString stringWithFormat:@"%@/PRI/%@-%d.jpg",sin.museo,clave,indice+1]])
        buttonPost.hidden=YES;
    [self configurarAudio:[NSString stringWithFormat:@"%@/INFO%d/IDIOMA%d-%@",sin.museo,sin.idioma,sin.idioma,clave] index:indice];
    [self configurarTexto:[NSString stringWithFormat:@"%@/INFO%d/IDIOMA%d-%@",sin.museo,sin.idioma,sin.idioma,clave] index:indice];
    [self configurarImagen:[NSString stringWithFormat:@"%@/PRI/%@",sin.museo,clave] index:indice];
}

- (IBAction)buttonAntEvent:(UIButton *)sender {
    indice--;
    buttonPost.hidden=NO;
    if (indice==1) buttonAnt.hidden=YES;
    [self configurarAudio:[NSString stringWithFormat:@"%@/INFO%d/IDIOMA%d-%@",sin.museo,sin.idioma,sin.idioma,clave] index:indice];
    [self configurarTexto:[NSString stringWithFormat:@"%@/INFO%d/IDIOMA%d-%@",sin.museo,sin.idioma,sin.idioma,clave] index:indice];
    [self configurarImagen:[NSString stringWithFormat:@"%@/PRI/%@",sin.museo,clave] index:indice];
    
}

#pragma mark - Text methods

-(void) configurarTexto:(NSString*)path index:(int)index
{
    path=[NSString stringWithFormat:@"%@-%d.txt",path,index];
    if ((index==1)&&(![Res existeFicheroRutaRelativa:path])){
        path = [[path substringToIndex:path.length-6] stringByAppendingString:@".txt"];
    }
    
    NSString * texto=[Res loadTextString:path];
    if (texto!=nil){
        texto=[texto stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        texto=[texto stringByReplacingOccurrencesOfString:@"<" withString:@"\n"];
        NSArray * array=[texto componentsSeparatedByString:@">"];
        NSMutableAttributedString * at;
        NSString * text0=array[0];
        NSString * text1=[array[1] substringFromIndex:1];
        NSString * text2=array[2];
        if ((![text1 isEqualToString:@""])&&(![text1 isEqualToString:@" "])){
            at=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@, %@",text0,text1]];
            [at addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13] range:NSMakeRange(text0.length+2,text1.length)];
        }else
            at=[[NSMutableAttributedString alloc] initWithString:text0];
        [at addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14] range:NSMakeRange(0,text0.length)];
        labelTitle.numberOfLines=0;
        [labelTitle setLineBreakMode:NSLineBreakByWordWrapping];
        labelTitle.attributedText=at;
        at=[[NSMutableAttributedString alloc] initWithString:text2];
        [at addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:13] range:NSMakeRange(0,text2.length)];
        textView.attributedText=at;
    }
}

#pragma mark - Imagen methods
-(void) configurarImagen:(NSString*)path index:(int)index
{
    path=[NSString stringWithFormat:@"%@-%d.jpg",path,index];
    if ((index==1)&&(![Res existeFicheroRutaRelativa:path])){
        path = [[path substringToIndex:path.length-6] stringByAppendingString:@".jpg"];
        multiple=false;
    }
    UIImage* foto=[Res loadImageString:path];
    if (foto!=nil){
        //PONE LA FOTO POR DEFECTO Y LA RECORTA EN FORMA DE CIRCULO
        CGFloat w1=foto.size.width;
        CGFloat h1=foto.size.height;
        CGFloat x2=20;
        CGFloat y2=64;
        NSLog(@"y2=%f",y2);
        CGFloat w2=self.view.frame.size.width-40;
        CGFloat h2=140;
        CGFloat r1=w1/h1;
        CGFloat r2=w2/h2;
        CGRect rect;
        if(r2>r1){
            CGFloat w3=h2*r1;
            rect=CGRectMake(((w2-w3)/2)+x2, y2,w3,h2);
        }else{
            rect=CGRectMake(x2,y2,w2, (h2/r1)*r2);
        }
        UIView * superview=[image superview];
        [image removeFromSuperview];
        UIImageView *image2=[[UIImageView alloc] initWithFrame:rect];
        image2.contentMode=UIViewContentModeScaleAspectFit;
        NSLog(@"%f %f %f %f",image.frame.origin.x,image.frame.origin.y,image.frame.size.width,image.frame.size.height);
        image2.layer.cornerRadius =  image2.frame.size.width / 10;
        image2.clipsToBounds = YES;
        image2.layer.borderWidth = 1.0f;
        image2.layer.borderColor = [UIColor blackColor].CGColor;
        image2.image =foto;
        [superview addSubview:image2];
        image=image2;
    }
}


#pragma-mark AUDIO METHODS
-(void) configurarAudio:(NSString *)string index:(int)index
{
    playing=false;
    NSString *timeInfo =@"00:00";
    labelTime.text = timeInfo;
    NSString *path = [Res getDirWithString:string];
    
    path=[NSString stringWithFormat:@"%@-%d.mp3",path,index];
    if ((index==1)&&(![Res existeFicheroRutaAbsoluta:path])){
        path = [[path substringToIndex:path.length-6] stringByAppendingString:@".mp3"];
    }
    if ([Res existeFicheroRutaAbsoluta:path]){
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:url
                       error:&error];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        if (error)
        {
            NSLog(@"Error in audioPlayer: %@",
                  [error localizedDescription]);
        } else {
            audioPlayer.delegate = self;
            [audioPlayer prepareToPlay];
        }
        
        playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                       selector:@selector(updateSlider) userInfo:nil repeats:YES];
        
        progressBar.maximumValue = audioPlayer.duration;
        duration_minutes = floor(audioPlayer.duration/60);
        duration_seconds =audioPlayer.duration - (duration_minutes * 60);
        int aux2=duration_minutes%10;
        int aux1=duration_minutes/10;
        int aux4=duration_seconds%10;
        int aux3=duration_seconds/10;
        NSString *timeInfo = [[NSString alloc]
                              initWithFormat:@"%d%d:%d%d",
                              aux1,aux2,aux3,aux4];
        labelTimeTotal.text = timeInfo;
        
        // Set the valueChanged target
        [progressBar addTarget:self action:@selector(sliderChanged:) forControlEvents:
         UIControlEventValueChanged];
        [self stopAudio:nil];
    }
    
}

-(void)updateTime
{
    int minutes = floor(audioPlayer.currentTime/60);
    int seconds = audioPlayer.currentTime - (minutes * 60);
    int aux2=minutes%10;
    int aux1=minutes/10;
    int aux4=seconds%10;
    int aux3=seconds/10;
    NSString *timeInfo = [[NSString alloc]
                          initWithFormat:@"%d%d:%d%d",
                          aux1,aux2,aux3,aux4];
    labelTime.text = timeInfo;
}

- (void)updateSlider {
    progressBar.value = audioPlayer.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    // Fast skip the music when user scroll the UISlider
    [audioPlayer stop];
    [audioPlayer setCurrentTime:progressBar.value];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    playing=true;
    [buttonPlay setImage:[UIImage imageNamed:@"ic_pause_circle_outline_2x.png"] forState:UIControlStateNormal];
}


-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [buttonPlay setImage:[UIImage imageNamed:@"ic_play_circle_outline_2x.png"] forState:UIControlStateNormal];
    NSLog(@"Stop porque ha terminado");
    [playbackTimer invalidate];
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player error:(NSError *)error
{
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}

- (IBAction)stopAudio:(UIButton *)sender {
    if (playing){
        NSLog(@"Stop");
        [playbackTimer invalidate];
        [audioPlayer stop];
        [buttonPlay setImage:[UIImage imageNamed:@"ic_play_circle_outline_2x.png"] forState:UIControlStateNormal];
    } else{
        NSLog(@"Play");
        playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(updateTime)
                                                       userInfo:nil
                                                        repeats:YES];
        [audioPlayer play];
        [buttonPlay setImage:[UIImage imageNamed:@"ic_pause_circle_outline_2x.png"] forState:UIControlStateNormal];
    }
    playing=!playing;
}

@end