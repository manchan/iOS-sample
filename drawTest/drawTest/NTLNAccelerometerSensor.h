#import <UIKit/UIKit.h>

@protocol NTLNAccelerometerSensorDelegate 
- (void)accelerometerSensorDetected;

@end

// 加速度センサユーティリティクラス
// NatsuLion for iPhone で使用しているコードをベースにしています

@interface NTLNAccelerometerSensor : NSObject<UIAccelerometerDelegate> {
	NSObject<NTLNAccelerometerSensorDelegate> *delegate;
	UIAccelerationValue accAvg[3];
	CFTimeInterval lastFired;
}

@property (readwrite, retain) NSObject<NTLNAccelerometerSensorDelegate> *delegate;

+ (NTLNAccelerometerSensor*)sharedInstance;

@end
