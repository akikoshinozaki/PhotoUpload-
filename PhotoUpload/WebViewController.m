//
//  WebViewController.m
//  PhotoUpload
//
//  Created by administrator on 2015/07/03.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
- (IBAction)backButton:(UIBarButtonItem *)sender;
- (IBAction)startCamera:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation WebViewController
{
    //Web View
    IBOutlet UIWebView *webView;
    NSString *url;
    BOOL loadSuccessful;
    UIDevice *device;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //webViewからのdelegate通知をこのクラスで受け取る
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    device = [UIDevice currentDevice];


    //ローカルに等倍フォントを使用
    [UIFont fontWithName:@"IPAGothic" size:14];
    //表示するURLを取得
    url = _urlList[_buttonTag];


    //初期URLのページを要求・表示
    [self makeRequest];
/*
    if([url hasPrefix:@"http://www.yahoo.co.jp"]){
        [_cameraButton setEnabled:YES];
        _cameraButton.tintColor = [UIColor blueColor];
    }else {
        [_cameraButton setEnabled:NO];
        _cameraButton.tintColor = [UIColor colorWithWhite:0 alpha:0];
    }
*/
}


//ページを要求・表示
-(void)makeRequest {
    //Web Viewでウェブページを呼び出す
    NSURLRequest *urlReq =
    [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                 timeoutInterval:60.0];
    [webView loadRequest:urlReq];
    
    //処理が完了するまでloadSuccessfulをfalseに
    loadSuccessful = false;
    
    //Activity Indicator発動
    [UIApplication
     sharedApplication].networkActivityIndicatorVisible = YES;
}

//webロードが正常に完了
- (void)webViewDidFinishLoad:(UIWebView *)view {
    
    //ロードしたページの名前とURLを取得
    url = [[webView.request URL] absoluteString];
    
    // ↓ 20140829 追加 意味があるかは不明
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    //ステータスバーのActivity Indicatorを停止
    [UIApplication
     sharedApplication].networkActivityIndicatorVisible = NO;
    
    //処理が完了したのでloadSuccessfulをtrueに
    loadSuccessful = true;
    
    
}

// Web Viewロード中にエラーが生じた場合
- (void)webView:(UIWebView*)webView
didFailLoadWithError:(NSError*)error {
    //ステータスバーのActivity Indicatorを停止
    [UIApplication
     sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(([[error domain]isEqual:NSURLErrorDomain]) &&
       ([error code]!=NSURLErrorCancelled)) {
        //メッセージを表示
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"エラー";
        alert.message = [NSString stringWithFormat:
                         @"「%@」をロードするのに失敗しました。", url];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(UIBarButtonItem *)sender {
    //前画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)startCamera:(UIBarButtonItem *)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
