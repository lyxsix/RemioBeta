/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AudioEngine is the main controller class that creates the following objects:

 
                 It connects all the nodes, loads the buffers as well as controls the AVAudioEngine object itself.
*/

#import "AudioEngine.h"

@import AVFoundation;
@import Accelerate;

#pragma mark AudioEngine class extensions

@interface AudioEngine() {
    AVAudioEngine       *_engine;
    
    //old ...
//    AVAudioPlayerNode   *_aPlayer;
//    AVAudioPlayerNode   *_bPlayer;
    
    //new ... back to .h
    
    //old
//    AVAudioPCMBuffer    *_aBuff;
//    AVAudioPCMBuffer    *_bBuff;
    
    //new
    AVAudioPCMBuffer    *_l1Buff;
    AVAudioPCMBuffer    *_l2Buff;
    AVAudioPCMBuffer    *_l3Buff;
    AVAudioPCMBuffer    *_l4Buff;
    AVAudioPCMBuffer    *_r1Buff;
    AVAudioPCMBuffer    *_r2Buff;
    AVAudioPCMBuffer    *_r3Buff;
    AVAudioPCMBuffer    *_r4Buff;
    
    // for the node tap
    NSURL               *_mixerOutputFileURL;
    AVAudioPlayerNode   *_mixerOutputFilePlayer;
    BOOL                _mixerOutputFilePlayerIsPaused;
    BOOL                _isRecording;
    
    AVAudioPlayerNode *_a0p;
    AVAudioPlayerNode *_a1p;
    AVAudioPlayerNode *_a2p;
    AVAudioPlayerNode *_a3p;
    AVAudioPlayerNode *_b0p;
    AVAudioPlayerNode *_b1p;
    AVAudioPlayerNode *_b2p;
    AVAudioPlayerNode *_b3p;
 
    AVAudioPCMBuffer *_a0b;
    AVAudioPCMBuffer *_a1b;
    AVAudioPCMBuffer *_a2b;
    AVAudioPCMBuffer *_a3b;
    AVAudioPCMBuffer *_b0b;
    AVAudioPCMBuffer *_b1b;
    AVAudioPCMBuffer *_b2b;
    AVAudioPCMBuffer *_b3b;

}

- (void)handleInterruption:(NSNotification *)notification;
- (void)handleRouteChange:(NSNotification *)notification;

@end

#pragma mark AudioEngine implementation

@implementation AudioEngine

