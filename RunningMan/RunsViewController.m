//
//  RunsViewController.m
//  RunningMan
//
//  Created by Valentin Strazdin on 7/26/16.
//  Copyright © 2016 Valentin Strazdin. All rights reserved.
//

#import "RunsViewController.h"
#import "Run.h"
#import "MapViewController.h"

@interface RunsViewController ()

@property (nonatomic, retain) NSArray *myRuns;

@end

@implementation RunsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myRuns = [Run allRuns];
    // Do any additional setup after loading the view.
    self.title = @"Пробежки";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRun)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.myRuns = [Run allRuns];
    [self.tableView reloadData];
}

- (void)addRun {
    [self performSegueWithIdentifier:@"segueAddRun" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myRuns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customRunCell" forIndexPath:indexPath];
    Run *theRun = self.myRuns[indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM HH:mm"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU_POSIX"];
    cell.textLabel.text = [dateFormatter stringFromDate:theRun.date];
    float distanceKilometers = (float)(theRun.distance.doubleValue / 1000);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f км", distanceKilometers];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueViewRun"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MapViewController *destViewController = [((UINavigationController*)segue.destinationViewController) viewControllers][0];
        destViewController.run = self.myRuns[indexPath.row];
    }
}


@end
