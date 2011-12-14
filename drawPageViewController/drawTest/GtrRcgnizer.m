//
//  GtrRcgnizer.m
//  drawTest
//
//  Created by matsuoka yuichi on 11/11/18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "GtrRcgnizer.h"

@implementation GtrRcgnizer

@synthesize viewToDelete;

/*gestureがattachされているviewに1本以上の指
 が触れたときに呼び出される.
 それ以外(multiTouch)の場合はStatePropertyを
 UIGestureRecognizerStateFailedに設定して、すぐに認識を失敗させる*/
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if([touches count] != 1){
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}

/*viewに触れた指が動いた時に呼び出される*/
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    /*touchMethodの常としてまずsuperClassに仕事をさせる
     最初にGestureが失敗していないことを確かめ、
     失敗している場合はそのまま制御を返す*/
    [super touchesMoved:touches withEvent:event];
    if(self.state == UIGestureRecognizerStateFailed) return;
    
    /*touchObjectを使って現在の位置と移動前に位置の2つの値を調べる
     2つの位置情報を比較すればgestureの向きに変化があったかどうかを簡単に判断できる
     ■2つの条件
     ・前回までは上向きだったのに逆に下向きになった場合と
     ・下向きだったのに逆に上向きになった場合
     どちらかに当てはまる場合は向きを示すstrokeMoveingUpPropertyの値を変え
     向きの変更回数を格納するtouchChageDirectionをincrementする＋＋*/
    CGPoint nowPoint =
    [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint =
    [[touches anyObject] previousLocationInView:self.view];
    
    if(strokeMovingUp == YES){
        if(nowPoint.y < prevPoint.y){
            strokeMovingUp = NO;
            touchChangeDirection++;
        }
    } else if( nowPoint.y > prevPoint.y){
        strokeMovingUp = YES;
        touchChangeDirection++;
    }
    
    if(viewToDelete == nil){
        UIView *hit = [self.view hitTest:nowPoint withEvent:nil];
        if(hit != nil && hit != self.view){
            self.viewToDelete = hit;
        }
    }
}

/*1本以上の指が画面から離れた時に呼び出される*/
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    /*touchChangedDirectionの値から3度以上の方向の反転があった場合には
     statePropertyをUIGestureRecognizerStateRecognizeに設定して
     Gestureを認識する*/
    
    [super touchesEnded:touches withEvent:event];
    if(self.state == UIGestureRecognizerStatePossible){
        if(touchChangeDirection >= 3)
            self.state = UIGestureRecognizerStateRecognized;
        else self.state = UIGestureRecognizerStateFailed;
    }
    
}

/*systemがeventSequenceのcancelを決めた時に呼び出される
 例：電話の呼び出し*/
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self reset];
    self.state = UIGestureRecognizerStateFailed;
}

@end