- (instancetype)init
{
    if (self = [super init]) {
        // create the various nodes
        
        /*  AVAudioPlayerNode supports scheduling the playback of AVAudioBuffer instances,
            or segments of audio files opened via AVAudioFile. Buffers and segments may be
            scheduled at specific points in time, or to play immediately following preceding segments. */
        //old
//        _aPlayer = [[AVAudioPlayerNode alloc] init];
//        _bPlayer = [[AVAudioPlayerNode alloc] init];
        //new
        _L1PlayerNode = [[AVAudioPlayerNode alloc] init];
        _L2PlayerNode = [[AVAudioPlayerNode alloc] init];
        _L3PlayerNode = [[AVAudioPlayerNode alloc] init];
        _L4PlayerNode = [[AVAudioPlayerNode alloc] init];
        _R1PlayerNode = [[AVAudioPlayerNode alloc] init];
        _R2PlayerNode = [[AVAudioPlayerNode alloc] init];
        _R3PlayerNode = [[AVAudioPlayerNode alloc] init];
        _R4PlayerNode = [[AVAudioPlayerNode alloc] init];
        
        
        /**----------Add audio Here----------*/
        _a0p = [[AVAudioPlayerNode alloc] init];
        _a1p = [[AVAudioPlayerNode alloc] init];
        _a2p = [[AVAudioPlayerNode alloc] init];
        _a3p = [[AVAudioPlayerNode alloc] init];
        _b0p = [[AVAudioPlayerNode alloc] init];
        _b1p = [[AVAudioPlayerNode alloc] init];
        _b2p = [[AVAudioPlayerNode alloc] init];
        _b3p = [[AVAudioPlayerNode alloc] init];
    

        
        /*  A delay unit delays the input signal by the specified time interval
            and then blends it with the input signal. The amount of high frequency
            roll-off can also be controlled in order to simulate the effect of
            a tape delay. */
        
        
        /*  A reverb simulates the acoustic characteristics of a particular environment.
            Use the different presets to simulate a particular space and blend it in with
            the original signal using the wetDryMix parameter. */

        _mixerOutputFilePlayer = [[AVAudioPlayerNode alloc] init];
        
        _mixerOutputFileURL = nil;
        _mixerOutputFilePlayerIsPaused = NO;
        _isRecording = NO;
        
        // create an instance of the engine and attach the nodes
        [self createEngineAndAttachNodes];
        
        NSError *error;
        
        //old
//        /**----------load marimba loop buff----------*/
//
//        NSURL *marimbaLoopURL=[self readAudioURL:@"marimba"];
//        AVAudioFile *marimbaLoopFile = [[AVAudioFile alloc] initForReading:marimbaLoopURL error:&error];
//        _aBuff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[marimbaLoopFile processingFormat] frameCapacity:(AVAudioFrameCount)[marimbaLoopFile length]];
//        NSAssert([marimbaLoopFile readIntoBuffer:_aBuff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
//        
//        
//        /**----------load drum loop buff---------*/
//
//        NSURL *drumLoopURL = [self readAudioURL:@"drum"];
//        AVAudioFile *drumLoopFile = [[AVAudioFile alloc] initForReading:drumLoopURL error:&error];
//        _bBuff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[drumLoopFile processingFormat] frameCapacity:(AVAudioFrameCount)[drumLoopFile length]];
//        NSAssert([drumLoopFile readIntoBuffer:_bBuff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        //new
        /**----------load l1 buff----------*/
        NSURL *l1URL = [self readAudioURL:@"l1"];
        AVAudioFile *l1File = [[AVAudioFile alloc] initForReading:l1URL error:&error];
        _l1Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[l1File processingFormat] frameCapacity:(AVAudioFrameCount)[l1File length]];
        NSAssert([l1File readIntoBuffer:_l1Buff error:&error], @"couldn't read l1File into buffer, %@", [error localizedDescription]);
        
        /**----------load l2 buff----------*/
        NSURL *l2URL = [self readAudioURL:@"l2"];
        AVAudioFile *l2File = [[AVAudioFile alloc] initForReading:l2URL error:&error];
        _l2Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[l2File processingFormat] frameCapacity:(AVAudioFrameCount)[l2File length]];
        NSAssert([l2File readIntoBuffer:_l2Buff error:&error], @"couldn't read l2File into buffer, %@", [error localizedDescription]);
        
        /**----------load l3 buff----------*/
        NSURL *l3URL = [self readAudioURL:@"l3"];
        AVAudioFile *l3File = [[AVAudioFile alloc] initForReading:l3URL error:&error];
        _l3Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[l3File processingFormat] frameCapacity:(AVAudioFrameCount)[l3File length]];
        NSAssert([l3File readIntoBuffer:_l3Buff error:&error], @"couldn't read l3File into buffer, %@", [error localizedDescription]);
        
        /**----------load l4 buff----------*/
        NSURL *l4URL = [self readAudioURL:@"l4"];
        AVAudioFile *l4File = [[AVAudioFile alloc] initForReading:l4URL error:&error];
        _l4Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[l4File processingFormat] frameCapacity:(AVAudioFrameCount)[l4File length]];
        NSAssert([l4File readIntoBuffer:_l4Buff error:&error], @"couldn't read l4File into buffer, %@", [error localizedDescription]);
        
        /**----------load r1 buff----------*/
        NSURL *r1URL = [self readAudioURL:@"r1"];
        AVAudioFile *r1File = [[AVAudioFile alloc] initForReading:r1URL error:&error];
        _r1Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[r1File processingFormat] frameCapacity:(AVAudioFrameCount)[r1File length]];
        NSAssert([r1File readIntoBuffer:_r1Buff error:&error], @"couldn't read r1File into buffer, %@", [error localizedDescription]);
        
        /**----------load r2 buff----------*/
        NSURL *r2URL = [self readAudioURL:@"r2"];
        AVAudioFile *r2File = [[AVAudioFile alloc] initForReading:r2URL error:&error];
        _r2Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[r2File processingFormat] frameCapacity:(AVAudioFrameCount)[r2File length]];
        NSAssert([r2File readIntoBuffer:_r2Buff error:&error], @"couldn't read r2File into buffer, %@", [error localizedDescription]);
        
        /**----------load r3 buff----------*/
        NSURL *r3URL = [self readAudioURL:@"r3"];
        AVAudioFile *r3File = [[AVAudioFile alloc] initForReading:r3URL error:&error];
        _r3Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[r3File processingFormat] frameCapacity:(AVAudioFrameCount)[r3File length]];
        NSAssert([r3File readIntoBuffer:_r3Buff error:&error], @"couldn't read r3File into buffer, %@", [error localizedDescription]);
        
        /**----------load r4 buff----------*/
        NSURL *r4URL = [self readAudioURL:@"r4"];
        AVAudioFile *r4File = [[AVAudioFile alloc] initForReading:r4URL error:&error];
        _r4Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[r4File processingFormat] frameCapacity:(AVAudioFrameCount)[r4File length]];
        NSAssert([r4File readIntoBuffer:_r4Buff error:&error], @"couldn't read r4File into buffer, %@", [error localizedDescription]);
        
        /**----------load a0 buff----------*/
        NSURL *a0URL = [self readAudioURL:@"a0"];
        AVAudioFile *a0File = [[AVAudioFile alloc] initForReading:a0URL error:&error];
        _a0b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[a0File processingFormat] frameCapacity:(AVAudioFrameCount)[a0File length]];
        NSAssert([a0File readIntoBuffer:_a0b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load a1 buff----------*/
        NSURL *a1URL = [self readAudioURL:@"a1"];
        AVAudioFile *a1File = [[AVAudioFile alloc] initForReading:a1URL error:&error];
        _a1b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[a1File processingFormat] frameCapacity:(AVAudioFrameCount)[a1File length]];
        NSAssert([a1File readIntoBuffer:_a1b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load a2 buff----------*/
        NSURL *a2URL = [self readAudioURL:@"a2"];
        AVAudioFile *a2File = [[AVAudioFile alloc] initForReading:a2URL error:&error];
        _a2b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[a2File processingFormat] frameCapacity:(AVAudioFrameCount)[a2File length]];
        NSAssert([a2File readIntoBuffer:_a2b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load a3 buff----------*/
        NSURL *a3URL = [self readAudioURL:@"a3"];
        AVAudioFile *a3File = [[AVAudioFile alloc] initForReading:a3URL error:&error];
        _a3b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[a3File processingFormat] frameCapacity:(AVAudioFrameCount)[a3File length]];
        NSAssert([a3File readIntoBuffer:_a3b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load b0 buff----------*/
        NSURL *b0URL = [self readAudioURL:@"b0"];
        AVAudioFile *b0File = [[AVAudioFile alloc] initForReading:b0URL error:&error];
        _b0b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[b0File processingFormat] frameCapacity:(AVAudioFrameCount)[b0File length]];
        NSAssert([b0File readIntoBuffer:_b0b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load b1 buff----------*/
        NSURL *b1URL = [self readAudioURL:@"b1"];
        AVAudioFile *b1File = [[AVAudioFile alloc] initForReading:b1URL error:&error];
        _b1b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[b1File processingFormat] frameCapacity:(AVAudioFrameCount)[b1File length]];
        NSAssert([b1File readIntoBuffer:_b1b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load b2 buff----------*/
        NSURL *b2URL = [self readAudioURL:@"b2"];
        AVAudioFile *b2File = [[AVAudioFile alloc] initForReading:b2URL error:&error];
        _b2b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[b2File processingFormat] frameCapacity:(AVAudioFrameCount)[b2File length]];
        NSAssert([b2File readIntoBuffer:_b2b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load b3 buff----------*/
        NSURL *b3URL = [self readAudioURL:@"b3"];
        AVAudioFile *b3File = [[AVAudioFile alloc] initForReading:b3URL error:&error];
        _b3b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[b3File processingFormat] frameCapacity:(AVAudioFrameCount)[b3File length]];
        NSAssert([b3File readIntoBuffer:_b3b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        
        // sign up for notifications from the engine if there's a hardware config change
        [[NSNotificationCenter defaultCenter] addObserverForName:AVAudioEngineConfigurationChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            // if we've received this notification, something has changed and the engine has been stopped
            // re-wire all the connections and start the engine
            NSLog(@"Received a %@ notification!", AVAudioEngineConfigurationChangeNotification);
            NSLog(@"Re-wiring connections and starting once again");
            [self makeEngineConnections];
            [self startEngine];
            
            // post notification
            if ([self.delegate respondsToSelector:@selector(engineConfigurationHasChanged)]) {
                [self.delegate engineConfigurationHasChanged];
            }
        }];
        
        // AVAudioSession setup
        [self initAVAudioSession];
        
        // make engine connections
        [self makeEngineConnections];
        
        // start the engine
        [self startEngine];
    }
    return self;
}

- (NSURL *)readAudioURL:(NSString *)audioID{
    NSURL *audioURL;
    NSString *audioFile;
    NSString *audioName;
    if ([audioID  isEqual: @"r1"]) {
        audioName = @"r1.mp3";
    }else if([audioID isEqual:@"r2"]){
        audioName = @"r2.mp3";
    }else if([audioID isEqual:@"r3"]){
        audioName = @"r3.mp3";
    }else if([audioID isEqual:@"r4"]){
        audioName = @"r4.mp3";
    }else if([audioID isEqual:@"l1"]){
        audioName = @"l1.mp3";
    }else if([audioID isEqual:@"l2"]){
        audioName = @"l2.mp3";
    }else if([audioID isEqual:@"l3"]){
        audioName = @"l3.mp3";
    }else if([audioID isEqual:@"l4"]){
        audioName = @"l4.mp3";
    }else if([audioID isEqual:@"a0"]){
        audioName = @"bass_guitar1.wav";
    }else if([audioID isEqual:@"a1"]){
        audioName = @"bass_guitar2.wav";
    }else if([audioID isEqual:@"a2"]){
        audioName = @"bass_guitar3.wav";
    }else if([audioID isEqual:@"a3"]){
        audioName = @"bass_guitar4.wav";
    }else if([audioID isEqual:@"b0"]){
        audioName = @"electric_guitar1.wav";
    }else if([audioID isEqual:@"b1"]){
        audioName = @"electric_guitar2.wav";
    }else if([audioID isEqual:@"b2"]){
        audioName = @"electric_guitar3.wav";
    }else if([audioID isEqual:@"b3"]){
        audioName = @"electric_guitar4.wav";
    }else {
        audioName = @"guitdo.wav";
    }
    audioFile=[[NSBundle mainBundle] pathForResource:audioName ofType:nil];
    audioURL = [NSURL fileURLWithPath:audioFile];

    return audioURL;

}

- (void)createEngineAndAttachNodes
{
    /*  An AVAudioEngine contains a group of connected AVAudioNodes ("nodes"), each of which performs
		an audio signal generation, processing, or input/output task.
		
		Nodes are created separately and attached to the engine.

		The engine supports dynamic connection, disconnection and removal of nodes while running,
		with only minor limitations:
		- all dynamic reconnections must occur upstream of a mixer
		- while removals of effects will normally result in the automatic connection of the adjacent
			nodes, removal of a node which has differing input vs. output channel counts, or which
			is a mixer, is likely to result in a broken graph. */

    _engine = [[AVAudioEngine alloc] init];
    
    /*  To support the instantiation of arbitrary AVAudioNode subclasses, instances are created
		externally to the engine, but are not usable until they are attached to the engine via
		the attachNode method. */
    
    //old
//    [_engine attachNode:_aPlayer];
//    [_engine attachNode:_bPlayer];
    
    //new
    [_engine attachNode:_L1PlayerNode];
    [_engine attachNode:_L2PlayerNode];
    [_engine attachNode:_L3PlayerNode];
    [_engine attachNode:_L4PlayerNode];
    [_engine attachNode:_R1PlayerNode];
    [_engine attachNode:_R2PlayerNode];
    [_engine attachNode:_R3PlayerNode];
    [_engine attachNode:_R4PlayerNode];
    
    
    [_engine attachNode:_a0p];
    [_engine attachNode:_a1p];
    [_engine attachNode:_a2p];
    [_engine attachNode:_a3p];
    [_engine attachNode:_b0p];
    [_engine attachNode:_b1p];
    [_engine attachNode:_b2p];
    [_engine attachNode:_b3p];
    
    [_engine attachNode:_mixerOutputFilePlayer];
}

- (void)makeEngineConnections
{
    /*  The engine will construct a singleton main mixer and connect it to the outputNode on demand,
		when this property is first accessed. You can then connect additional nodes to the mixer.
		
		By default, the mixer's output format (sample rate and channel count) will track the format 
		of the output node. You may however make the connection explicitly with a different format. */
    
    // get the engine's optional singleton main mixer node
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    
    // establish a connection between nodes
    
    /*  Nodes have input and output buses (AVAudioNodeBus). Use connect:to:fromBus:toBus:format: to
        establish connections betweeen nodes. Connections are always one-to-one, never one-to-many or
		many-to-one.
	
		Note that any pre-existing connection(s) involving the source's output bus or the
		destination's input bus will be broken.
    
        @method connect:to:fromBus:toBus:format:
        @param node1 the source node
        @param node2 the destination node
        @param bus1 the output bus on the source node
        @param bus2 the input bus on the destination node
        @param format if non-null, the format of the source node's output bus is set to this
            format. In all cases, the format of the destination node's input bus is set to
            match that of the source node's output bus. */
    
    // A player -> main mixer
//    [_engine connect:_aPlayer to:mainMixer format:_aBuff.format];
    
    // B player -> main mixer
//    [_engine connect:_bPlayer to:mainMixer format:_bBuff.format];
    
    [_engine connect:_L1PlayerNode to:mainMixer format:_l1Buff.format];
    [_engine connect:_L2PlayerNode to:mainMixer format:_l2Buff.format];
    [_engine connect:_L3PlayerNode to:mainMixer format:_l3Buff.format];
    [_engine connect:_L4PlayerNode to:mainMixer format:_l4Buff.format];
    [_engine connect:_R1PlayerNode to:mainMixer format:_r1Buff.format];
    [_engine connect:_R2PlayerNode to:mainMixer format:_r2Buff.format];
    [_engine connect:_R3PlayerNode to:mainMixer format:_r3Buff.format];
    [_engine connect:_R4PlayerNode to:mainMixer format:_r4Buff.format];
    
    [_engine connect:_a0p to:mainMixer format:_a0b.format];
    [_engine connect:_a1p to:mainMixer format:_a0b.format];
    [_engine connect:_a2p to:mainMixer format:_a0b.format];
    [_engine connect:_a3p to:mainMixer format:_a0b.format];
    [_engine connect:_b0p to:mainMixer format:_a0b.format];
    [_engine connect:_b1p to:mainMixer format:_a0b.format];
    [_engine connect:_b2p to:mainMixer format:_a0b.format];
    [_engine connect:_b3p to:mainMixer format:_a0b.format];
    
    // node tap player
    [_engine connect:_mixerOutputFilePlayer to:mainMixer format:[mainMixer outputFormatForBus:0]];
}

- (void)startEngine
{
    // start the engine
    
    /*  startAndReturnError: calls prepare if it has not already been called since stop.
	
		Starts the audio hardware via the AVAudioInputNode and/or AVAudioOutputNode instances in
		the engine. Audio begins flowing through the engine.
	
        This method will return YES for sucess.
     
		Reasons for potential failure include:
		
		1. There is problem in the structure of the graph. Input can't be routed to output or to a
			recording tap through converter type nodes.
		2. An AVAudioSession error.
		3. The driver failed to start the hardware. */
    
    NSError *error;
    NSAssert([_engine startAndReturnError:&error], @"couldn't start engine, %@", [error localizedDescription]);
}

//- (void)toggleMarimba {
//    if (!self.marimbaPlayerIsPlaying) {
//        [_aPlayer scheduleBuffer:_aBuff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
//        [_aPlayer play];
//    } else
//        [_aPlayer stop];
//}
//
//- (void)toggleDrums {
//    if (!self.drumPlayerIsPlaying) {
//        [_bPlayer scheduleBuffer:_bBuff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
//        [_bPlayer play];
//    } else
//        [_bPlayer stop];
//}

- (void)toggleL1{
    if (!self.L1PlayerIsPlaying) {
        [_L1PlayerNode scheduleBuffer:_l1Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_L1PlayerNode play];
    }else{
        [_L1PlayerNode stop];
    }
}

- (void)toggleL2{
    if (!self.L2PlayerIsPlaying) {
        [_L2PlayerNode scheduleBuffer:_l2Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_L2PlayerNode play];
    }else{
        [_L2PlayerNode stop];
    }
}

- (void)toggleL3{
    if (!self.L3PlayerIsPlaying) {
        [_L3PlayerNode scheduleBuffer:_l3Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_L3PlayerNode play];
    }else{
        [_L3PlayerNode stop];
    }
}

- (void)toggleL4{
    if (!self.L4PlayerIsPlaying) {
        [_L4PlayerNode scheduleBuffer:_l4Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_L4PlayerNode play];
    }else{
        [_L4PlayerNode stop];
    }
}

- (void)toggleR1{
    if (!self.R1PlayerIsPlaying) {
        [_R1PlayerNode scheduleBuffer:_r1Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_R1PlayerNode play];
    }else{
        [_R1PlayerNode stop];
    }
}

- (void)toggleR2{
    if (!self.R2PlayerIsPlaying) {
        [_R2PlayerNode scheduleBuffer:_r2Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_R2PlayerNode play];
    }else{
        [_R2PlayerNode stop];
    }
}

- (void)toggleR3{
    if (!self.R3PlayerIsPlaying) {
        [_R3PlayerNode scheduleBuffer:_r3Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_R3PlayerNode play];
    }else{
        [_R3PlayerNode stop];
    }
}

- (void)toggleR4{
    if (!self.R4PlayerIsPlaying) {
        [_R4PlayerNode scheduleBuffer:_r4Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_R4PlayerNode play];
    }else{
        [_R4PlayerNode stop];
    }
}

- (void)hita0{
    [_a0p scheduleBuffer:_a0b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_a0p play];
}

- (void)hita1{
    [_a1p scheduleBuffer:_a1b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_a1p play];
}

- (void)hita2{
    [_a2p scheduleBuffer:_a2b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_a2p play];
}

- (void)hita3{
    [_a3p scheduleBuffer:_a3b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_a3p play];
}

- (void)hitb0{
    [_b0p scheduleBuffer:_b0b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_b0p play];
}

- (void)hitb1{
    [_b1p scheduleBuffer:_b1b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_b1p play];
}

- (void)hitb2{
    [_b2p scheduleBuffer:_b2b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_b2p play];
}

- (void)hitb3{
    [_b3p scheduleBuffer:_b3b atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_b3p play];
}

- (void)startRecordingMixerOutput
{
    // install a tap on the main mixer output bus and write output buffers to file
    
    /*  The method installTapOnBus:bufferSize:format:block: will create a "tap" to record/monitor/observe the output of the node.
	
        @param bus
            the node output bus to which to attach the tap
        @param bufferSize
            the requested size of the incoming buffers. The implementation may choose another size.
        @param format
            If non-nil, attempts to apply this as the format of the specified output bus. This should
            only be done when attaching to an output bus which is not connected to another node; an
            error will result otherwise.
            The tap and connection formats (if non-nil) on the specified bus should be identical. 
            Otherwise, the latter operation will override any previously set format.
            Note that for AVAudioOutputNode, tap format must be specified as nil.
        @param tapBlock
            a block to be called with audio buffers

		Only one tap may be installed on any bus. Taps may be safely installed and removed while
		the engine is running. */
    
    NSError *error;
    if (!_mixerOutputFileURL) _mixerOutputFileURL = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"mixerOutput.caf"]];
    
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    AVAudioFile *mixerOutputFile = [[AVAudioFile alloc] initForWriting:_mixerOutputFileURL settings:[[mainMixer outputFormatForBus:0] settings] error:&error];
    NSAssert(mixerOutputFile != nil, @"mixerOutputFile is nil, %@", [error localizedDescription]);
    
    if (!_engine.isRunning) [self startEngine];
    [mainMixer installTapOnBus:0 bufferSize:4096 format:[mainMixer outputFormatForBus:0] block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
        NSError *error;
        
        // as AVAudioPCMBuffer's are delivered this will write sequentially. The buffer's frameLength signifies how much of the buffer is to be written
        // IMPORTANT: The buffer format MUST match the file's processing format which is why outputFormatForBus: was used when creating the AVAudioFile object above
        NSAssert([mixerOutputFile writeFromBuffer:buffer error:&error], @"error writing buffer data to file, %@", [error localizedDescription]);
    }];
    _isRecording = true;
}

- (void)stopRecordingMixerOutput
{
    // stop recording really means remove the tap on the main mixer that was created in startRecordingMixerOutput
    if (_isRecording) {
        [[_engine mainMixerNode] removeTapOnBus:0];
        _isRecording = NO;
    }
}

- (void)playRecordedFile
{
    if (_mixerOutputFilePlayerIsPaused) {
        [_mixerOutputFilePlayer play];
    }
    else {
        if (_mixerOutputFileURL) {
            NSError *error;
            AVAudioFile *recordedFile = [[AVAudioFile alloc] initForReading:_mixerOutputFileURL error:&error];
            NSAssert(recordedFile != nil, @"recordedFile is nil, %@", [error localizedDescription]);
            [_mixerOutputFilePlayer scheduleFile:recordedFile atTime:nil completionHandler:^{
                _mixerOutputFilePlayerIsPaused = NO;
                
                // the data in the file has been scheduled but the player isn't actually done playing yet
                // calculate the approximate time remaining for the player to finish playing and then dispatch the notification to the main thread
                AVAudioTime *playerTime = [_mixerOutputFilePlayer playerTimeForNodeTime:_mixerOutputFilePlayer.lastRenderTime];
                double delayInSecs = (recordedFile.length - playerTime.sampleTime) / recordedFile.processingFormat.sampleRate;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSecs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(mixerOutputFilePlayerHasStopped)])
                        [self.delegate mixerOutputFilePlayerHasStopped];
                    [_mixerOutputFilePlayer stop];
                });
            }];
            [_mixerOutputFilePlayer play];
            _mixerOutputFilePlayerIsPaused = NO;
        }
    }
}

