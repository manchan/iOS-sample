//
//  JsonGetter.m
//  imageView
//
//  Created by matsuoka yuichi on 11/12/14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JsonGetter.h"

@implementation JsonGetter

@synthesize delegate;
@synthesize statusCode;
@synthesize tweetArray, iconArray;
@synthesize data_;
@synthesize allResults;


// Jsonデータ取得
- (NSMutableArray *)jsonDataGet:(NSString *)input{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    tweetArray = [[NSMutableArray alloc] init];
    iconArray = [[NSMutableArray alloc] init];
    allResults = [[NSMutableArray alloc] init];
    data_ = [[NSMutableData alloc] init];
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",input];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
   
    return tweetArray;
}


// GETで帰ってきた値の先頭４文字を確認する
-(id) jsonHeadChecker:(NSString *)json_string{
    if ([json_string isEqualToString:@""]) {
        NSLog(@"返り値無し");
        return nil;
    }
    if ([[json_string substringToIndex:4] isEqualToString:@"<htm"]) {
        NSLog(@"先頭がHTML");
        return nil;
    }
    if ([[json_string substringToIndex:4] isEqualToString:@"<?xm"]) {
        NSLog(@"先頭がXML");
        return nil;
    }
    return json_string;
}

// サーバからレスポンスが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"didReceiveResponse");
    NSLog(@"ステータスコート判別----------");
	NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
	statusCode = [res statusCode];
}

// サーバからデータが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData");
    //分割されたデータを統合
    [data_ appendData:data];
}

/// データのロードか完了した時のデリゲート
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
    if (statusCode == 200) {
        NSLog(@"Code200 : 通常処理");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        // 通常処理
    } else {
        NSLog(@"Code%d : エラー処理",statusCode);
        [connection cancel];
        [delegate DataDownloadFailed:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        // エラー処理
    }
    
    // Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:data_ encoding:NSUTF8StringEncoding];
    NSString *checker = [self jsonHeadChecker:jsonString];
    
    if (!checker) {
        NSLog(@"JSONが返ってきていません");
        [delegate DataDownloadFailed:nil];
        [connection cancel];
    }
    
    // Create a dictionary from the JSON string
    /*iOS5以降*/
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data_ options:nil error:nil];
    
	allResults = [dic objectForKey:@"results"];
    
    // Build an array from the dictionary for easy access to each entry
    for (NSDictionary *result in allResults){
        
        // Get tweet
        NSString *title = [result objectForKey:@"text"];
        // Save the tweet to the tweets titles array
        [tweetArray addObject:(title.length > 0 ? title : @"Untitled")];
        
        // Get IconImage
        NSString *photoURLString = [result objectForKey:@"profile_image_url"];
        [iconArray addObject:photoURLString ];
    }
    [delegate DataDownloadFinished:tweetArray];
}


/*サーバからエラーが返されたときのデリゲート*/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    [delegate DataDownloadFailed:nil];
}

// 記事数を返す
- (NSInteger)count{
    return [tweetArray count];
}

@end