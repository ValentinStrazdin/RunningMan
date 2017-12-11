//
//  MapViewController.h
//  RunningMan
//
//  Created by Valentin Strazdin on 3/2/17.
//  Copyright © 2017 Valentin Strazdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#import "Run.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) Run *run;

@end
