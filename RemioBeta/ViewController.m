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

@interface ViewController ()<JZDragViewDelegate,AudioEngineDelegate>
{
    BOOL _isConnect;
    NSString* _msg;
}
@property (nonatomic, weak)JZDragView *dragLView;
@property (nonatomic, weak)JZDragView *dragRView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initBle];
    [self initDragView];
    [self initMyAudio];
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

- (IBAction)connectAction:(id)sender {
    [self connectBle];
    _connectState.titleLabel.text = @"Connecting ...";
}

#pragma mark- dragViewDelegate
- (void)dragViewDidEndScrollingAnimation:(JZDragView *)dragView {
    NSLog(@"%s",__func__);
    if (dragView == _dragLView) {
        NSLog(@"dragLView currentIndex:%ld",(long)_dragLView.currentIndex);
        if (_dragLView.currentIndex == 0) {
            [engine toggleL1];
            [engine.L2PlayerNode stop];
            [engine.L3PlayerNode stop];
            [engine.L4PlayerNode stop];
        }else if (_dragLView.currentIndex == 1){
            [engine.L1PlayerNode stop];
            [engine toggleL2];
            [engine.L3PlayerNode stop];
            [engine.L4PlayerNode stop];
        }else if (_dragLView.currentIndex == 2){
            [engine.L1PlayerNode stop];
            [engine.L2PlayerNode stop];
            [engine toggleL3];
            [engine.L4PlayerNode stop];
        }else if (_dragLView.currentIndex){
            [engine.L1PlayerNode stop];
            [engine.L2PlayerNode stop];
            [engine.L3PlayerNode stop];
            [engine toggleL4];
        }
    }else if(dragView == _dragRView){
        NSLog(@"dragRView currentIndex:%ld",(long)_dragRView.currentIndex);
        if (_dragRView.currentIndex == 0) {
            [engine toggleR1];
            [engine.R2PlayerNode stop];
            [engine.R3PlayerNode stop];
            [engine.R4PlayerNode stop];
        }else if (_dragRView.currentIndex == 1){
            [engine.R1PlayerNode stop];
            [engine toggleR2];
            [engine.R3PlayerNode stop];
            [engine.R4PlayerNode stop];
        }else if (_dragRView.currentIndex == 2){
            [engine.R1PlayerNode stop];
            [engine.R2PlayerNode stop];
            [engine toggleR3];
            [engine.R4PlayerNode stop];
        }else if (_dragRView.currentIndex){
            [engine.R1PlayerNode stop];
            [engine.R2PlayerNode stop];
            [engine.R3PlayerNode stop];
            [engine toggleR4];
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
    NSLog(@"%@",_msg);
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
    
    [engine toggleL1];
    [engine toggleR1];
    
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
}
- (IBAction)restMixAction:(id)sender {
}

- (IBAction)recordMixAction:(id)sender {
}

- (IBAction)playRecordAction:(id)sender {
}

@end
