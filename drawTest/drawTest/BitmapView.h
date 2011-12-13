#import <UIKit/UIKit.h>
#import "Bitmap.h"

@interface BitmapView : UIView {
	Bitmap *bitmap;
}

@property (readwrite, retain) Bitmap *bitmap;

@end