- (void)stopPlayingRecordedFile
{
    [_mixerOutputFilePlayer stop];
    _mixerOutputFilePlayerIsPaused = NO;
}

- (void)pausePlayingRecordedFile
{
    [_mixerOutputFilePlayer pause];
    _mixerOutputFilePlayerIsPaused = YES;
}

//old
//- (BOOL)marimbaPlayerIsPlaying
//{
//    return _aPlayer.isPlaying;
//}
//
//- (BOOL)drumPlayerIsPlaying
//{
//    return _bPlayer.isPlaying;
//}

//new

- (BOOL)L1PlayerIsPlaying
{
    return _L1PlayerNode.isPlaying;
}

- (BOOL)L2PlayerIsPlaying
{
    return _L2PlayerNode.isPlaying;
}

- (BOOL)L3PlayerIsPlaying
{
    return _L3PlayerNode.isPlaying;
}

- (BOOL)L4PlayerIsPlaying
{
    return _L4PlayerNode.isPlaying;
}

- (BOOL)R1PlayerIsPlaying
{
    return _R1PlayerNode.isPlaying;
}

- (BOOL)R2PlayerIsPlaying
{
    return _R2PlayerNode.isPlaying;
}

- (BOOL)R3PlayerIsPlaying
{
    return _R3PlayerNode.isPlaying;
}

