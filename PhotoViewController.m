//
//  PhotoViewController.m
//  PhotoUpload
//
//  Created by administrator on 2015/06/23.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()
- (IBAction)sendButton:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;
- (IBAction)selectNo:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviTitle;
@property UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *keiyakuLabel;

@end

@implementation PhotoViewController
{
    NSArray *keiyakuNo;
    NSString *keiyaku;
    UIAlertView *alert1;
    UIAlertView *alert2;
    IBOutlet UIBarButtonItem *postButton;
    NSDictionary *jsonData;
//    NSDictionary *infoDic4;
//    NSArray *titleList;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _myImageView.image = delegate.image;
    _infoDic = delegate.infoDic;
    _buttonTag = delegate.buttonTag;
    NSArray *titleList = [_infoDic objectForKey:@"TITLE"];
    NSLog(@"%@",[_infoDic objectForKey:@"TITLE"]);
    _naviTitle.title = titleList[_buttonTag];
    _gyomuCD = [_infoDic objectForKey:@"BUTTON"];
    
    if (keiyaku == nil){
        [postButton setEnabled:NO];
        [_keiyakuLabel setHidden:YES];

    }else {
            [postButton setEnabled:YES];
        }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//2015.08.21　契約No.のリストを取得する
//契約Noのリストを取得する
-(void)getJson{
    jsonData = [[NSDictionary alloc] init];
    jsonData = [Json getJson:@"C130"];
    //    NSLog(@"%@", _jsonData);
    //jsonDataがnilの場合はアラートを表示
    if(jsonData.count==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VPN 丸ハ接続" message:@"VPN 丸八接続 が「接続中」になっているか確認してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:jsonData forKey:@"jsonDataPhoto"];
        BOOL successful = [defaults synchronize];
        if (successful) {
            NSLog(@"%@", @"データの保存に成功しました。");
        }
    }
}




//契約No.を選択するアクションシートを表示
- (IBAction)selectNo:(id)sender{
    [self getJson];
    NSLog(@"%@",jsonData);
    keiyakuNo = [jsonData objectForKey:@"BUTTON"];
//    keiyakuNo = [[NSArray alloc] init];
//    keiyakuNo = @[@"12345",@"67890",@"ABCDE",@"FGHIJ",@"F01234",@"ABC001"];
    //keiyaku = [[NSString alloc] init];
    
    UIDevice *device = [UIDevice currentDevice];
    //iOS7とiOS8でアクションを分岐
    //(iOS8)
    if ([device.systemVersion floatValue] >= 8.0) {
        UIAlertController *alertController = [[UIAlertController alloc] init];
    alertController = [UIAlertController alertControllerWithTitle:@"契約Noを選択してください"
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    // addAction
    for(int i=0; i<keiyakuNo.count;i++){
    [alertController addAction:[UIAlertAction actionWithTitle:keiyakuNo[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //ボタンが押された時の処理
        [self buttonPushed:i];
    }]];
    }
    
    alertController.popoverPresentationController.barButtonItem = sender;
    
    [self presentViewController:alertController animated:YES completion:nil];
    //(iOS7)
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        actionSheet.delegate = self;
        actionSheet.title = @"契約Noを選択してください";
        for(int i=0; i<keiyakuNo.count;i++){
            [actionSheet addButtonWithTitle:keiyakuNo[i]];
        }
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = (int)keiyakuNo.count;
        [actionSheet showInView:self.view];
 
    }

}

//(iOS8)UIAlertControllerで項目を選択した後のアクション
- (void) buttonPushed:(NSInteger)buttonIndex {
            keiyaku = keiyakuNo[buttonIndex];
            NSLog(@"%@", keiyaku);
            [postButton setEnabled:YES];
            _keiyakuLabel.text = [NSString stringWithFormat:@"%@を送信します",keiyaku];
    [_keiyakuLabel setHidden:NO];
}


//(iOS7)アクションシートが選択された後の処理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex < keiyakuNo.count){
    keiyaku = keiyakuNo[buttonIndex];
    NSLog(@"%@", keiyaku);
    [postButton setEnabled:YES];
        _keiyakuLabel.text = [NSString stringWithFormat:@"%@を送信します",keiyaku];
        [_keiyakuLabel setHidden:NO];

    }
}
/*
- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    // cancelボタンが押された時の処理
    NSLog(@"キャンセルボタン");
    [postButton setEnabled:NO];
}
*/
//(iOS7)アラートが選択された後の処理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1){
        keiyaku = keiyakuNo[buttonIndex];
        NSLog(@"%@", keiyaku);
        [postButton setEnabled:YES];
    }
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



//サーバーへ画像を送信
-(void)postData
{
    // アクティビティインジケータ表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //画面中央にインジケーターを表示
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _indicator.frame = CGRectMake(0, 0, 50, 50);
    _indicator.center = CGPointMake(self.view.WIDTH/2, self.view.HEIGHT/2);
    _indicator.hidesWhenStopped = YES;
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
    
    //UIImageをpngに変換(60%に圧縮)
    float resize = 0.6;
    UIImage* originalImage = _myImageView.image;
    CGSize size = CGSizeMake(originalImage.size.width*resize, originalImage.size.height*resize);
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* pngData = UIImagePNGRepresentation(image);
    
    
    //---ここからPOSTDATAの作成---
    //http://kyuuuuuuuuuuri.hatenablog.com/entry/20130414/1365910741

    NSString *urlString = @"http://oktss.xsrv.jp/shinozaki/file_upload.php";
    NSString *boundary = @"---------------------------168072824752491622650073";
    //リクエストのオブジェクトを作成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    
    // アップロードする際のファイル名
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *iPadName = [deviceName uppercaseString];
    NSString *formatter1 = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *uploadFileName;
    uploadFileName= [NSString stringWithFormat:@"%@%@%@%@",iPadName,_gyomuCD[_buttonTag],keiyaku, formatter1];
    NSLog(@"filename= %@",uploadFileName);
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    // テキスト部分の設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"iPadName"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", iPadName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //画像部分の設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"name=\"%@\";", @"uploadfile"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"filename=\"%@.png\"\r\n", uploadFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:pngData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    //リクエストの送信
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    //サーバーに接続できなかった時にアラートを表示
    if(error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信エラー" message:@"サーバーに接続できませんでした" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [_indicator stopAnimating];
        
    }else{
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",returnString);
        //サーバーから帰ってきた値がOKだった時の処理
        if([returnString  isEqual: @"OK"]){
            NSString *alertMessage = [NSString stringWithFormat:@"%@を送信しました",_naviTitle.title];
            alert2 = [[UIAlertView alloc] init];
            alert2.message = alertMessage;
            alert2.delegate = self;
            alert2.title = @"送信完了";
            [alert2 addButtonWithTitle:@"OK"];
            alert2.tag = 2;
            [alert2 show];

            //サーバーから帰ってきた値がOKじゃなかった時の処理(NG or nil)
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信エラー" message:@"画像を送信できませんでした\nやり直してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [_indicator stopAnimating];
            
            }
    }
    
    
}

//アラートのOKボタンが押された時の処理
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2){
    //アクティビティインジケーターを停止
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //前画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];

    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//送信ボタンが押された時の処理
- (IBAction)sendButton:(UIBarButtonItem *)sender {
    if(keiyaku == nil){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"契約Noが選択されていません" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    }
    [self postData];
}

//キャンセルボタンが押された時の処理
- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    // 前の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
