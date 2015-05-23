//
//  ViewController.m
//  RemioBeta
//
//  Created by Felix on 15/5/23.
//  Copyright (c) 2015年 wewing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL _isConnect;
    NSString* _msg;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initBle];
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
    //todo
//    _menuView.hidden = YES;
//    _mainView.hidden = YES;
//    _effectsView.hidden = YES;
}

- (IBAction)connectAction:(id)sender {
    [self connectBle];
    _connectState.titleLabel.text = @"Connecting ...";
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
            //todo
//            _connectView.hidden = YES;
//            _mainView.hidden = NO;
//            _menuView.hidden = NO;
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

@end
