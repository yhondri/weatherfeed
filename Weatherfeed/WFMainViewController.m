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
#import "WFSettingsTVController.h"
#import "Reachability.h"

@interface WFMainViewController ()

@property (strong, nonatomic) WFCitiesTVController *citiesTVC;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL addCityButtonIsRotate;
@property (weak, nonatomic) IBOutlet UIView *moreInfoView;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;


@end

@implementation WFMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadCurrentWeatherData)
                                                name:WFWeatherEngineDidUpdateLocationDataNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateTemperatures)
                                                name:WFSettingsTVControllerChangedCelsius
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

- (void)updateTemperatures
{
    [self reloadCurrentWeatherData];
    [self.citiesTableView reloadData];
}

- (void)reloadCurrentWeatherData
{
    NSLog(@"Reloading current weather");
    
    WFCity *currentLocation = [WFWeatherEngine currentLocationCity];
    WFCurrentWeather *currentWeather = [currentLocation currentWeather];
    
    NSString *capitalized = [[[currentLocation.name substringToIndex:1] uppercaseString] stringByAppendingString:[currentLocation.name substringFromIndex:1]];
    
    self.cityNameLabel.text = capitalized;
//    self.minTempLabel.text = [NSString stringWithFormat:@"%@º", currentWeather.tempMin];
//    self.maxTempLabel.text = [NSString stringWithFormat:@"%@º", currentWeather.tempMax];
    
    UIImage *image = [UIImage imageNamed:currentWeather.icon];
    [self.skyImageView setImage:image];
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%.0f%%", [currentWeather.humidity floatValue]];
    self.pressureLabel.text = [NSString stringWithFormat:@"%.1f psi", [currentWeather.pressure floatValue]];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%.0f km/h", [currentWeather.windSpeed floatValue]];
    
    NSLog(@"TEMP OF MAIN %@", [NSString stringWithFormat:@"%.0fº", [currentWeather.temp floatValue]]);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UseCelsius"]) {
        self.currentTempLabel.text = [NSString stringWithFormat:@"%.0fº", [currentWeather.temp floatValue]];
    }
    else {
        self.currentTempLabel.text = [NSString stringWithFormat:@"%.0fº", [self getFarenheit:[currentWeather.temp floatValue]]];

    }
}

- (float)getFarenheit:(float)temp{
    
    temp *= 9;
    temp /= 5;
    
    temp += 32;
    
    return temp;
}

/*!
 *@Description Método que comprueba si hay conexión a internet. Devuelve True or False, si hay o no
 conexión.
 */
- (BOOL)isConnectionAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    return internetStatus != NotReachable;
}

- (IBAction)addCity:(id)sender
{
   
    if ([self isConnectionAvailable]) {
        
        WFSearchCityViewController *vc = [[WFSearchCityViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error de conexión", nil)
                                                        message:NSLocalizedString(@"Comprueba tu red y vuelve a intentarlo", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}




- (IBAction)edit:(id)sender
{
    [self.citiesTableView setEditing:![self.citiesTableView isEditing] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate viewController:self didSelectCityAtIndex:indexPath.row];
}

- (IBAction)goToSettings:(id)sender
{
    WFSettingsTVController *settingsVc = [[WFSettingsTVController alloc] init];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:settingsVc] animated:YES completion:nil];
}

#warning Activar mensaje de error, al no poder conseguir tu localización.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  /*  NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
   */
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Lat %f Long %f", manager.location.coordinate.latitude, manager.location.coordinate.longitude);
    
    [WFWeatherEngine updateWeatherDataForLatitude:manager.location.coordinate.latitude
                                        longitude:manager.location.coordinate.longitude];
    [manager stopUpdatingLocation];
}

- (IBAction)showMoreInfo:(id)sender {
    
    CGFloat infoAlpha = self.moreInfoView.alpha;
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.moreInfoView.alpha = infoAlpha? 0: 1;
                         self.currentTempLabel.alpha = infoAlpha? 1: 0;
                     }
                     completion:nil];
}


@end
