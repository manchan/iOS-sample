#import "BitmapView.h"

@implementation BitmapView

@synthesize bitmap;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Bitmapを描画する
	[bitmap drawInRect:rect];
}



@end