- (BOOL)R4PlayerIsPlaying
{
    return _R4PlayerNode.isPlaying;
}


//old
//- (void)setMarimbaPlayerVolume:(float)marimbaPlayerVolume
//{
//    _aPlayer.volume = marimbaPlayerVolume;
//}
//
//- (float)marimbaPlayerVolume
//{
//    return _aPlayer.volume;
//}
//
//- (void)setDrumPlayerVolume:(float)drumPlayerVolume
//{
//    _bPlayer.volume = drumPlayerVolume;
//}
//
//- (float)drumPlayerVolume
//{
//    return _bPlayer.volume;
//}

//new

- (void)setL1PlayerVolume:(float)L1PlayerVolume
{
    _L1PlayerNode.volume = L1PlayerVolume;
}

- (float)L1PlayerVolume
{
    return _L1PlayerNode.volume;
}

- (void)setL2PlayerVolume:(float)L2PlayerVolume
{
    _L2PlayerNode.volume = L2PlayerVolume;
}

- (float)L2PlayerVolume
{
    return _L2PlayerNode.volume;
}

- (void)setL3PlayerVolume:(float)L3PlayerVolume
{
    _L3PlayerNode.volume = L3PlayerVolume;
}

- (float)L3PlayerVolume
{
    return _L3PlayerNode.volume;
}

