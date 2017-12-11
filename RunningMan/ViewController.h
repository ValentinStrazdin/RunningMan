//
//  ViewController.h
//  RunningMan
//
//  Created by Valentin Strazdin on 9/26/14.
//  Copyright (c) 2014 Valentin Strazdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


typedef enum {
    TimerStateStop = 0,
    TimerStateStart
} TimerState;

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic,assign) TimerState timerState;

@end

