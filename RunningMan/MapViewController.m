//
//  MapViewController.m
//  RunningMan
//
//  Created by Valentin Strazdin on 3/2/17.
//  Copyright © 2017 Valentin Strazdin. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic,strong) IBOutlet MKMapView *map;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set title
    float distanceKilometers = (float)(self.run.distance.doubleValue / 1000);
    self.navigationItem.title = [NSString stringWithFormat:@"%.02f км", distanceKilometers];
    
    [self drawRoute];
}

- (void) drawRoute {
    NSInteger numberOfSteps = self.run.points.count;
    CLLocationDegrees minLatitude = [self.run.points[0].latitude doubleValue];
    CLLocationDegrees maxLatitude = [self.run.points[0].latitude doubleValue];
    CLLocationDegrees minLongitude = [self.run.points[0].longitude doubleValue];
    CLLocationDegrees maxLongitude = [self.run.points[0].longitude doubleValue];
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        MapPoint *point = self.run.points[index];
        CLLocationDegrees latitude = [point.latitude doubleValue];
        CLLocationDegrees longitude = [point.longitude doubleValue];
        if (latitude < minLatitude) {
            minLatitude = latitude;
        }
        if (latitude > maxLatitude) {
            maxLatitude = latitude;
        }
        if (longitude < minLongitude) {
            minLongitude = longitude;
        }
        if (longitude > maxLongitude) {
            maxLongitude = longitude;
        }
        coordinates[index] = CLLocationCoordinate2DMake(latitude, longitude);
//        NSLog(@"Coord - %f, %f", latitude, longitude);
//        NSLog(@"speed - %f", point.speed.doubleValue);
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [self.map addOverlay:polyLine];
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake((minLatitude + maxLatitude) / 2, (minLongitude + maxLongitude) / 2);
    region.span = MKCoordinateSpanMake((maxLatitude - minLatitude) * 1.05, (maxLongitude - minLongitude) * 1.05);
    self.map.region = region;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.0;
    return renderer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