- (void)setL4PlayerVolume:(float)L4PlayerVolume
{
    _L4PlayerNode.volume = L4PlayerVolume;
}

- (float)L4PlayerVolume
{
    return _L4PlayerNode.volume;
}

- (void)setR1PlayerVolume:(float)R1PlayerVolume
{
    _R1PlayerNode.volume = R1PlayerVolume;
}

- (float)R1PlayerVolume
{
    return _R1PlayerNode.volume;
}

- (void)setR2PlayerVolume:(float)R2PlayerVolume
{
    _R2PlayerNode.volume = R2PlayerVolume;
}

- (float)R2PlayerVolume
{
    return _R2PlayerNode.volume;
}

- (void)setR3PlayerVolume:(float)R3PlayerVolume
{
    _R3PlayerNode.volume = R3PlayerVolume;
}

- (float)R3PlayerVolume
{
    return _R3PlayerNode.volume;
}

- (void)setR4PlayerVolume:(float)R4PlayerVolume
{
    _R4PlayerNode.volume = R4PlayerVolume;
}

- (float)R4PlayerVolume
{
    return _R4PlayerNode.volume;
}


- (void)setOutputVolume:(float)outputVolume
{
    _engine.mainMixerNode.outputVolume = outputVolume;
}

- (float)outputVolume
{
    return _engine.mainMixerNode.outputVolume;
}




