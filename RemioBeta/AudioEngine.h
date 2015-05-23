/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AudioEngine is the main controller class that creates the following objects:
                    AVAudioEngine       *_engine;
                    AVAudioPlayerNode   *_marimbaPlayer;
                    AVAudioPlayerNode   *_drumPlayer;
                    AVAudioUnitDelay    *_delay;
                    AVAudioUnitReverb   *_reverb;
                    AVAudioPCMBuffer    *_marimbaLoopBuffer;
                    AVAudioPCMBuffer    *_drumLoopBuffer;
                    
                    AVAudioPlayerNode *_hit0Player;
                    AVAudioPlayerNode *_hit1Player;
                    AVAudioPlayerNode *_hit2Player;
                    AVAudioPlayerNode *_hit3Player;
                    AVAudioPlayerNode *_hit4Player;
                    AVAudioPlayerNode *_hit5Player;
                    AVAudioPlayerNode *_hit6Player;
                    AVAudioPlayerNode *_hit7Player;
                    AVAudioPlayerNode *_hit8Player;
                    AVAudioPlayerNode *_hit9Player;
                    AVAudioPlayerNode *_hit10Player;
                    AVAudioPlayerNode *_hit11Player;
 
 
                 It connects all the nodes, loads the buffers as well as controls the AVAudioEngine object itself.
*/

@import Foundation;

// effect strip 1 - Marimba Player -> Delay -> Mixer
// effect strip 2 - Drum Player -> Distortion -> Mixer

@protocol AudioEngineDelegate <NSObject>

@optional
- (void)engineConfigurationHasChanged;
- (void)mixerOutputFilePlayerHasStopped;

@end

@interface AudioEngine : NSObject

@property (nonatomic, readonly) BOOL marimbaPlayerIsPlaying;
@property (nonatomic, readonly) BOOL drumPlayerIsPlaying;
//@property (nonatomic, readonly) BOOL hit0IsPlaying;

@property (nonatomic) float marimbaPlayerVolume;    // 0.0 - 1.0
@property (nonatomic) float drumPlayerVolume;       // 0.0 - 1.0

@property (nonatomic) float marimbaPlayerPan;       // -1.0 - 1.0
@property (nonatomic) float drumPlayerPan;          // -1.0 - 1.0

@property (nonatomic) float outputVolume;           // 0.0 - 1.0

@property (strong, nonatomic)  NSString *a0Str;
@property (strong, nonatomic)  NSString *a1Str;

@property (weak) id<AudioEngineDelegate> delegate;


- (void)toggleMarimba;
- (void)toggleDrums;
//- (void)toggleHit0;
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
