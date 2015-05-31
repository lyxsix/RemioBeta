//
//  ViewController.m
//  RemioBeta
//
//  Created by Felix on 15/5/23.
//  Copyright (c) 2015年 wewing. All rights reserved.
//

#import "ViewController.h"
#import "JZDragView.h"
#import "AudioEngine.h"

#import "MusicSetting.h"

static NSString *const kBTSPulseAnimation = @"BTSPulseAnimation";

@interface ViewController ()<JZDragViewDelegate,AudioEngineDelegate,AVAudioPlayerDelegate>
{
    BOOL _isConnect;
    NSString* _msg;
    
    UIView *_pulseView;
    CALayer *_audioLayer;
    CALayer *_aLayer1;
    CALayer *_aLayer2;
    CALayer *_aLayer3;
    CALayer *_aLayer4;
    CALayer *_aLayer5;
    CALayer *_aLayer6;
    CALayer *_aLayer7;
    CALayer *_aLayer8;
    CGFloat _animationDuration;
    BOOL _autoreverses;
    
    NSInteger _playID;
    NSString* kMusicFile;
    NSString* kMusicSinger;
    NSString* kMusicTitle;
    NSString* kMusicImage;
    
    float playLVol;
    float playRVol;
}
@property (nonatomic, weak)JZDragView *dragLView;
@property (nonatomic, weak)JZDragView *dragRView;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
@property (weak ,nonatomic) NSTimer *timer;//进度更新定时器
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initBle];
    [self initDragView];
    [self initMyAudio];
    
    [self initPulseView];
    
    //View Hidden
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = YES;
    _bottomTabView.hidden = YES;
    
    _isPlayMixing = NO;
    
    playLVol = 0.5;
    playRVol = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initBle
{
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.aryDevices = [[NSMutableArray alloc] init];
    _isConnect = NO;
    [self searchDevices];
    
}

- (void)initDragView
{
    JZDragView *dragLView = [JZDragView dragViewWithFrame:self.leftAlbum.bounds andImages:@[@"pL1.png",@"pL2.png",@"pL3.png",@"pL4.png"]];
    JZDragView *dragRView = [JZDragView dragViewWithFrame:self.rightAlbum.bounds andImages:@[@"pR1.png",@"pR2.png",@"pR3.png",@"pR4.png"]];
    dragLView.delegate = self;
    dragRView.delegate = self;
    dragLView.backgroundColor = [UIColor lightGrayColor];
    dragRView.backgroundColor = [UIColor lightGrayColor];
    [self.leftAlbum addSubview:dragLView];
    [self.rightAlbum addSubview:dragRView];
    self.dragLView = dragLView;
    self.dragRView = dragRView;
    NSLog(@"dragLView currentIndex:%ld",(long)dragLView.currentIndex);
    NSLog(@"dragRView currentIndex:%ld",(long)dragRView.currentIndex);

}

- (void)initMyAudio
{
    engine = [[AudioEngine alloc] init];
    engine.delegate = self;
}

- (void)initPulseView
{
    //CreatePulse
    _pulseView = [[UIView alloc] init];
    _pulseView.alpha = 0.5;
    [self.page9View addSubview:_pulseView];
    [self createPulse];
}

- (IBAction)connectAction:(id)sender {
    [self connectBle];
    _connectState.titleLabel.text = @"Connecting ...";
}





- (IBAction)play1MusicAction:(id)sender {
}

- (IBAction)play2MusicAction:(id)sender {
}

- (IBAction)play3MusicAction:(id)sender {
}

- (IBAction)play4MusicAction:(id)sender {
}

