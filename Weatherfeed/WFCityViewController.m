//
//  WFCityViewController.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFCityViewController.h"
#import "WFAppDelegate.h"
#import "WFWeatherEngine.h"
#import "WFHoursTVController.h"
#import "WFDaysTVController.h"

#import "WFCity.h"
#import "WFCurrentWeather.h"
#import "WFHour.h"
#import "WFDay.h"


@interface WFCityViewController ()

@property(strong,nonatomic) WFCity *city;


@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIView *currentWeatherView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;

@property (weak, nonatomic) IBOutlet UIView *moreInfoView;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;

@property (strong, nonatomic) WFHoursTVController *hourlyTVC;
@property (weak, nonatomic) IBOutlet UITableView *hoursTableView;
@property (strong, nonatomic) WFDaysTVController *dailyTVC;
@property (weak, nonatomic) IBOutlet UITableView *daysTableView;

@end

@implementation WFCityViewController

- (id)initWithCity:(WFCity*)city
{
    if (self = [super init]) {
        
        self.city = city;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadCurrentWeatherData)
                                                name:[NSString stringWithFormat:WFWeatherEngineDidUpdateCityNotification, self.city.idNumber]
                                              object:nil];
    
    self.hourlyTVC = [[WFHoursTVController alloc] initWithCity:self.city];
    self.hourlyTVC.tableView = self.hoursTableView;
    [self.hoursTableView registerNib:[UINib nibWithNibName:@"WFHourCell" bundle:[NSBundle mainBundle]]
              forCellReuseIdentifier:@"HourCell"];
    
    self.dailyTVC = [[WFDaysTVController alloc] initWithCity:self.city];
    self.dailyTVC.tableView = self.daysTableView;
    [self.daysTableView registerNib:[UINib nibWithNibName:@"WFDayCell" bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"DayCell"];
    
    self.hoursTableView.contentInset = UIEdgeInsetsMake(130, 0, 44, 0);
    self.hoursTableView.scrollIndicatorInsets = UIEdgeInsetsMake(130, 0, 44, 0);
    self.daysTableView.contentInset = UIEdgeInsetsMake(130, 0, 44, 0);
    self.daysTableView.scrollIndicatorInsets = UIEdgeInsetsMake(130, 0, 44, 0);
    
    self.hoursTableView.scrollsToTop = YES;
    self.daysTableView.scrollsToTop = NO;
    
    [self reloadCurrentWeatherData];
}


- (void)reloadCurrentWeatherData
{
    NSLog(@"CURRENT WEATHER DATA HAS BEEN UPDATED");
    
    WFCurrentWeather *currentWeather = self.city.currentWeather;
    
    self.currentTempLabel.text = [NSString stringWithFormat:@"%.0fº", [currentWeather.temp floatValue]];
    self.cityNameLabel.text = self.city.name;
    
    self.weatherImageView.image = [UIImage imageNamed:currentWeather.icon];
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%.0f%%", [currentWeather.humidity floatValue]];
    self.pressureLabel.text = [NSString stringWithFormat:@"%.1f psi", [currentWeather.pressure floatValue]];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%.0f km/h", [currentWeather.windSpeed floatValue]];
    
    WFDay *today = [self.dailyTVC.fetchedResultsController.fetchedObjects firstObject];
    self.maxTempLabel.text = [NSString stringWithFormat:@"%.0fº", [today.maxTemp floatValue]];
    self.minTempLabel.text = [NSString stringWithFormat:@"%.0fº", [today.minTemp floatValue]];
}

- (IBAction)periodSegmentControlChanged:(UISegmentedControl*)sender {
    BOOL showHours = sender.selectedSegmentIndex == 0;
    
    self.hoursTableView.scrollsToTop = showHours;
    self.daysTableView.scrollsToTop = !showHours;
    
    if (showHours) {
        [self.hoursTableView setHidden:NO];
    }
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.hoursTableView.alpha = showHours? 1: 0;
                     }
                     completion:^(BOOL finished) {
                         if (!showHours) {
                             [self.hoursTableView setHidden:YES];
                         }
                     }];
}

- (IBAction)showMoreInfo:(id)sender
{
    CGFloat infoAlpha = self.moreInfoView.alpha;
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.moreInfoView.alpha = infoAlpha? 0: 1;
                         self.currentTempLabel.alpha = infoAlpha? 1: 0;
                     }
                     completion:nil];
}

@end
