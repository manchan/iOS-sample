//
//  DataViewController.m
//  drawTest
//
//  Created by matsuoka yuichi on 11/11/12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

/*ここからUIViewの中身をdumpする*/
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#endif

#import "RootViewController.h"

void dumpSubviews(UIView* view){
    NSLog(@"%s", class_getName([view class]));
    for (UIView *subView in [view subviews]) {
        dumpSubviews( subView );
    }
}
/*ここまで*/


#import "DataViewController.h"
#import "ModelController.h"

@implementation DataViewController

@synthesize dataLabel = _dataLabel;
@synthesize dataObject = _dataObject;
@synthesize imgPicker;


int globalCNT = 0;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)createBackup {
    NSData *imageData = UIImagePNGRepresentation(drawImage.image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"drawImage"];
}

- (UIImage *)restoreImage {
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"drawImage"];
    drawImage.image = [UIImage imageWithData:imageData];
    
    return drawImage.image;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    drawImage = [[UIImageView alloc] init];
	drawImage.frame = CGRectMake(0.0, 0.0, 320, 430);
    [self.view addSubview:drawImage];
    self.view.backgroundColor = [UIColor lightGrayColor];

	mouseMoved = 0;
    
    /* UIDeviceクラスのインスタンスを取得する
    UIDevice *dev = [UIDevice currentDevice];
    NSString *devID = dev.uniqueIdentifier;
    NSString *OS = dev.systemName;
    NSString *OSNum = dev.systemVersion;
    NSString *desc = dev.description;
    NSString *devNA = dev.name;
    NSLog(@"device ID:%@,\n OS:%@\n OS ver:%@\n description:%@, name:%@", devID, OS, OSNum, desc, devNA);
     */

}


- (IBAction)setNull:(id)sender{
    
    /*Use the select type on an animation. 
     suckEffect, spewEffect, genieEffect, unGenieEffect, twist, tubey, swirl, 
     cameraIris, cameraIrisHollowClose, cameraIrisHollowOpen, rippleEffect, 
     charminUltra, zoomyIn, and zoomyOut.*/
    
    CATransition *animation = [CATransition animation];
    animation.type = @"rippleEffect";
    animation.duration = 0.5f;
    
    drawImage.image = nil;
    //アニメーションを登録
    [self.view.layer addAnimation:animation forKey:@"transitionViewAnimation"];
	[self.view addSubview:drawImage];
    
}

- (IBAction)cameraSave:(id)sender{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
    NSLog(@"%@\n", [[touch gestureRecognizers] description]);
	lastPoint = [touch locationInView:self.view];
	lastPoint.y -= 20;
    
    /*タッチしたViewの中身をdumpする*/
    dumpSubviews(self.view);
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.view];
	currentPoint.y -= 20;
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
    
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


#pragma mark UIActionSheetDelegate Protocol
- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex 
{    
    UIImagePickerControllerSourceType sourceType = 0;
	switch (buttonIndex)
	{
		case 0:
		{
			UIImageWriteToSavedPhotosAlbum(drawImage.image, nil, nil, nil);
			break;
		}
		case 1:
		{
            [self addPictureTapped];
			break;
		}
		case 2:
		{
            sourceType = UIImagePickerControllerSourceTypeCamera;
//			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
//			self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			break;
		}
	}
}

- (IBAction) cameraActionETC:(id)sender{
    // ナビゲーションバーのSheetボタンが押されたときにアクションシートを表示する
    UIActionSheet *aActionSheet = 
    [[UIActionSheet alloc] initWithTitle:@""
                                delegate:self 
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"CameraSave", @"Select Pics", @"BlackTranslucent", nil];

    [aActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    // TabBarを隠すようにアクションシートを表示する
    [aActionSheet showInView:self.view];
    // TabBarのすぐ上にアクションシートを表示する
    //  [aActionSheet showInView:self.parentViewController.view];
}

- (IBAction) mail_sending:(id)sender
{    
    NSMutableString* emailBody = [[NSMutableString alloc] initWithString:@""];
    [emailBody appendString:@"\n\n\n\n\n\n\n\n\n\n---"];  
    [emailBody appendString:@"\n送る内容\n"];
    // mail送信
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //画像を圧縮して
    CGFloat compressionQuality = 0.7;
    NSData *attachData = UIImageJPEGRepresentation(drawImage.image, compressionQuality);
    //本文にアタッチ
    [picker addAttachmentData:attachData
                     mimeType:@"image/jpeg"
                     fileName:@"draw"];	
    
    // 本文
    [picker setMessageBody:emailBody isHTML:NO];
    // 題
    [picker setSubject:@""];
    
    /*
     // 送り先 必要なら
     [picker setToRecipients:[NSArray arrayWithObject:toAddress]]; 
     */ 
    
    [self presentModalViewController:picker animated:YES];
    
} 

- (void) mailComposeController:(MFMailComposeViewController*)controller 
           didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{    
    switch (result) 
    {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultSent:
        case MFMailComposeResultFailed:
        default: [self dismissModalViewControllerAnimated:YES];
    }
} 

#pragma mark UIImagePickerControllerDelegate Protocol
- (void)addPictureTapped 
{
            imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.delegate = self;
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPicker.allowsEditing = NO;
            [self presentModalViewController:imgPicker animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {    
    
    [self dismissModalViewControllerAnimated:YES];
    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage]; 
    drawImage.image = fullImage;
}


@end