- (IBAction)toPage4Action:(id)sender {
    //View Hidden
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = NO;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = YES;
    _bottomTabView.hidden = YES;
}
- (IBAction)return2Page3Action:(id)sender {
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = NO;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = YES;
    _bottomTabView.hidden = NO;
}
- (IBAction)toHomeAction:(id)sender {
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = NO;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = YES;
    _bottomTabView.hidden = NO;
    
}
- (IBAction)toRemioMixAction:(id)sender {
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = NO;
    _page10View.hidden = YES;
    _topTabView.hidden = YES;
    _bottomTabView.hidden = NO;
    if (!_isPlayMixing) {
        _isPlayMixing = YES;
        _leftTitle.text = @"Ping Pong";
        _leftArtistName.text = @"Armin van Buuren";
        _rightTitle.text = @"Wake Me Up";
        _rightArtistName.text = @"Avicii";
        [engine toggleL1];
        [engine toggleR1];
    }
    
    
}
- (IBAction)toMusicAction:(id)sender {
    _songBtn.titleLabel.textColor = [UIColor blueColor];
    _artistBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _albumBtn.titleLabel.textColor = [UIColor lightGrayColor];
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = NO;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = NO;
    _bottomTabView.hidden = NO;
}
- (IBAction)shareAction:(id)sender {
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
//    _page5View.hidden = YES;
//    _page6View.hidden = YES;
    _page7View.hidden = NO;
//    _page8View.hidden = NO;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = YES;
    _bottomTabView.hidden = NO;
}

- (IBAction)exitPage7:(id)sender {
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    //    _page5View.hidden = YES;
    //    _page6View.hidden = YES;
    _page7View.hidden = YES;
    //    _page8View.hidden = NO;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = NO;
    _bottomTabView.hidden = NO;
}

- (IBAction)toSongAction:(id)sender {
    _songBtn.titleLabel.textColor = [UIColor blueColor];
    _artistBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _albumBtn.titleLabel.textColor = [UIColor lightGrayColor];
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = NO;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = NO;
    _bottomTabView.hidden = NO;

}

- (IBAction)artistAction:(id)sender {
    _songBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _artistBtn.titleLabel.textColor = [UIColor blueColor];
    _albumBtn.titleLabel.textColor = [UIColor lightGrayColor];
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = NO;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = NO;
    _bottomTabView.hidden = NO;

}
- (IBAction)albumAction:(id)sender {
    _songBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _artistBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _albumBtn.titleLabel.textColor = [UIColor blueColor];
    //View Hidden status
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    _page5View.hidden = NO;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = YES;
    _page10View.hidden = YES;
    _topTabView.hidden = NO;
    _bottomTabView.hidden = NO;
}
- (IBAction)playAllAction:(id)sender {
    _page2View.hidden = YES;
    _page3View.hidden = YES;
    _page4View.hidden = YES;
    _page5View.hidden = YES;
    _page6View.hidden = YES;
    _page7View.hidden = YES;
    _page8View.hidden = YES;
    _page9View.hidden = YES;
    _page10View.hidden = NO;
    _topTabView.hidden = YES;
    _bottomTabView.hidden = NO;
    
    _playID = 1;
    [self updatePlayMusic];
    _playAmusicBtn.tag = 1;
}
- (IBAction)restMixAction:(id)sender {
    // rewind stops playback and recording
    [engine.L1PlayerNode stop];
    [engine.L2PlayerNode stop];
    [engine.L3PlayerNode stop];
    [engine.L4PlayerNode stop];
    [engine.R1PlayerNode stop];
    [engine.R2PlayerNode stop];
    [engine.R3PlayerNode stop];
    [engine.R4PlayerNode stop];
    _recording = NO;
    _playing = NO;
    [engine stopPlayingRecordedFile];
    [engine stopRecordingMixerOutput];
    
}

- (IBAction)recordMixAction:(id)sender {
    // recording stops playback and recording if we are already recording
    _playing = NO;
    _recording = !_recording;
    _canPlayback = YES;
    
    [engine stopPlayingRecordedFile];
    if (_recording){
        _recordMixBtn.alpha = 0.5;
        [engine startRecordingMixerOutput];
    }else {
        _recordMixBtn.alpha = 1.0;
        [engine stopRecordingMixerOutput];
    }
}

