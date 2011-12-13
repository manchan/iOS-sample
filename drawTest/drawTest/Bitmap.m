#import "Bitmap.h"

@implementation Bitmap

@synthesize bitmapContext;

- (id)initWithSize:(CGSize)aSize {
    if (self = [super init]) {
		size = aSize;
		CGBitmapInfo bi = kCGImageAlphaNoneSkipFirst|
								kCGBitmapByteOrder32Little;
		CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
		bitmapContext = CGBitmapContextCreate(nil, 
											  size.width, 
											  size.height, 
											  8, 
											  size.width*4, 
											  cs, 
											  bi);
		CGColorSpaceRelease(cs);
    }
    return self;
}

- (void)clearWithColor:(UIColor *)color {
	CGContextSetFillColorWithColor(bitmapContext, 
								   [color CGColor]);
	CGContextFillRect(bitmapContext, 
							CGRectMake(0.f, 
										 0.f, 
										 size.width, 
										 size.height));
}

- (void)drawLineFrom:(CGPoint)from 
				  to:(CGPoint)to 
			  radius:(CGFloat)radius 
			   color:(UIColor *)color {
	
	CGContextSetLineWidth(bitmapContext, radius);
	CGContextSetStrokeColorWithColor(bitmapContext, 
									 [color CGColor]);
	CGContextMoveToPoint(bitmapContext, from.x, from.y);
	CGContextAddLineToPoint(bitmapContext, to.x, to.y);
	CGContextStrokePath(bitmapContext);
}

- (void)drawLineFrom:(CGPoint)from 
				  to:(CGPoint)to 
			   image:(UIImage *)image 
				zoom:(CGFloat)zoom {

	const float step = 2.f;
	int count = ceilf(sqrtf((to.x - from.x) * (to.x - from.x) 
					+ (to.y - from.y) * (to.y - from.y)) / step);
	if (count < 1) count = 1;

	CGImageRef img = [image CGImage];
	CGRect r = CGRectMake(0,
							  0, 
						     image.size.width * zoom, 
						     image.size.height * zoom);
	for (int i = 0; i < count; ++i) {
		CGFloat x = from.x + (to.x - from.x) 
									* ((float)i / (float)count);
		CGFloat y = from.y + (to.y - from.y) 
									* ((float)i / (float)count);
		r.origin.x = x - r.size.width/2.f;
		r.origin.y = y - r.size.height/2.f;
		CGContextDrawImage(bitmapContext, r, img);
	}
}

- (void)drawInRect:(CGRect)rect {
	CGImageRef img = CGBitmapContextCreateImage(bitmapContext);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, img);
	CGImageRelease(img);
}


@end
