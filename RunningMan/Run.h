//
//  Run.h
//  RunningMan
//
//  Created by Valentin Strazdin on 7/26/16.
//  Copyright © 2016 Valentin Strazdin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MapPoint;

NS_ASSUME_NONNULL_BEGIN

@interface Run : NSManagedObject

@property (nonatomic, readonly) NSNumber * distance;
@property (nonatomic, readonly) MapPoint * lastMapPoint;

+ (NSArray *)allRuns;

+ (Run *)startRunWithLatitude:(double)theLatitude
                    longitude:(double)theLongitude;

- (void)addMapPointWithLatitude:(double)theLatitude
                      longitude:(double)theLongitude
                          speed:(double)theSpeed
                    timeElapsed:(double)theTimeElapsed;

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Run+CoreDataProperties.h"