- (IBAction)playRecordAction:(id)sender {
    // playing/pausing stops recording toggles playback state
    _recording = NO;
    _playing = !_playing;
    
    [engine stopRecordingMixerOutput];
    if (_playing) {
        _playRecordBtn.alpha = 0.5;
        [engine playRecordedFile];
    }else {
        _playRecordBtn.alpha = 1.0;
        [engine pausePlayingRecordedFile];
    }

}


#pragma mark - Pulse Animation

- (void)beginAnimatingLayer:(CALayer *)activeLayer
{
    // Here we are creating an explicit animation for the layer's "transform" property.
    // - The duration (in seconds) is controlled by the user.
    // - The repeat count is hard coded to go "forever".
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [pulseAnimation setDuration:_animationDuration];
    //    [pulseAnimation setRepeatCount:MAXFLOAT];
    
    // The built-in ease in/ ease out timing function is used to make the animation look smooth as the layer
    // animates between the two scaling transformations.
    [pulseAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // Scale the layer to half the size
    CATransform3D transform = CATransform3DMakeScale(1.0, 20.0, 1.0);
    
    // Tell CA to interpolate to this transformation matrix
    [pulseAnimation setToValue:[NSValue valueWithCATransform3D:transform]];
    
    // Tells CA to reverse the animation (e.g. animate back to the layer's transform)
    [pulseAnimation setAutoreverses:_autoreverses];
    
    // Finally... add the explicit animation to the layer... the animation automatically starts.
    [activeLayer addAnimation:pulseAnimation forKey:kBTSPulseAnimation];
}

- (void)endAnimatingLayer:(CALayer *)activeLayer
{
    [activeLayer removeAnimationForKey:kBTSPulseAnimation];
}

- (void)createPulse{
    // Create a new layer and add it to the view's layer
    _audioLayer = [CALayer layer];
    [_audioLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [_audioLayer setBounds:CGRectMake(0.0, 0.0, 500.0, 10.0)];
    _audioLayer.anchorPoint = CGPointMake(0, 0);
    UIView *view = [self view];
    CGRect frame = [view bounds];
    
    CGFloat x = 30.8;//frame.size.width/10;
    CGFloat y = 256.0;
    //    NSLog(@"frame %f",x);
    
    CGFloat layerWidth = 22.5;//frame.size.width/15;
    CGFloat layerHeight = frame.size.height/100;
    CGFloat addWidth = 26.9;//frame.size.width/12;
    NSLog(@"layerWidth:%f,layerHeight:%f addWidth:%f",layerWidth,layerHeight,addWidth);
    
    [_audioLayer setPosition:CGPointMake(x, y)];
    
    _aLayer1 = [CALayer layer];
    [_aLayer1 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer1 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer1 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer1 setPosition:CGPointMake(_audioLayer.position.x,_audioLayer.position.y)];
    _aLayer1.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer1];
    
    _aLayer2 = [CALayer layer];
    [_aLayer2 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer2 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer2 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer2 setPosition:CGPointMake(_audioLayer.position.x+addWidth,_audioLayer.position.y)];
    _aLayer2.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer2];
    
    _aLayer3 = [CALayer layer];
    [_aLayer3 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer3 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer3 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer3 setPosition:CGPointMake(_audioLayer.position.x+2*addWidth,_audioLayer.position.y)];
    _aLayer3.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer3];
    
    _aLayer4 = [CALayer layer];
    [_aLayer4 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer4 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer4 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer4 setPosition:CGPointMake(_audioLayer.position.x+3*addWidth,_audioLayer.position.y)];
    _aLayer4.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer4];
    
    _aLayer5 = [CALayer layer];
    [_aLayer5 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer5 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer5 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer5 setPosition:CGPointMake(_audioLayer.position.x+4*addWidth,_audioLayer.position.y)];
    _aLayer5.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer5];
    
    _aLayer6 = [CALayer layer];
    [_aLayer6 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer6 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer6 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer6 setPosition:CGPointMake(_audioLayer.position.x+5*addWidth,_audioLayer.position.y)];
    _aLayer6.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer6];
    
    _aLayer7 = [CALayer layer];
    [_aLayer7 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer7 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer7 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer7 setPosition:CGPointMake(_audioLayer.position.x+6*addWidth,_audioLayer.position.y)];
    _aLayer7.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer7];
    
    _aLayer8 = [CALayer layer];
    [_aLayer8 setContentsScale:[[UIScreen mainScreen] scale]];
    [_aLayer8 setBackgroundColor:[UIColor whiteColor].CGColor];
    [_aLayer8 setBounds:CGRectMake(0.0, 0.0, layerWidth, layerHeight)];
    [_aLayer8 setPosition:CGPointMake(_audioLayer.position.x+7*addWidth,_audioLayer.position.y)];
    _aLayer8.anchorPoint = CGPointMake(0.5, 1);
    [_audioLayer addSublayer:_aLayer8];
    
    //    [view addSubview:_pulseView]
    [[_pulseView layer] addSublayer:_audioLayer];
    
    
    _autoreverses = YES;
    _animationDuration = 0.1;
}

