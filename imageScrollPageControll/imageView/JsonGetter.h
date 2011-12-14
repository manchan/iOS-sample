//
//  JsonGetter.h
//  imageView
//
//  Created by matsuoka yuichi on 11/12/14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonGetterDelegate <NSObject>
- (void)DataDownloadFinished:(NSMutableArray *)data;
- (void)DataDownloadFailed:(id)data;
@end

@interface JsonGetter : NSObject
{
    id delegate;
    NSInteger statusCode;
    NSMutableArray *tweetArray;
    NSMutableArray *iconArray;
    NSMutableData *data_;
    NSMutableArray *allResults;
}

@property(nonatomic,retain) id delegate;
@property(nonatomic,assign)NSInteger statusCode;
@property(nonatomic,retain)NSMutableArray *tweetArray;
@property(nonatomic,retain)NSMutableArray *iconArray;
@property(nonatomic, retain)NSMutableArray *allResults;
@property(nonatomic,retain)NSMutableData *data_;

- (NSInteger)count;
- (NSMutableArray *)jsonDataGet:(NSString *)input;
@end
