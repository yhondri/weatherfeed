//
//  WFPageViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFMainViewController.h"


@interface WFPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, WFViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