#pragma mark- dragViewDelegate
- (void)dragViewDidEndScrollingAnimation:(JZDragView *)dragView {
    NSLog(@"%s",__func__);
    if (dragView == _dragLView) {
        NSLog(@"dragLView currentIndex:%ld",(long)_dragLView.currentIndex);
        if (_dragLView.currentIndex == 0) {
            _leftTitle.text = @"Ping Pong";
            _leftArtistName.text = @"Armin van Buuren";
            engine.L1PlayerVolume = playLVol;
            [engine toggleL1];
            [engine.L2PlayerNode stop];
            [engine.L3PlayerNode stop];
            [engine.L4PlayerNode stop];
        }else if (_dragLView.currentIndex == 1){
            _leftTitle.text = @"Crossfade";
            _leftArtistName.text = @"Gus Gus";
            engine.L2PlayerVolume = playLVol;
            [engine.L1PlayerNode stop];
            [engine toggleL2];
            [engine.L3PlayerNode stop];
            [engine.L4PlayerNode stop];
        }else if (_dragLView.currentIndex == 2){
            _leftTitle.text = @"Blame";
            _leftArtistName.text = @"Calvin Harris,John Newman";
            engine.L3PlayerVolume = playLVol;
            [engine.L1PlayerNode stop];
            [engine.L2PlayerNode stop];
            [engine toggleL3];
            [engine.L4PlayerNode stop];
        }else if (_dragLView.currentIndex == 3){
            _leftTitle.text = @"Da Funk";
            _leftArtistName.text = @"Daft Punk";
            engine.L4PlayerVolume = playLVol;
            [engine.L1PlayerNode stop];
            [engine.L2PlayerNode stop];
            [engine.L3PlayerNode stop];
            [engine toggleL4];
        }
    }else if(dragView == _dragRView){
        NSLog(@"dragRView currentIndex:%ld",(long)_dragRView.currentIndex);
        if (_dragRView.currentIndex == 0) {
            _rightTitle.text = @"Wake Me Up";
            _rightArtistName.text = @"Avicii";
            engine.R1PlayerVolume = playRVol;
            [engine toggleR1];
            [engine.R2PlayerNode stop];
            [engine.R3PlayerNode stop];
            [engine.R4PlayerNode stop];
        }else if (_dragRView.currentIndex == 1){
            _rightTitle.text = @"Black Night";
            _rightArtistName.text = @"Ferry Corsten";
            engine.R2PlayerVolume = playRVol;
            [engine.R1PlayerNode stop];
            [engine toggleR2];
            [engine.R3PlayerNode stop];
            [engine.R4PlayerNode stop];
        }else if (_dragRView.currentIndex == 2){
            _rightTitle.text = @"Too Turnt Up";
            _rightArtistName.text = @"Flosstradamus";
            engine.R3PlayerVolume = playRVol;
            [engine.R1PlayerNode stop];
            [engine.R2PlayerNode stop];
            [engine toggleR3];
            [engine.R4PlayerNode stop];
        }else if (_dragRView.currentIndex == 3){
            _rightTitle.text = @"Into the Lair";
            _rightArtistName.text = @"Zedd";
            engine.R4PlayerVolume = playRVol;
            [engine.R1PlayerNode stop];
            [engine.R2PlayerNode stop];
            [engine.R3PlayerNode stop];
            [engine toggleR4];
        }
    }
    
    if ([_msg rangeOfString:@"z+1"].location !=NSNotFound) {
        if (playLVol+0.01>1.0) {
            playLVol = 1.0;
            playRVol = 0;
        }else{
            playLVol += 0.01;
            playRVol -= 0.01;
        }
    }else if ([_msg rangeOfString:@"z-1"].location !=NSNotFound){
        if (playLVol-0.01<0) {
            playLVol = 0;
            playRVol = 1.0;
        }else{
            playLVol -= 0.01;
            playRVol += 0.01;
        }
    }else if([_msg rangeOfString:@"z+2"].location !=NSNotFound) {
        if (playLVol+0.02>1.0) {
            playLVol = 1.0;
            playRVol = 0;
        }else{
            playLVol += 0.02;
            playRVol -= 0.02;
        }
    }else if ([_msg rangeOfString:@"z-2"].location !=NSNotFound){
        if (playLVol-0.02<0) {
            playLVol = 0;
            playRVol = 1.0;
        }else{
            playLVol -= 0.02;
            playRVol += 0.02;
        }
    }else if([_msg rangeOfString:@"z+3"].location !=NSNotFound) {
        if (playLVol+0.03>1.0) {
            playLVol = 1.0;
            playRVol = 0;
        }else{
            playLVol += 0.03;
            playRVol -= 0.03;
        }
    }else if ([_msg rangeOfString:@"z-3"].location !=NSNotFound){
        if (playLVol-0.03<0) {
            playLVol = 0;
            playRVol = 1.0;
        }else{
            playLVol -= 0.03;
            playRVol += 0.03;
        }
    }else if([_msg rangeOfString:@"z+4"].location !=NSNotFound) {
        if (playLVol+0.04>1.0) {
            playLVol = 1.0;
            playRVol = 0;
        }else{
            playLVol += 0.04;
            playRVol -= 0.04;
        }
    }else if ([_msg rangeOfString:@"z-4"].location !=NSNotFound){
        if (playLVol-0.04<0) {
            playLVol = 0;
            playRVol = 1.0;
        }else{
            playLVol -= 0.04;
            playRVol += 0.04;
        }
    }else if([_msg rangeOfString:@"z+5"].location !=NSNotFound) {
        if (playLVol+0.05>1.0) {
            playLVol = 1.0;
            playRVol = 0;
        }else{
            playLVol += 0.05;
            playRVol -= 0.05;
        }
    }else if ([_msg rangeOfString:@"z-5"].location !=NSNotFound){
        if (playLVol-0.05<0) {
            playLVol = 0;
            playRVol = 1.0;
        }else{
            playLVol -= 0.05;
            playRVol += 0.05;
        }
    }else if([_msg rangeOfString:@"z+"].location !=NSNotFound) {
        if (playLVol+0.1>1.0) {
            playLVol = 1.0;
            playRVol = 0;
        }else{
            playLVol += 0.1;
            playRVol -= 0.1;
        }
    }else if ([_msg rangeOfString:@"z-"].location !=NSNotFound){
        if (playLVol-0.1<0) {
            playLVol = 0;
            playRVol = 1.0;
        }else{
            playLVol -= 0.1;
            playRVol += 0.1;
        }
    }
    
}
- (void)dragViewDidEndDragging:(JZDragView *)dragView withVelocity:(CGPoint)velocity targetContentOffset:(CGFloat)targetContentOffset {
    NSLog(@"%s",__func__);
}
- (void)dragViewDidBeginDragging:(JZDragView *)dragView {
    NSLog(@"%s",__func__);
}
- (void)dragViewDidDragging:(JZDragView *)dragView {
    NSLog(@"%s",__func__);
}

