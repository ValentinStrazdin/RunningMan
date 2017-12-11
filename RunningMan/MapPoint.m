//
//  MapPoint.m
//  RunningMan
//
//  Created by Valentin Strazdin on 9/26/14.
//  Copyright (c) 2014 Valentin Strazdin. All rights reserved.
//

#import "MapPoint.h"
#import "NSManagedObject+SVExtensions.h"
#import "AppDelegate.h"
#include <math.h>
#include <stdio.h>

@implementation MapPoint

@dynamic latitude;
@dynamic longitude;
@dynamic timeElapsed;
@dynamic distance;
@dynamic index;
@dynamic speed;

@dynamic location;

+ (NSArray *)mapPoints {
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    return [self cachedObjectsWithPredicate:nil sortDescriptors:@[sortDescriptor]];
}

+ (void)addMapPointWithLatitude:(double)theLatitude
                      longitude:(double)theLongitude
                          speed:(double)theSpeed
                    timeElapsed:(double)theTimeElapsed {
    MapPoint *lastMapPoint = [MapPoint lastMapPoint];
    MapPoint *newMapPoint = [[self class] createNew];
    newMapPoint.latitude = @(theLatitude);
    newMapPoint.longitude = @(theLongitude);
    newMapPoint.speed = @(theSpeed);
    if (lastMapPoint) {
        newMapPoint.timeElapsed = @(theTimeElapsed - lastMapPoint.timeElapsed.floatValue);
        newMapPoint.index = @(lastMapPoint.index.intValue + 1);
        newMapPoint.distance = @(lastMapPoint.distance.doubleValue + [lastMapPoint.location distanceFromLocation:newMapPoint.location]);
    }
    else {
        newMapPoint.timeElapsed = @(theTimeElapsed);
        newMapPoint.index = @0;
        newMapPoint.distance = @0;
    }
    [APP_DELEGATE saveContext];
}

+ (MapPoint *)lastMapPoint {
    NSArray *points = [MapPoint mapPoints];
    if (points.count > 0) {
        return (MapPoint *)points[points.count - 1];
    }
    else {
        return nil;
    }
}

+ (NSNumber *)nextIndex {
    NSArray *points = [MapPoint mapPoints];
    if (points.count > 0) {
        MapPoint *mapPoint = (MapPoint *)points[points.count - 1];
        return @(mapPoint.index.intValue + 1);
    }
    else {
        return @0;
    }
}

//- (int)distanceFromPointLatitude:(double)newPointLatitude
//                          longitude:(double)newPointLongitude {
//    double latA = (self.latitude.doubleValue / 180) * M_PI;
//    double latB = (newPointLatitude / 180) * M_PI;
//    double longA = (self.longitude.doubleValue / 180) * M_PI;
//    double longB = (newPointLongitude / 180) * M_PI;
//    double deltaLatitude = (latA - latB) / 2;
//    double deltaLongitude = (longA - longB) / 2;
//    double earthRadius = 6370000;
//    double deltaSigma = 2 * asin(sqrt(pow(sin(deltaLatitude), 2) + cos(latA) * cos(latB) * pow(sin(deltaLongitude), 2)));
//    return (int)(earthRadius * deltaSigma);
//}

- (CLLocation*)location {
    return [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
}

@end
