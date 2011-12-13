//
//  DataViewController.h
//  drawTest
//
//  Created by matsuoka yuichi on 11/11/12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface DataViewController : UIViewController
<NSCoding, MFMailComposeViewControllerDelegate,
UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
    CGPoint lastPoint;
	UIImageView *drawImage;
	BOOL mouseSwiped;	
	int mouseMoved;
    
    UIButton *trashBt;
    UIButton *cameraBt;
    UIButton *mailTo;
    //保存するpageNumber
    NSInteger savedPageIndex;
    
    UIImagePickerController *imgPicker;
}
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;

@property (retain) UIImagePickerController *imgPicker;



//- (CGFloat *) setColor;
//+(UIColor *)colorFromRGBIntegers:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
//+(CGColorRef)createRGBValue:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (IBAction)setNull:(id)sender;
- (IBAction)cameraSave:(id)sender;
- (IBAction) mail_sending:(id)sender;
- (void) cameraActionETC;
- (void)addPictureTapped;

@end