#pragma mark- DFBlunoDelegate

- (void)connectBle{
    NSInteger nCount = [self.aryDevices count];
    for (int i = 0; i < nCount; i++) {
        DFBlunoDevice* device   = [self.aryDevices objectAtIndex:i];
        NSLog(@"NO: %li Device Name is %@",(long)nCount,device.name);
        if ([device.name  isEqual: @"BlunoV2.0"]) {
            NSLog(@"Find device in aryDevices");
            if (self.blunoDev == nil)
            {
                self.blunoDev = device;
                [self.blunoManager connectToDevice:self.blunoDev];
            }
            else if ([device isEqual:self.blunoDev])
            {
                if (!self.blunoDev.bReadyToWrite)
                {
                    [self.blunoManager connectToDevice:self.blunoDev];
                }
            }
            else
            {
                if (self.blunoDev.bReadyToWrite)
                {
                    [self.blunoManager disconnectToDevice:self.blunoDev];
                    self.blunoDev = nil;
                }
                
                [self.blunoManager connectToDevice:device];
            }
            //View Hidden
            _page2View.hidden = YES;
            _page3View.hidden = NO;
            _page4View.hidden = YES;
            _page5View.hidden = YES;
            _page6View.hidden = YES;
            _page7View.hidden = YES;
            _page8View.hidden = YES;
            _page9View.hidden = YES;
            _page10View.hidden = YES;
            _topTabView.hidden = YES;
            _bottomTabView.hidden = NO;
        }
    }
}

