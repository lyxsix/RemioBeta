//
//  ViewController.h
//  RemioBeta
//
//  Created by Felix on 15/5/23.
//  Copyright (c) 2015年 wewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBlunoManager.h"
@class AudioEngine;

@interface ViewController : UIViewController<DFBlunoDelegate>
{
    AudioEngine *engine;
}


@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDev;
@property(strong, nonatomic) NSMutableArray* aryDevices;

@property (strong, nonatomic) IBOutlet UIView *page2View;
@property (strong, nonatomic) IBOutlet UIView *page3View;
@property (strong, nonatomic) IBOutlet UIView *page4View;
@property (strong, nonatomic) IBOutlet UIView *page5View;
@property (strong, nonatomic) IBOutlet UIView *page6View;
@property (strong, nonatomic) IBOutlet UIView *page7View;
@property (strong, nonatomic) IBOutlet UIView *page8View;
@property (strong, nonatomic) IBOutlet UIView *page9View;
@property (strong, nonatomic) IBOutlet UIView *page10View;
@property (strong, nonatomic) IBOutlet UIView *topTabView;
@property (strong, nonatomic) IBOutlet UIView *bottomTabView;




//menu
/*to page2*/
- (IBAction)toHomeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *toHomeBtn;

@property (strong, nonatomic) IBOutlet UIButton *toRemioMixBtn;
- (IBAction)toRemioMixAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *toMusicBtn;
- (IBAction)toMusicAction:(id)sender;

//tab
- (IBAction)shareAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *songBtn;
- (IBAction)toSongAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *artistBtn;
- (IBAction)artistAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *albumBtn;
- (IBAction)albumAction:(id)sender;


//page2
@property (weak, nonatomic) IBOutlet UIButton *connectState;

- (IBAction)connectAction:(id)sender;

//page3 Action
- (IBAction)play1MusicAction:(id)sender;
- (IBAction)play2MusicAction:(id)sender;
- (IBAction)play3MusicAction:(id)sender;
- (IBAction)play4MusicAction:(id)sender;

- (IBAction)toPage4Action:(id)sender;

//page4 Action
- (IBAction)return2Page3Action:(id)sender;

//page7
- (IBAction)exitPage7:(id)sender;


//page8 Action
- (IBAction)playAllAction:(id)sender;

//page 9
@property (strong, nonatomic) IBOutlet UIView *leftAlbum;
@property (strong, nonatomic) IBOutlet UIView *rightAlbum;
@property (strong, nonatomic) IBOutlet UIButton *restMixBtn;
@property (strong, nonatomic) IBOutlet UIButton *recordMixBtn;
@property (strong, nonatomic) IBOutlet UIButton *playRecordBtn;
- (IBAction)restMixAction:(id)sender;
- (IBAction)recordMixAction:(id)sender;
- (IBAction)playRecordAction:(id)sender;


//page 10
@property (strong, nonatomic) IBOutlet UIProgressView *playProgress;
@property (strong, nonatomic) IBOutlet UIImageView *playAlbumImage;
@property (strong, nonatomic) IBOutlet UILabel *musicTitle;
@property (strong, nonatomic) IBOutlet UILabel *musicArtist;


//audio property
@property (getter=isRecording) BOOL recording;
@property (getter=isPlaying) BOOL playing;
@property BOOL canPlayback;

@end