#pragma mark AVAudioSession

- (void)initAVAudioSession
{
    // For complete details regarding the use of AVAudioSession see the AVAudioSession Programming Guide
    // https://developer.apple.com/library/ios/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/Introduction/Introduction.html
    
    // Configure the audio session
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    NSError *error;
    
    // set the session category
    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    
    double hwSampleRate = 44100.0;
    success = [sessionInstance setPreferredSampleRate:hwSampleRate error:&error];
    if (!success) NSLog(@"Error setting preferred sample rate! %@\n", [error localizedDescription]);
    
    NSTimeInterval ioBufferDuration = 0.0029;
    success = [sessionInstance setPreferredIOBufferDuration:ioBufferDuration error:&error];
    if (!success) NSLog(@"Error setting preferred io buffer duration! %@\n", [error localizedDescription]);
    
    // add interruption handler
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:sessionInstance];
    
    // we don't do anything special in the route change notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:sessionInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMediaServicesReset:)
                                                 name:AVAudioSessionMediaServicesWereResetNotification
                                               object:sessionInstance];
    
    // activate the audio session
    success = [sessionInstance setActive:YES error:&error];
    if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
}

- (void)handleInterruption:(NSNotification *)notification
{
    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    
    NSLog(@"Session interrupted > --- %s ---\n", theInterruptionType == AVAudioSessionInterruptionTypeBegan ? "Begin Interruption" : "End Interruption");
    
    if (theInterruptionType == AVAudioSessionInterruptionTypeBegan) {
        // the engine will pause itself
    }
    if (theInterruptionType == AVAudioSessionInterruptionTypeEnded) {
        // make sure to activate the session
        NSError *error;
        bool success = [[AVAudioSession sharedInstance] setActive:YES error:&error];
        if (!success) NSLog(@"AVAudioSession set active failed with error: %@", [error localizedDescription]);
        
        // start the engine once again
        [self startEngine];
    }
}

