#import <UIKit/UIKit.h>

@interface Bitmap : NSObject {
	CGContextRef bitmapContext;
	CGSize size;
}

@property (readonly) CGContextRef bitmapContext;

- (id)initWithSize:(CGSize)size;

// from から to まで radius の太さで線を引く
- (void)drawLineFrom:(CGPoint)from 
				  to:(CGPoint)to 
			  radius:(CGFloat)radius 
			   color:(UIColor *)color;


// from から to まで image 画像で線を引く
- (void)drawLineFrom:(CGPoint)from 
				  to:(CGPoint)to 
			   image:(UIImage *)image
				zoom:(CGFloat)zoom;

// bitmap を color でぬりつぶし
- (void)clearWithColor:(UIColor *)color;


// bitmap を描画する
- (void)drawInRect:(CGRect)rect;

@end
