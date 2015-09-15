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
    CGRect portrait;
    CGRect landscape;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //webViewからのdelegate通知をこのクラスで受け取る
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    device = [UIDevice currentDevice];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //縦向きで起動した時
    if (orientation == UIDeviceOrientationPortrait){
        portrait = CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT-44);
        landscape = CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH-44);
        NSLog(@"PORTLAIT");
        webView.frame = portrait;
    //横向きで起動した時
    }else {
        //iOS8以上の場合
        if ([device.systemVersion floatValue] >= 8.0) {
            portrait = CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH-44);
            landscape = CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT-44);
            //iOS7の場合
        }else {
            portrait = CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT-44);
            landscape = CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH-44);
        }
        NSLog(@"LANDSCAPE");
        webView.frame = landscape;
        
    }

    //ローカルに等倍フォントを使用
    [UIFont fontWithName:@"IPAGothic" size:14];
    //表示するURLを取得
//    [self getUrl];
    url = _urlList[_buttonTag];
//    NSLog(@"url = %@",url);
//    url = @"http://oktss.xsrv.jp/shinozaki/index.php";
//    NSString *deviceName = [[UIDevice currentDevice] name];
//    NSString *iPadName = [deviceName uppercaseString];

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

- (void)viewDidLayoutSubviews
{
    if(device.orientation == UIDeviceOrientationPortrait)
    {
        webView.frame = portrait;
    }else {
        webView.frame = landscape;
    }
}
/*
- (void)getUrl {
    //iPadの名前を取得
    NSString *iPadName = [[UIDevice currentDevice] name];
    
    //IDFAの取得 UDIDに変わるiOSが発行するID
    ASIdentifierManager *im = [ASIdentifierManager sharedManager];
    NSString *idfa = @"";
    if (im.advertisingTrackingEnabled) {
        idfa = im.advertisingIdentifier.UUIDString;
    }
    
    NSCalendar *cal	= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //　　カレンダーから時、分、秒を取得する
    unsigned int unitFlags = NSHourCalendarUnit |
    NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //　　ローカルの日時に変換する
    NSDateComponents *components = [cal components:unitFlags
                                          fromDate:[NSDate date]];
    //　　ローカル時刻の「時」を格納
    NSInteger hour = [components hour];
    NSString *userData = [[iPadName stringByAppendingString:@"&MAID="]stringByAppendingString:idfa];
    NSLog(@"userData = %@", userData);
    url = _urlList[_buttonTag];
    
    if([url hasPrefix:@"http://maru8ibm"]){
        if(hour >= 7 || hour <21) {
            url = [url stringByAppendingString:userData];
        }else {
            //サービス時間外メッセージ awsサーバーへアクセス
            url = [@"http://ec2-54-199-199-73.ap-northeast-1.compute.amazonaws.com/maru8.php?VSID=A03&CPID="  stringByAppendingString:userData];
        }
    }
    
    NSLog(@"%@", url);
}
*/

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

//画面の向きの設定
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait
            | UIInterfaceOrientationMaskLandscapeRight
            | UIInterfaceOrientationMaskLandscapeLeft);
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
