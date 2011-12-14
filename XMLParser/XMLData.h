

#import <Foundation/Foundation.h>

extern NSString * const EXRXMLDownloadCompleteNotification;
extern NSString * const EXRXMLDownloadCompleteNotificationDetail;

@interface XMLData : NSObject
<NSXMLParserDelegate>{
    
    //table index array
    NSMutableArray *dataArray;
    //title要素を格納する配列（複数記事の格納）
    NSMutableArray *titleArray;
    //link要素を格納する配列
    NSMutableArray *linkArray;

    NSMutableArray *imageArray;

    //item要素のチェック
    BOOL itemElementCheck;
    //title要素のチェック
    BOOL titleElementCheck;
    //image要素
    BOOL imageElementCheck;
    //link要素のチェック
    BOOL linkElementCheck;

    //title要素のテキスト（一件一件の記事のタイトル）
    NSString *titleText;

    //link要素のテキスト
    NSString *linkText;

    NSString *imageText;
    
    
    NSSet *tags;
    NSMutableDictionary *currentArticle;
    
    

}

//記事の数とリンクの数をMasterで使うため
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *linkArray;
@property (strong, nonatomic) NSMutableArray *imageArray;

//XMLを読み込み解析するメソッドを宣言  宣言しておかないとMasterで使えない
- (NSMutableArray *) loadXML:(NSString *)urlString;
//Masterにデータ配列を返す
- (void)retArray:(NSArray *)array;

//記事のカウント
- (NSInteger)count;
- (NSMutableDictionary *) articleAtIndex:(NSInteger) index;
- (NSMutableDictionary *) linkAtIndex:(NSInteger) index;
- (NSMutableDictionary *) imageAtIndex:(NSInteger) index;

@end
