//
//  WFPageViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"


@interface WFPageViewController : UIViewController <UIPageViewControllerDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
