//
//  Run+CoreDataProperties.h
//  RunningMan
//
//  Created by Valentin Strazdin on 7/26/16.
//  Copyright © 2016 Valentin Strazdin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Run.h"

NS_ASSUME_NONNULL_BEGIN

@interface Run (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSOrderedSet<MapPoint *> *points;

@end

@interface Run (CoreDataGeneratedAccessors)

- (void)insertObject:(MapPoint *)value inPointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPointsAtIndex:(NSUInteger)idx;
- (void)insertPoints:(NSArray<MapPoint *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPointsAtIndex:(NSUInteger)idx withObject:(MapPoint *)value;
- (void)replacePointsAtIndexes:(NSIndexSet *)indexes withPoints:(NSArray<MapPoint *> *)values;
- (void)addPointsObject:(MapPoint *)value;
- (void)removePointsObject:(MapPoint *)value;
- (void)addPoints:(NSOrderedSet<MapPoint *> *)values;
- (void)removePoints:(NSOrderedSet<MapPoint *> *)values;

@end

NS_ASSUME_NONNULL_END
