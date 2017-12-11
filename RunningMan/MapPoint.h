//
//  MapPoint.h
//  RunningMan
//
//  Created by Valentin Strazdin on 9/26/14.
//  Copyright (c) 2014 Valentin Strazdin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


@interface MapPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * timeElapsed;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * speed;

@property (readonly) CLLocation *location;

+ (NSArray *)mapPoints;
+ (MapPoint *)lastMapPoint;
+ (void)addMapPointWithLatitude:(double)theLatitude
                      longitude:(double)theLongitude
                          speed:(double)theSpeed
                    timeElapsed:(double)theTimeElapsed;
- (int)distanceFromPointLatitude:(double)newPointLatitude
                          longitude:(double)newPointLongitude;

@end
