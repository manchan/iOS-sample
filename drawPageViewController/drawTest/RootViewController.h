//
//  RootViewController.h
//  drawTest
//
//  Created by matsuoka yuichi on 11/11/12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@class GtrRcgnizer;

@interface RootViewController : UIViewController 
<UIPageViewControllerDelegate, UIGestureRecognizerDelegate>
{
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) GtrRcgnizer *gestureRecog;


@end