- (void)searchDevices{
    [self.aryDevices removeAllObjects];
    [self.blunoManager scan];
}

-(void)bleDidUpdateState:(BOOL)bleSupported
{
    if(bleSupported)
    {
        [self.blunoManager scan];
    }
}

-(void)didDiscoverDevice:(DFBlunoDevice*)dev
{
    BOOL bRepeat = NO;
    for (DFBlunoDevice* bleDevice in self.aryDevices)
    {
        if ([bleDevice isEqual:dev])
        {
            bRepeat = YES;
            break;
        }
    }
    if (!bRepeat)
    {
        [self.aryDevices addObject:dev];
    }
    //    [self.tbDevices reloadData];
}

-(void)readyToCommunicate:(DFBlunoDevice*)dev
{
    self.blunoDev = dev;
    _isConnect = YES;
    NSLog(@"Ble Connected");
}

-(void)didDisconnectDevice:(DFBlunoDevice*)dev
{
    _isConnect = NO;
}

-(void)didWriteData:(DFBlunoDevice*)dev
{
    
}

-(void)didReceiveData:(NSData*)data Device:(DFBlunoDevice*)dev
{
    _msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",_msg);
    //todo
    //    BOOL isa0 = ([_msg rangeOfString:@"a0"].location !=NSNotFound);
    //    if (isa0) {
    //        if (_audioPlayer) {
    //            if ((_audioPlayer.volume -0.1)>0) {
    //                _audioPlayer.volume -= 0.1;
    //            }else{
    //                _audioPlayer.volume = 0;
    //            }
    //            NSLog(@"_audioPlayer.volume %f",_audioPlayer.volume);
    //        }
    //    }
    
    //    NSRange rangeAg;
    //    rangeAg=[_msg rangeOfString:@"ag"];
    //    if (_msg.length>(rangeAg.location+4)) {
    //        NSString *strAg = [_msg substringWithRange:NSMakeRange(rangeAg.location+2,3)];
    //        float floatAg = [strAg floatValue];
    //        if (floatAg<360.0) {
    //            NSLog(@"floatA is %f",floatAg);
    //            _rotaryKnob.value = floatAg;
    //            [engine rotaryMM:floatAg];
    //        }
    //    }
    BOOL isa0 = ([_msg rangeOfString:@"a0"].location !=NSNotFound);
    if (isa0) {
        [self endAnimatingLayer:_aLayer1];
        [self beginAnimatingLayer:_aLayer1];
        [engine hita0];
    }
    BOOL isa1 = ([_msg rangeOfString:@"a1"].location !=NSNotFound);
    if (isa1) {
        [self endAnimatingLayer:_aLayer2];
        [self beginAnimatingLayer:_aLayer2];
        [engine hita1];
    }
    BOOL isa2 = ([_msg rangeOfString:@"a2"].location !=NSNotFound);
    if (isa2) {
        [self endAnimatingLayer:_aLayer3];
        [self beginAnimatingLayer:_aLayer3];
        [engine hita2];
    }
    BOOL isa3 = ([_msg rangeOfString:@"a3"].location !=NSNotFound);
    if (isa3) {
        [self endAnimatingLayer:_aLayer4];
        [self beginAnimatingLayer:_aLayer4];
        [engine hita3];
    }
    BOOL isb0 = ([_msg rangeOfString:@"b0"].location !=NSNotFound);
    if (isb0) {
        [self endAnimatingLayer:_aLayer5];
        [self beginAnimatingLayer:_aLayer5];
        [engine hitb0];
    }
    BOOL isb1 = ([_msg rangeOfString:@"b1"].location !=NSNotFound);
    if (isb1) {
        [self endAnimatingLayer:_aLayer6];
        [self beginAnimatingLayer:_aLayer6];
        [engine hitb1];
    }
    BOOL isb2 = ([_msg rangeOfString:@"b2"].location !=NSNotFound);
    if (isb2) {
        [self endAnimatingLayer:_aLayer7];
        [self beginAnimatingLayer:_aLayer7];
        [engine hitb2];
    }
    BOOL isb3 = ([_msg rangeOfString:@"b3"].location !=NSNotFound);
    if (isb3) {
        [self endAnimatingLayer:_aLayer8];
        [self beginAnimatingLayer:_aLayer8];
        [engine hitb3];
    }
    BOOL isc0 = ([_msg rangeOfString:@"c0"].location !=NSNotFound);
    if (isc0) {
        NSLog(@"Play c0");
        [self endAnimatingLayer:_aLayer5];
        [self beginAnimatingLayer:_aLayer5];
        [engine hitb0];
    }
    BOOL isc1 = ([_msg rangeOfString:@"c1"].location !=NSNotFound);
    if (isc1) {
        NSLog(@"Play c1");
        [self endAnimatingLayer:_aLayer6];
        [self beginAnimatingLayer:_aLayer6];
        [engine hitb1];
    }
    BOOL isc2 = ([_msg rangeOfString:@"c2"].location !=NSNotFound);
    if (isc2) {
        NSLog(@"Play c2");
        [self endAnimatingLayer:_aLayer7];
        [self beginAnimatingLayer:_aLayer7];
        [engine hitb2];
    }
    BOOL isc3 = ([_msg rangeOfString:@"c3"].location !=NSNotFound);
    if (isc3) {
        NSLog(@"Play c3");
        [self endAnimatingLayer:_aLayer8];
        [self beginAnimatingLayer:_aLayer8];
        [engine hitb3];
    }
    
}

