

#import "XMLData.h"

@implementation XMLData
@synthesize dataArray, linkArray, imageArray;

#define INTERESTING_TAGS_NAMES @"entry", @"title", @"link", nil
NSString * const EXRXMLDownloadCompleteNotification = @"EXRXMLDownloadComplete";
NSString * const EXRXMLDownloadCompleteNotificationDetail = @"EXRXMLDownloadCompleteDetail";

//XMLを読み込み解析する
- (NSMutableArray *) loadXML:(NSString *)urlString
{
    //変数の初期化
    titleArray = [NSMutableArray array];
    linkArray = [NSMutableArray array];
    imageArray = [NSMutableArray array];
    itemElementCheck = NO;
    titleElementCheck = NO;
    linkElementCheck = NO;
    imageElementCheck = NO;
    titleText = @"";
    linkText = @"";
    imageText = @"";
    
    /*記事のURLを格納する配列をクリア
     2度目のlaodXMLメソッドでは値が入っているため
     XMLを解析する前のタイミングで
     配列の中身をクリアする
     */
    
    [linkArray removeAllObjects];
    [imageArray removeAllObjects];
    
    //URLを作成
    NSURL *url = [NSURL URLWithString:urlString];
    //URLからパーサーを作成
    NSXMLParser *parser =
    [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //デリゲートをセット
    [parser setDelegate:self];
    //XMLを解析
    [parser parse];
    //パーサーを解放
//    [parser release];
    
    return titleArray;
}


//開始タグの処理
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict{
    
    //entry要素のチェック
    if([elementName isEqualToString:@"entry"]){
        itemElementCheck = YES;
        currentArticle = 
        [[NSMutableDictionary alloc]initWithCapacity:[tags count]];
    }
    //title要素のチェック
    if (itemElementCheck && [elementName isEqualToString:@"title"])
        titleElementCheck = YES;
    else titleElementCheck = NO;

    //link要素のチェック
    NSString *link = [attributeDict objectForKey:@"href"];
    //Twitter
    if(itemElementCheck && [link hasPrefix:@"http://twitter.com/"]){
        linkElementCheck = YES;
        [currentArticle setValue:link forKey:@"link"];
        linkText = [linkText stringByAppendingString:link];
    }
    else linkElementCheck = NO;

    //image要素のチェック
    if ([elementName isEqualToString:@"link"]) {
        NSString *imageType = [attributeDict objectForKey:@"type"];
        if(itemElementCheck && [imageType isEqualToString:@"image/png"]){
            NSString *imgLink = [attributeDict objectForKey:@"href"];
            imageElementCheck = YES;
            imageText = [imageText stringByAppendingString:imgLink];
        }
    }
    else imageElementCheck = NO;
    


}
   

//テキストの取り出し
- (void)parser:(NSXMLParser *)parser 
foundCharacters:(NSString *)string{
    
    //titleのtextの取り出し
    if(titleElementCheck)
        titleText = [titleText stringByAppendingString:string];
    
    //linkテキストの取り出し
    if(linkElementCheck){
        //youtube.comだけ
//       NSRange range = [string rangeOfString:@"http://www.youtube.com/watch"];
//       if (range.location != NSNotFound) 
            }
//        [currentText appendString:string];
    
    //profile_image_urlテキストの抜き出し
   if(imageElementCheck){
       imageText = [imageText stringByAppendingFormat:string];
   }
 
}


//終了タグの処理
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName;{
    
    if([elementName isEqualToString:@"entry"])
        itemElementCheck = NO;

    //title要素のチェック
    if([elementName isEqualToString:@"title"]){
    if (titleElementCheck) {
        //配列titleArrayに追加
        [titleArray addObject:titleText];
    }

    //titleelementCheckをNO,titleTextを空にセット
    titleElementCheck = NO;        //title要素から出る
    titleText = @"";
    }

    //    if([elementName isEqualToString:@"link"]){
    if (linkElementCheck){
        [linkArray addObject:currentArticle];
    linkElementCheck = NO;
    linkText = @"";
    }
    
    //image要素のチェック
    if (imageElementCheck){
        [imageArray addObject:imageText];
        imageElementCheck = NO;
        imageText = @"";
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"End of the document!!");
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:EXRXMLDownloadCompleteNotification object:self];
    
//    NSNotificationCenter *nsc2th = [NSNotificationCenter defaultCenter];
//    [nsc2th postNotification:EXRXMLDownloadCompleteNotificationDetail object:self];

}


//記事数を返す
- (NSInteger)count{
    return [dataArray count];
}

//記事数をindexをつけて返す
- (NSMutableDictionary *) articleAtIndex:(NSInteger) index
{
    return [dataArray objectAtIndex:index];
}

//リンク数をindexをつけて返す
- (NSMutableDictionary *) linkAtIndex:(NSInteger) index{
    return [linkArray objectAtIndex:index];
}

//TwitterImage数をindexをつけて返す
- (NSMutableDictionary *) imageAtIndex:(NSInteger) index{
    return [imageArray objectAtIndex:index];
}


//MasterでとってきたArrayをdataArrayにセットし、返す
- (void)retArray:(NSArray *)array{
    return [dataArray setArray:array];
}


- (void) awakeFromNib{
    //データの初期値をセット
    dataArray = [[NSMutableArray alloc] init];
    //記事のURLを格納する配列の初期値をセット
    linkArray = [[NSMutableArray alloc] init];
    
    imageArray = [[NSMutableArray alloc] init];

    tags = [[NSSet alloc]initWithObjects:INTERESTING_TAGS_NAMES];
}


@end
