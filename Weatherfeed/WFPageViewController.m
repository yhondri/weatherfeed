//
//  WFPageViewController.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFPageViewController.h"
#import "WFMainViewController.h"
#import "WFCityViewController.h"
#import "WFAppDelegate.h"
#import "WFCity.h"
#import "WFWeatherEngine.h"
#import "WFCurrentLocation.h"

@interface WFPageViewController () 
@property (strong, nonatomic) NSArray *citiesArray;
@property (assign) BOOL locationFromUser;
@end


@implementation WFPageViewController

CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc] init];
    
    [self currentLocation];
    [WFWeatherEngine checkDataOfCities];
    
    self.citiesArray = [self dataOfCities];
  /*
    if ([self.citiesArray count] == 0) {
        NSLog(@"NO HAY CITIES %i", [self.citiesArray count]);
        self.locationFromUser = true;
        [self currentLocation];
    }
    */
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    NSArray *viewControllers = [NSArray arrayWithObject: [self viewControllerAtIndex:0]];

    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewCityToPageViewController:) name:@"WFWeatherEngineDidAddNewCityNotification" object:nil];
    
}

- (void)currentLocation
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
#warning quitado
//    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    static NSString *locationName;
    
    NSLog(@"Lat %f Long %f", manager.location.coordinate.latitude, manager.location.coordinate.longitude);
    
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            
            locationName = [NSString stringWithFormat:@"%@", placemark.locality];
            
            NSLog(@"ADDRESS %@", locationName);
        } else {
            
            NSLog(@"%@", error.debugDescription);
            
        }
        
        if (![locationName isEqualToString:@""]) {
            
            NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate]managedObjectContext];
            
            
            NSLog(@"Localización por sistema %@", locationName);
            NSArray *dataOfCurrentLocation = [self existDataOfCurrentLocation];
            WFCurrentLocation *currentLocation;
            
            if ([dataOfCurrentLocation count] > 0) {
                currentLocation = [dataOfCurrentLocation firstObject];
                
            }
            else{
                
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"CurrentLocation" inManagedObjectContext:context];
                
                currentLocation = [[WFCurrentLocation alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
                
            }
            
            currentLocation.name = [locationName lowercaseString];;
            
            [WFWeatherEngine updateWeatherDataForCurrentLocation:currentLocation];
            
            if (self.locationFromUser) {
                
                if (![WFCityViewController cityExistWithName:locationName]) {
                    
                    NSLog(@"A insertar ciudad por usuario");
                    
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
                    
                    WFCity *city = [[WFCity alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
                    city.name =  [locationName lowercaseString];
                    city.addedDate = [NSDate date];
                    
                    [WFWeatherEngine updateWeatherDataForCity:city];
                    
                    self.locationFromUser = false;
                    
                }
                
            }
        }
        
    } ];

 
    
    [locationManager stopUpdatingLocation];
   
}


- (void)addNewCityToPageViewController:(NSNotification *)notification
{
    
    [self.pageController setViewControllers:[NSArray arrayWithObject:
                                             [self viewControllerAtIndex:[self.citiesArray count]+1]
                                             ]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}

- (NSArray*)dataOfCities
{
    NSError *error;
    
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"City" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (NSArray*)existDataOfCurrentLocation
{
    NSError *error;
    
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CurrentLocation" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (UIViewController*)viewControllerAtIndex:(NSUInteger)index {

    if (index == 0) {
        
        WFMainViewController *initialViewController = [[WFMainViewController alloc]init];
        initialViewController.pageIndex = 0;
        return initialViewController;
    }
    
    else{
        

        WFCityViewController *cityViewController;
        
        if ([self.citiesArray count] == 0) {
            self.citiesArray = [self dataOfCities];
        }
        
        WFCity *city = self.citiesArray[index-1];
        
        
        cityViewController= [[WFCityViewController alloc] initWithCity:city];
        
        cityViewController.pageIndex = index;
        
        return cityViewController;
    }
    
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index;
    
    if ([viewController isKindOfClass:[WFMainViewController class]]) {
        if ([self.citiesArray count] == 0) {
            return nil;
        }
        index = 0;
    }
    
    else{
        
        index = ((WFCityViewController*) viewController).pageIndex;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    
    if (index == 0) {
        index = [self.citiesArray count];
    }
   
    else{
        index--;
    }
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index;
    
    if ([viewController isKindOfClass:[WFMainViewController class]]) {
        if ([self.citiesArray count] == 0) {
            return nil;
        }
        index = 0;
    }

    else{
        
        index = ((WFCityViewController*) viewController).pageIndex;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    if (index >= [self.citiesArray count]) {
        return [self viewControllerAtIndex:0];
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
