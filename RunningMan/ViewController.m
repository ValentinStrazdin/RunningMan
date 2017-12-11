//
//  ViewController.m
//  RunningMan
//
//  Created by Valentin Strazdin on 9/26/14.
//  Copyright (c) 2014 Valentin Strazdin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "NSManagedObject+SVExtensions.h"
#import "MapPoint.h"
#import "Run.h"

@interface ViewController () {
    double _startLatitude;
    double _startLongitude;
}

@property (nonatomic, retain) IBOutlet UILabel *labelTime;
@property (nonatomic, retain) IBOutlet UILabel *labelDistance;
@property (nonatomic, retain) IBOutlet UILabel *labelSpeed;
@property (nonatomic, retain) IBOutlet UIButton *buttonStartStop;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *finishButton;

- (IBAction)startClick;
- (IBAction)cancelClick;
- (IBAction)finishClick;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, retain) NSMutableArray *mapPoints;
@property (nonatomic, retain) Run *currentRun;

@property (nonatomic, retain) NSTimer *runtimeTimer;
@property (nonatomic, retain) NSTimer *distanceTimer;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@property (nonatomic, strong) NSDate *timeStart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerState = TimerStateStop;
    self.mapPoints = [NSMutableArray array];
    self.elapsedTime = 0.0;
    [self updateDistance];
    self.buttonStartStop.enabled = NO;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startClick {
    if (!self.currentRun) {
        self.currentRun = [Run startRunWithLatitude:_startLatitude longitude:_startLongitude];
    }
    if (self.timerState == TimerStateStop) {
        self.timerState = TimerStateStart;
        self.timeStart = [NSDate date];
        [self.buttonStartStop setTitle:@"Stop" forState:UIControlStateNormal];
        self.runtimeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        self.distanceTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self.locationManager selector:@selector(startUpdatingLocation) userInfo:nil repeats:YES];
        self.cancelButton.enabled = NO;
        self.finishButton.enabled = NO;
    }
    else {
        self.elapsedTime -= [self.timeStart timeIntervalSinceNow];
        self.timerState = TimerStateStop;
        [self.buttonStartStop setTitle:@"Start" forState:UIControlStateNormal];
        [self.runtimeTimer invalidate];
        self.runtimeTimer = nil;
        [self.distanceTimer invalidate];
        self.distanceTimer = nil;
        [self.locationManager startUpdatingLocation];
        self.cancelButton.enabled = YES;
    }
}

- (IBAction)cancelClick {
    if (self.currentRun) {
        [APP_DELEGATE.managedObjectContext deleteObject:self.currentRun];
        [APP_DELEGATE saveContext];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTime {
    NSTimeInterval newTime = self.elapsedTime - [self.timeStart timeIntervalSinceNow];
    NSInteger tenthseconds = (NSInteger)(newTime * 10) % 10;
    NSInteger ti = (NSInteger)newTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    if (hours > 0) {
        self.labelTime.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld,%01ld", (long)hours, (long)minutes, (long)seconds, (long)tenthseconds];
    }
    else {
        self.labelTime.text = [NSString stringWithFormat:@"%02ld:%02ld,%01ld", (long)minutes, (long)seconds, (long)tenthseconds];
    }
}

- (void)updateDistance {
    if (self.currentRun && self.currentRun.lastMapPoint) {
        self.labelDistance.text = [NSString stringWithFormat:@"%d meters", self.currentRun.lastMapPoint.distance.intValue];
        NSTimeInterval newTime = self.elapsedTime - [self.timeStart timeIntervalSinceNow];
        if (newTime > 0) {
            double speed = self.currentRun.lastMapPoint.distance.floatValue / newTime;
            if (speed > 0) {
                self.labelSpeed.text = [NSString stringWithFormat:@"%.02f m/s", speed];
            }
        }
    }
    else {
        self.labelDistance.text = [NSString stringWithFormat:@"%d meters", 0];
        self.labelSpeed.text = [NSString stringWithFormat:@"%d m/s", 0];
    }
}

- (void)stopGettingLocation {
    // If we don't stop updating location will be repeatedly lauched many many times
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self stopGettingLocation];
    if (!self.currentRun) {
        _startLatitude = newLocation.coordinate.latitude;
        _startLongitude = newLocation.coordinate.longitude;
        self.buttonStartStop.enabled = YES;
    }
    else {
        [self.currentRun addMapPointWithLatitude:newLocation.coordinate.latitude
                                       longitude:newLocation.coordinate.longitude
                                           speed:newLocation.speed
                                     timeElapsed:self.elapsedTime];
        [self updateDistance];
        if (self.timerState == TimerStateStop) {
            self.finishButton.enabled = YES;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self stopGettingLocation];
    
    NSLog(@"Get Location failed! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
    if (error.code == kCLErrorDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Location Services are disabled for RunningMan app"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusNotDetermined && !self.currentRun) {
        [self.locationManager startUpdatingLocation];
    }
}

@end
