//
//  WFPageViewController.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFPageViewController.h"
#import "WFCityViewController.h"
#import "WFAppDelegate.h"
#import "WFCity.h"
#import "WFWeatherEngine.h"
#import "WFCurrentLocation.h"

@interface WFPageViewController ()

@property (strong, nonatomic) NSArray *cities;
@property (assign) BOOL locationFromUser;

@end


@implementation WFPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WFWeatherEngine currentLocationCity];
    [WFWeatherEngine checkDataOfCities];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    
    [self reloadPageController];
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPageController) name:@"WFWeatherEngineDidAddNewCityNotification" object:nil];
    
}

- (void)reloadCities
{
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"City"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"addedDate != nil"]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    self.cities = fetchedObjects;
}

- (void)reloadPageController
{
    [self reloadCities];
    
    [self.pageController setViewControllers:@[[self viewControllerAtIndex:0]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}

- (void)mainViewController:(WFMainViewController *)mainViewController
      didSelectCityAtIndex:(NSInteger)index
{
    [self.pageController setViewControllers:@[[self viewControllerAtIndex:index+1]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
}

#pragma mark - Page View Controller Data Source

- (UIViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if (index == 0) {
        WFMainViewController *mainViewController = [[WFMainViewController alloc] init];
        mainViewController.delegate = self;
        
        return mainViewController;
    }
    else {
        WFCity *city = self.cities[index-1];
        
        WFCityViewController *cityViewController = [[WFCityViewController alloc] initWithCity:city];
//        [cityViewController setCity:city];
        
        cityViewController.pageIndex = index;
        
        return cityViewController;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([self.cities count] == 0) {
        return nil;
    }
    
    NSUInteger index;
    
    if ([viewController isKindOfClass:[WFMainViewController class]]) {
        index = 0;
    }
    else {
        index = ((WFCityViewController*) viewController).pageIndex;
    }
    
    if (index == 0) {
        index = [self.cities count];
    }
    else {
        index--;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([self.cities count] == 0) {
        return nil;
    }
    
    NSUInteger index;
    
    if ([viewController isKindOfClass:[WFMainViewController class]]) {
        index = 0;
    }
    else {
        index = ((WFCityViewController*) viewController).pageIndex;
    }
    
    if (index == [self.cities count]) {
        index = 0;
    }
    else {
        index++;
    }
    
    return [self viewControllerAtIndex:index];
}


@end
