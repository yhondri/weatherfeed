//
//  WFViewController.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 05/05/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFViewController;

@protocol WFViewControllerDelegate <NSObject>
- (void)viewController:(WFViewController*)viewController didSelectCityAtIndex:(NSInteger)index;
@end

@interface WFViewController : UIViewController

@property (nonatomic) NSUInteger pageIndex;

@property (weak, nonatomic) id<WFViewControllerDelegate> delegate;

@end
