//
//  WFMainViewController.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 15/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFMainViewController.h"
#import "WFWeatherEngine.h"
#import "WFAppDelegate.h"
#import "WFCity.h"
#import "WFCurrentLocation.h"
#import "WFCurrentWeather.h"
#import "WFCitiesTVController.h"
#import "WFSearchCityViewController.h"


@interface WFMainViewController ()

@property (strong, nonatomic) WFCitiesTVController *citiesTVC;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL addCityButtonIsRotate;

@end

@implementation WFMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadCurrentWeatherData)
                                                name:WFWeatherEngineDidUpdateLocationDataNotification
                                              object:nil];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    [self.locationManager startUpdatingLocation];
    
    
    self.citiesTVC = [[WFCitiesTVController alloc] init];
    self.citiesTVC.tableView = self.citiesTableView;
    self.citiesTableView.delegate = self;
    [self.citiesTableView registerNib:[UINib nibWithNibName:@"WFCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CityCell"];
    
    self.citiesTableView.contentInset = UIEdgeInsetsMake(130, 0, 44, 0);
    self.citiesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(130, 0, 44, 0);
    
    [self reloadCurrentWeatherData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.citiesTableView.scrollsToTop = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.citiesTableView.scrollsToTop = NO;
}


- (void)reloadCurrentWeatherData
{
    WFCity *currentLocation = [WFWeatherEngine currentLocationCity];
    WFCurrentWeather *currentWeather = [currentLocation currentWeather];
    
    NSString *capitalized = [[[currentLocation.name substringToIndex:1] uppercaseString] stringByAppendingString:[currentLocation.name substringFromIndex:1]];
    
    self.cityNameLabel.text = capitalized;
//    self.minTempLabel.text = [NSString stringWithFormat:@"%@º", currentWeather.tempMin];
//    self.maxTempLabel.text = [NSString stringWithFormat:@"%@º", currentWeather.tempMax];
     self.currentTempLabel.text = [NSString stringWithFormat:@"%.0fº", [currentWeather.temp floatValue]];
    
    UIImage *image = [UIImage imageNamed:currentWeather.icon];
    [self.skyImageView setImage:image];

}


- (IBAction)addCity:(id)sender
{
    WFSearchCityViewController *vc = [[WFSearchCityViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)edit:(id)sender
{
    [self.citiesTableView setEditing:![self.citiesTableView isEditing] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate mainViewController:self didSelectCityAtIndex:indexPath.row];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Lat %f Long %f", manager.location.coordinate.latitude, manager.location.coordinate.longitude);
    
    [WFWeatherEngine updateWeatherDataForLatitude:manager.location.coordinate.latitude
                                        longitude:manager.location.coordinate.longitude];
    [manager stopUpdatingLocation];
}

@end