- (void)handleRouteChange:(NSNotification *)notification
{
    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
    AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
    
    NSLog(@"Route change:");
    switch (reasonValue) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"     NewDeviceAvailable");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"     OldDeviceUnavailable");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"     CategoryChange");
            NSLog(@" New Category: %@", [[AVAudioSession sharedInstance] category]);
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            NSLog(@"     Override");
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            NSLog(@"     WakeFromSleep");
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            NSLog(@"     NoSuitableRouteForCategory");
            break;
        default:
            NSLog(@"     ReasonUnknown");
    }
    
    NSLog(@"Previous route:\n");
    NSLog(@"%@", routeDescription);
}

- (void)handleMediaServicesReset:(NSNotification *)notification
{
    // if we've received this notification, the media server has been reset
    // re-wire all the connections and start the engine
    NSLog(@"Media services have been reset!");
    NSLog(@"Re-wiring connections and starting once again");
    
    [self createEngineAndAttachNodes];
    [self makeEngineConnections];
    [self startEngine];
    
    // post notification
    if ([self.delegate respondsToSelector:@selector(engineConfigurationHasChanged)]) {
        [self.delegate engineConfigurationHasChanged];
    }
}

- (void)restEngine;
{
//    NSError *error;
//    [_engine disconnectNodeInput:_a0p];
//    _a0p = [[AVAudioPlayerNode alloc] init];
    
//    NSURL *a0URL = [self readAudioURL:@"a1"];
//    
//    AVAudioFile *a0File = [[AVAudioFile alloc] initForReading:a0URL error:nil];
//    _a0b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[a0File processingFormat] frameCapacity:(AVAudioFrameCount)[a0File length]];
//    NSError *error;
//    NSAssert([a0File readIntoBuffer:_a0b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
    
//    NSLog(@"AudioEngine aStr is : %@",_a0Str);
//    NSURL *a0URL = [self readAudioURL:_a0Str];
//    AVAudioFile *a0File = [[AVAudioFile alloc] initForReading:a0URL error:&error];
//    _a0b = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[a0File processingFormat] frameCapacity:(AVAudioFrameCount)[a0File length]];
//    NSAssert([a0File readIntoBuffer:_a0b error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
    [self createEngineAndAttachNodes];
    [self makeEngineConnections];
    [self startEngine];

    
}

@end
