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
#import "WFCityViewController.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )
NSString * const WFWeatherEngineDidAddNewCityNotification = @"WFWeatherEngineDidAddNewCityNotification";

@interface WFMainViewController ()

@property (strong, nonatomic) WFCitiesTVController *citiesTVC;
@property (nonatomic, assign) BOOL addCityButtonIsRotate;

@end

@implementation WFMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.citySearchBar.delegate = self;
    self.citiesTVC = [[WFCitiesTVController alloc] init];
    self.citiesTVC.tableView = self.citiesTableView;
    [self.citiesTableView registerNib:[UINib nibWithNibName:@"WFCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CityCell"];
    
    [self showCurrentWeatherData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCurrentWeatherData:) name:@"WFWeatherEngineDidUpdateLocationDataNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCurrentWeatherData
{
    NSArray *currentData = [self dataOfCurreLocation];
    
    WFCurrentLocation *currentLocation = [currentData firstObject];
    WFCurrentWeather *currentWeather = [currentLocation currentWeather];
    
    NSString *capitalized = [[[currentLocation.name substringToIndex:1] uppercaseString] stringByAppendingString:[currentLocation.name substringFromIndex:1]];
    
    self.cityNameLabel.text = capitalized;
//    self.minTempLabel.text = [NSString stringWithFormat:@"%@º", currentWeather.tempMin];
//    self.maxTempLabel.text = [NSString stringWithFormat:@"%@º", currentWeather.tempMax];
     self.currentTempLabel.text = [NSString stringWithFormat:@"%@º", currentWeather.temp];
    
}

- (void)reloadCurrentWeatherData:(NSNotification *)notification
{
    NSLog(@"USER CHANGED LOCATION");
    [self showCurrentWeatherData];
}

- (NSArray*)dataOfCurreLocation
{
    NSError *error = nil;
    
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CurrentLocation" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (IBAction)addCity:(id)sender {
    
    
  
    if (!self.addCityButtonIsRotate) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.citySearchBar.frame = CGRectMake(0, 0, 320, 44);
            self.addCityButtonIsRotate = YES;
            
        } completion:^(BOOL finished) {
           
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
             self.citySearchBar.frame = CGRectMake(0, -44, 320, 44);
        } completion:^(BOOL finished) {
            self.addCityButtonIsRotate = NO;
        }];
        
    }
    

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:NO];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *cityName = searchBar.text;
    
    if (![WFCityViewController cityExistWithName:cityName] && ![cityName isEqualToString:@""]) {
        
        NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate]managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
        
        WFCity *city = [[WFCity alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
        city.name = searchBar.text;
        
        [WFWeatherEngine updateWeatherDataForCity:city];
        
        [self.citySearchBar resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.citySearchBar.frame = CGRectMake(0, -44, 320, 44);
        } completion:^(BOOL finished) {
            self.addCityButtonIsRotate = NO;
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WFWeatherEngineDidAddNewCityNotification object:nil];

    }
    else{
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"La ciudad ya existe" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [errorAlert show];
    }
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [searchBar resignFirstResponder];
        self.citySearchBar.frame = CGRectMake(0, -50, 320, 44);
       
    } completion:^(BOOL finished) {
         self.addCityButtonIsRotate = NO;
    }];
    
}


@end
