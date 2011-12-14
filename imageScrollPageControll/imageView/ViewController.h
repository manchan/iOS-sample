//
//  ViewController.h
//  imageView
//
//  Created by matsuoka yuichi on 11/12/06.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JsonGetter.h"


@interface ViewController : UIViewController
<UIScrollViewDelegate>
{
    int index;
    
    UIScrollView* mainScrollView;
    UIImageView* hairPict;
    UIPageControl* pageControl;
    BOOL pageControlBeingUsed;
    
    JsonGetter *jsonGet;
    NSMutableArray *tweetIconURLs;
}

@property (strong, nonatomic) IBOutlet UIScrollView* mainScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;
@property (strong, nonatomic) IBOutlet JsonGetter* jsonGet;

- (UIImage *) strToIMGBlocks:(NSString (^)(NSString*))imgStr;
- (IBAction)changePage;
- (void)initScrollView;

@end
