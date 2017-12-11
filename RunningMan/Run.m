//
//  Run.m
//  RunningMan
//
//  Created by Valentin Strazdin on 7/26/16.
//  Copyright © 2016 Valentin Strazdin. All rights reserved.
//

#import "Run.h"
#import "MapPoint.h"
#import "NSManagedObject+SVExtensions.h"

@implementation Run

@dynamic distance, lastMapPoint;

// Insert code here to add functionality to your managed object subclass

+ (NSArray *)allRuns {
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [self cachedObjectsWithPredicate:nil sortDescriptors:@[sortDescriptor]];
}

+ (Run *)startRunWithLatitude:(double)theLatitude
                    longitude:(double)theLongitude {
    Run *newRun = [[self class] createNew];
    newRun.date = [NSDate date];
    MapPoint *newMapPoint = [MapPoint createNew];
    newMapPoint.latitude = @(theLatitude);
    newMapPoint.longitude = @(theLongitude);
    newMapPoint.speed = @(0);
    newMapPoint.timeElapsed = @(0);
    newMapPoint.index = @0;
    newMapPoint.distance = @0;
    [newRun addPointsObject:newMapPoint];
    [APP_DELEGATE saveContext];
    return newRun;
}

- (void)addMapPointWithLatitude:(double)theLatitude
                      longitude:(double)theLongitude
                          speed:(double)theSpeed
                    timeElapsed:(double)theTimeElapsed {
    double distanceFromLastPoint = 0;
    if (self.lastMapPoint) {
        distanceFromLastPoint = [self.lastMapPoint.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:theLatitude longitude:theLongitude]];
    }
    if (distanceFromLastPoint < 100) {
        // We are adding new point only if distance is less than 100 m
        MapPoint *newMapPoint = [MapPoint createNew];
        newMapPoint.latitude = @(theLatitude);
        newMapPoint.longitude = @(theLongitude);
        newMapPoint.speed = @(theSpeed);
        if (self.lastMapPoint) {
            distanceFromLastPoint = [self.lastMapPoint.location distanceFromLocation:newMapPoint.location];
            newMapPoint.timeElapsed = @(theTimeElapsed - self.lastMapPoint.timeElapsed.floatValue);
            newMapPoint.index = @(self.lastMapPoint.index.intValue + 1);
            newMapPoint.distance = @(self.lastMapPoint.distance.doubleValue + distanceFromLastPoint);
        }
        else {
            newMapPoint.timeElapsed = @(theTimeElapsed);
            newMapPoint.index = @0;
            newMapPoint.distance = @0;
        }
        [self addPointsObject:newMapPoint];
        [APP_DELEGATE saveContext];
    }
}

- (MapPoint *)lastMapPoint {
    if (self.points.count == 0) {
        return nil;
    }
    else {
        return self.points[self.points.count - 1];
    }
}

- (NSNumber *)distance {
    return (self.lastMapPoint) ? self.lastMapPoint.distance : @0;
}

@end