- (IBAction)playAmusicBack:(id)sender {
    _playID -= 1;
    if (_playID > 0) {
        [self updatePlayMusic];
    }else{
        _playID = 1;
        [self updatePlayMusic];
    }
}

- (IBAction)playorPauseAmusic:(id)sender {
    if(_playAmusicBtn.tag==1){
        _playAmusicBtn.tag=0;
        [sender setImage:[UIImage imageNamed:@"yxplay"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"yxplay"] forState:UIControlStateHighlighted];
        [self pause];
    }else{
        _playAmusicBtn.tag=1;
        [sender setImage:[UIImage imageNamed:@"yxstop"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"yxstop"] forState:UIControlStateHighlighted];
        [self play];
    }
}

- (IBAction)playAmusicNext:(id)sender {
    _playID += 1;
    if (_playID<9) {
        [self updatePlayMusic];
    }else{
        _playID = 1;
        [self updatePlayMusic];
    }
}

-(void)updatePlayMusic{
    switch (_playID) {
        case 1:
            kMusicTitle = kMusicTitle1;
            kMusicSinger = kMusicSinger1;
            kMusicImage = kMusicImage1;
            kMusicFile = kMusicFile1;
            break;
        case 2:
            kMusicTitle = kMusicTitle2;
            kMusicSinger = kMusicSinger2;
            kMusicImage = kMusicImage2;
            kMusicFile = kMusicFile2;
            break;
        case 3:
            kMusicTitle = kMusicTitle3;
            kMusicSinger = kMusicSinger3;
            kMusicImage = kMusicImage3;
            kMusicFile = kMusicFile3;
            break;
        case 4:
            kMusicTitle = kMusicTitle4;
            kMusicSinger = kMusicSinger4;
            kMusicImage = kMusicImage4;
            kMusicFile = kMusicFile4;
            break;
        case 5:
            kMusicTitle = kMusicTitle5;
            kMusicSinger = kMusicSinger5;
            kMusicImage = kMusicImage5;
            kMusicFile = kMusicFile5;
            break;
        case 6:
            kMusicTitle = kMusicTitle6;
            kMusicSinger = kMusicSinger6;
            kMusicImage = kMusicImage6;
            kMusicFile = kMusicFile6;
            break;
        case 7:
            kMusicTitle = kMusicTitle7;
            kMusicSinger = kMusicSinger7;
            kMusicImage = kMusicImage7;
            kMusicFile = kMusicFile7;
            break;
        case 8:
            kMusicTitle = kMusicTitle8;
            kMusicSinger = kMusicSinger8;
            kMusicImage = kMusicImage8;
            kMusicFile = kMusicFile8;
            break;
        default:
            break;
    }
    self.musicTitle.text=kMusicTitle;
    self.musicArtist.text=kMusicSinger;
    [self.playAlbumImage setImage:[UIImage imageNamed:kMusicImage]];
    [self updateAudioPlayer];
    [self play];
    //    _audioPlayer = [self audioPlayer];
    
}
/**
 *  更新播放进度
 */
-(void)updateProgress{
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
    [self.playProgress setProgress:progress animated:true];
}


-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

-(AVAudioPlayer *)audioPlayer{
    //    NSLog(@" kMusicFile %@:" ,kMusicFile);
    
    if (!_audioPlayer) {
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:kMusicFile ofType:nil];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        //设置后台播放模式
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [audioSession setActive:YES error:nil];
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
}

- (void)updateAudioPlayer{
    NSString *urlStr=[[NSBundle mainBundle]pathForResource:kMusicFile ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    NSError *error=nil;
    //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
    _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    //设置播放器属性
    _audioPlayer.numberOfLoops=0;//设置为0不循环
    _audioPlayer.delegate=self;
    [_audioPlayer prepareToPlay];//加载音频文件到缓存
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        //        return nil;
    }
    //设置后台播放模式
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [audioSession setActive:YES error:nil];
    //添加通知，拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
}

/**
 *  播放音频
 */
-(void)play{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate=[NSDate distantPast];//恢复定时器
    }
}

/**
 *  暂停播放
 */
-(void)pause{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
        
    }
}

/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }
    
    //    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"%@:%@",key,obj);
    //    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}

@end
