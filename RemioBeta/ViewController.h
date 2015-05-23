//
//  ViewController.h
//  RemioBeta
//
//  Created by Felix on 15/5/23.
//  Copyright (c) 2015年 wewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBlunoManager.h"

@interface ViewController : UIViewController<DFBlunoDelegate>


@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDev;
@property(strong, nonatomic) NSMutableArray* aryDevices;


@end

