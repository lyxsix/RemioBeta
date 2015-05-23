/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AudioEngine is the main controller class that creates the following objects:
 
                 It connects all the nodes, loads the buffers as well as controls the AVAudioEngine object itself.
*/

@import Foundation;
@import AVFoundation;

// effect strip 1 - Marimba Player -> Delay -> Mixer
// effect strip 2 - Drum Player -> Distortion -> Mixer

@protocol AudioEngineDelegate <NSObject>

@optional
- (void)engineConfigurationHasChanged;
- (void)mixerOutputFilePlayerHasStopped;

@end

@interface AudioEngine : NSObject

//new
@property (nonatomic,strong) AVAudioPlayerNode* L1PlayerNode;
@property (nonatomic,strong) AVAudioPlayerNode* L2PlayerNode;
@property (nonatomic,strong) AVAudioPlayerNode* L3PlayerNode;
@property (nonatomic,strong) AVAudioPlayerNode* L4PlayerNode;
@property (nonatomic,strong) AVAudioPlayerNode* R1PlayerNode;
@property (nonatomic,strong) AVAudioPlayerNode* R2PlayerNode;
@property (nonatomic,strong) AVAudioPlayerNode* R3PlayerNode;
@property (nonatomic,strong) AVAudioPlayerNode* R4PlayerNode;


//old ...
//@property (nonatomic, readonly) BOOL marimbaPlayerIsPlaying;
//@property (nonatomic, readonly) BOOL drumPlayerIsPlaying;


//new ...
@property (nonatomic, readonly) BOOL L1PlayerIsPlaying;
@property (nonatomic, readonly) BOOL L2PlayerIsPlaying;
@property (nonatomic, readonly) BOOL L3PlayerIsPlaying;
@property (nonatomic, readonly) BOOL L4PlayerIsPlaying;

@property (nonatomic, readonly) BOOL R1PlayerIsPlaying;
@property (nonatomic, readonly) BOOL R2PlayerIsPlaying;
@property (nonatomic, readonly) BOOL R3PlayerIsPlaying;
@property (nonatomic, readonly) BOOL R4PlayerIsPlaying;



//old ...
//@property (nonatomic) float marimbaPlayerVolume;    // 0.0 - 1.0
//@property (nonatomic) float drumPlayerVolume;       // 0.0 - 1.0
//
//@property (nonatomic) float marimbaPlayerPan;       // -1.0 - 1.0
//@property (nonatomic) float drumPlayerPan;          // -1.0 - 1.0

//new ...
@property (nonatomic) float L1PlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float L2PlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float L3PlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float L4PlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float R1PlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float R2PlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float R3PlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float R4PlayerVolume;    // 0.0 - 1.0


@property (nonatomic) float outputVolume;           // 0.0 - 1.0

@property (weak) id<AudioEngineDelegate> delegate;


//old
//- (void)toggleMarimba;
//- (void)toggleDrums;
//new
- (void)toggleL1;
- (void)toggleL2;
- (void)toggleL3;
- (void)toggleL4;
- (void)toggleR1;
- (void)toggleR2;
- (void)toggleR3;
- (void)toggleR4;

- (void)hita0;
- (void)hita1;
- (void)hita2;
- (void)hita3;
- (void)hitb0;
- (void)hitb1;
- (void)hitb2;
- (void)hitb3;





- (void)startRecordingMixerOutput;
- (void)stopRecordingMixerOutput;
- (void)playRecordedFile;
- (void)pausePlayingRecordedFile;
- (void)stopPlayingRecordedFile;

- (void)restEngine;

@end
