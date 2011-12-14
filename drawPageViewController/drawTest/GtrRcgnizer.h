//
//  GtrRcgnizer.h
//  drawTest
//
//  Created by matsuoka yuichi on 11/11/18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import <Foundation/Foundation.h>

@interface GtrRcgnizer : UIGestureRecognizer{
    
    //gestureが+の方向に動く時YES
    bool strokeMovingUp;
    //gestureの向きの変更回数を格納する
    int touchChangeDirection;
    //gestureが認識された時に削除されるviewのリファレンスを格納する
    UIView *viewToDelete;
}

@property (strong, nonatomic) UIView *viewToDelete;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
