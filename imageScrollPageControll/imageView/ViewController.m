//
//  ViewController.m
//  imageView
//
//  Created by matsuoka yuichi on 11/12/06.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation ViewController

@synthesize mainScrollView, pageControl;
@synthesize jsonGet;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jsonGet.delegate = self;
    
    NSString *searchStr = @"http://search.twitter.com/search.json?q=xcode&rpp=48";
    [self.jsonGet jsonDataGet:searchStr];
}

- (UIImage *) strToIMGBlocks:(NSString (^)(NSString*))imgStr
{
    NSURL *urlStr = [NSURL URLWithString:imgStr];
    NSData *imgData = [NSData dataWithContentsOfURL:urlStr];
    UIImage *displayImg = [[UIImage alloc] initWithData:imgData];
    return displayImg;
}

- (void) initScrollView
{
    int IMGMAX = self.jsonGet.count;
    pageControlBeingUsed = NO;
    
    /*スクロールする画面の数 1画面16枚の画像*/
    int scrollPanelCnt = IMGMAX / 16.0;
    
    self.mainScrollView.contentSize = 
    CGSizeMake(self.mainScrollView.frame.size.width * scrollPanelCnt, 
               (self.mainScrollView.frame.size.height));
    
    UIButton *imgBt[IMGMAX];
    
    int i = 0;
    double left = 0.0;
	double top = 0.0;
	double right = left + self.mainScrollView.contentSize.width;
	double bottom = top + self.mainScrollView.contentSize.height;
    
    /*画像を横から順に4*4ずつならべていく*/
    //height
	for (double y = top; y < bottom; y += 106.0) {
        //width
		for (double x = left; x < right; x += 80.0)
        {
            if (IMGMAX <= i)break;
            imgBt[i] = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBt[i].tag = i + 1;
            imgBt[i].frame = CGRectMake( x, y, 80, 106 );
            imgBt[i].contentMode = UIViewContentModeScaleAspectFit;
            [imgBt[i] setImage:[self strToIMGBlocks:[tweetIconURLs objectAtIndex:i]]
                      forState:UIControlStateNormal];
            
            [imgBt[i] addTarget:self 
                         action:@selector(selectPictOne:)
               forControlEvents:UIControlEventTouchUpInside];
            
            /*画像の枠と角丸*/
            [imgBt[i].layer setBorderWidth:5.0f];
            [imgBt[i].layer setBorderColor:[[UIColor blackColor] CGColor]];
            /*imageView.layer.cornerRadius = 20.0f;*/
            /*ここまで*/
            
            /*画像影つき　ここから*/
            imgBt[i].layer.shadowColor = [UIColor blackColor].CGColor;
            imgBt[i].layer.shadowOpacity = 0.7f;
            imgBt[i].layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
            imgBt[i].layer.shadowRadius = 5.0f;
            imgBt[i].layer.masksToBounds = NO;
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:imgBt[i].bounds];
            imgBt[i].layer.shadowPath = path.CGPath;
            /*ここまで*/
            
            /*ScrollViewに追加*/
            [self.mainScrollView addSubview:imgBt[i]];
            i++;
        }
	}
    
    self.mainScrollView.backgroundColor = RGBA(215, 191, 154, 0.6);
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = scrollPanelCnt;
}

- (void) selectPictOne:(UIButton *)btn
{
    /*ImageViewController *imageVC = 
    [[ImageViewController alloc] initWithNibName:nil bundle:nil];
    imageVC.img = [self strToIMG:[self.xmlDt.imageArray objectAtIndex:btn.tag - 1]];
    [self.navigationController pushViewController:imageVC animated:YES];*/
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.mainScrollView.frame.size.width;
		int page = floor((self.mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.mainScrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.mainScrollView.frame.size;
	[self.mainScrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

-(void)DataDownloadFinished:(NSMutableArray *)data
{
    NSLog(@"JSONDownloadFinish");
    tweetIconURLs = [NSMutableArray array];
    for (NSDictionary *result in self.jsonGet.allResults)
    {
        [tweetIconURLs addObject:[result objectForKey:@"profile_image_url"]];
    }
    
    [self initScrollView];
}

-(void)DataDownloadFailed:(id)data{
    if(!data)
    {
        /*[[AppDelegate getAppDelegate] alert:@"サーバーエラー" 
                                    message:@"データが取得できませんでした"];*/
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mainScrollView = nil;
    self.pageControl = nil;
    self.jsonGet.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
