//
//  PhotoViewController.m
//  PhotoUpload
//
//  Created by administrator on 2015/06/23.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import "PhotoViewController.h"
#import <AudioToolBox/AudioToolBox.h>

@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *naviTitle;
@property UIActivityIndicatorView *indicator;
//@property (weak, nonatomic) IBOutlet UILabel *tagNoLabel;
@property (weak, nonatomic) UITextField *textInAlert;
@property (strong, nonatomic) AVCaptureSession* session;
- (IBAction)barcodeCancel:(UIBarButtonItem *)sender;

@end

@implementation PhotoViewController
{
    NSString *tagNo;
    UIAlertView *alert2;
//    NSDictionary *jsonData;
//    UIBarButtonItem *postButtonItem;
    UIBarButtonItem *cancelButtonItem;
    UIBarButtonItem *tagNoButtonItem;
    AVCaptureVideoPreviewLayer *preview;
    IBOutlet UIView *aView;
    IBOutlet UIBarButtonItem *barcodeCancel;
    UIDevice *device;
    NSDictionary *IBMData;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setToolbarHidden:NO];
    [aView setHidden:YES];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton)];
    tagNoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"タッグNo.入力" style:UIBarButtonItemStylePlain target:self action:@selector(selectNo:)];
//    postButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"送信" style:UIBarButtonItemStylePlain target:self action:@selector(sendButton)];
    
    [self setToolbarItems:[NSArray arrayWithObjects:cancelButtonItem, flexSpace, tagNoButtonItem, flexSpace, nil] animated:YES];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _myImageView.image = delegate.image;
    _infoDic = delegate.infoDic;
    _buttonTag = delegate.buttonTag;
    _naviTitle.title = @"サーバーへ画像を送信";
/*
    if (tagNo == nil){
        [postButtonItem setEnabled:NO];
        [_tagNoLabel setHidden:YES];

    }else {
            [postButtonItem setEnabled:YES];
        }
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//タッグNo.を選択するアクションシートを表示
- (void)selectNo:(id)sender{
    device = [UIDevice currentDevice];
    //(iOS8)
    if ([device.systemVersion floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"タッグNoを入力してください"
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleAlert];
    // addAction
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action){
                                                                  [self inputTagNo:tagNo];
                                                              }];
        [alertController addAction:defaultAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"キャンセル"
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction *action){
                                                                [alertController dismissViewControllerAnimated:YES
                                                                                              completion:nil];
                                                            }];
        [alertController addAction:cancelAction];

        UIAlertAction *altAction = [UIAlertAction actionWithTitle:@"バーコードスキャン"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action){
                                                              [self barcodeReader];
                                                              [alertController dismissViewControllerAnimated:YES
                                                                                                  completion:nil];
                                                          }];
        [alertController addAction:altAction];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            _textInAlert = textField;
            _textInAlert.placeholder = @"タッグNo.入力";
            _textInAlert.delegate = self;
            _textInAlert.returnKeyType = UIKeyboardTypeNumberPad;
        }];
    
    alertController.popoverPresentationController.barButtonItem = sender;
    
    [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    tagNo = _textInAlert.text;
}


//バーコードリーダー起動
- (void)barcodeReader {
    [aView setHidden:NO];

    // Device
    AVCaptureDevice *avDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // session
    self.session = [[AVCaptureSession alloc] init];
    
    // Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:avDevice error:nil];
    if (input) {
        [self.session addInput:input];
    } else {
        NSLog(@"error");
    }
    
    // Output
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:output];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code]];
    
    // Preview
    preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = CGRectMake(0, 44,350,200);
/*
    //デバイスの向きが横向きだったら、VideoPreviewの向きも回転
    device = [UIDevice currentDevice];
    if(UIDeviceOrientationIsLandscape(device.orientation)){
*/
    [[preview connection]setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
//    }
    [aView.layer insertSublayer:preview atIndex:9];
    
    // Start
    [self.session startRunning];

}

//バーコードリーダーのキャンセルボタンが押された時の処理
-(IBAction)barcodeCancel:(UIBarButtonItem *)sender{
    
    [self.session stopRunning];
    //VideoPreviewLayer初期化
    preview = [[AVCaptureVideoPreviewLayer alloc] init];
//    aView = nil;
    [aView setHidden:YES];
}

//バーコード読み取りが完了した時の処理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    //サウンドを再生
    SystemSoundID soundID;
    NSURL* soundURL = [[NSBundle mainBundle] URLForResource:@"scan"
                                              withExtension:@"mp3"];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundURL, &soundID);
    AudioServicesPlaySystemSound (soundID);
    
    // 複数のmetadataが来るので順に調べる（ここではJANコードに限定）
    for (AVMetadataObject *data in metadataObjects) {
        if (![data isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) continue;
        // barcode data
        NSString *strValue = [(AVMetadataMachineReadableCodeObject *)data stringValue];
        // type ?

        if ([data.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            // 最初の4桁と最後のチェックデジットを削除して8桁のtagNoを抽出
            tagNo =[strValue substringWithRange:NSMakeRange(4,8)];
            NSLog(@"tagNo = %@",tagNo);
            [self.session stopRunning];
            [aView setHidden:YES];
            [self inputTagNo:tagNo];
            
        }
    }
}

//tagNoが選択された後のアクション
- (void)inputTagNo:(NSString*)selectTagNo {
    NSLog(@"%@",selectTagNo);
    if([selectTagNo isEqualToString:@""]){
        NSLog(@"タッグNo未入力");
    }else{
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"画像を送信します"
                                            message:[NSString stringWithFormat:@"タッグNo.%@",selectTagNo]
                                     preferredStyle:UIAlertControllerStyleAlert];
        // addAction
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action){
                                                                  [self postData];
                                                              }];
        
        [alert addAction:defaultAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"キャンセル"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 [alert dismissViewControllerAnimated:YES
                                                                                                     completion:nil];
                                                             }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

//            [postButtonItem setEnabled:YES];
//            _tagNoLabel.text = [NSString stringWithFormat:@"%@を送信します",selectTagNo];
//            [_tagNoLabel setHidden:NO];
    }
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
    
    //UIImageをpngに変換(圧縮率を指定)
    float resize = 0.3;
    UIImage* originalImage = _myImageView.image;
    CGSize size = CGSizeMake(originalImage.size.width*resize, originalImage.size.height*resize);
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* pngData = UIImagePNGRepresentation(image);
    
    
    //---ここからPOSTDATAの作成---
    //http://kyuuuuuuuuuuri.hatenablog.com/entry/20130414/1365910741
    //アップロード先のURL
    NSString *urlString = @"http://oktss03.xsrv.jp/refresh.php";
    NSString *boundary = @"---------------------------168072824752491622650073";
    //リクエストのオブジェクトを作成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    
    // アップロードする際のファイル名
    NSString *uploadFileName= [NSString stringWithFormat:@"%@",tagNo];
    NSLog(@"filename= %@",uploadFileName);
    //フォルダ名（固定）
    NSString *folderName = @"refresh";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    // テキスト部分の設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"refresh"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", folderName] dataUsingEncoding:NSUTF8StringEncoding]];

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
            [self postIBM:tagNo];
            NSString *OKNG = [IBMData objectForKey:@"OKNG"];
            
            if([OKNG  isEqual: @"0"]){
                NSLog(@"OK");

            }else {
                NSLog(@"NG");
            }
            
        NSArray *rtnMSG = [IBMData objectForKey:@"RTNMSG"];
            
            NSString *string = rtnMSG[0];
            NSLog(@"%@",string);
            
            UIAlertController *postedAlert =
            [UIAlertController alertControllerWithTitle:@"送信完了"
                                                message:string
                                         preferredStyle:UIAlertControllerStyleAlert];
            // addAction
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action){
                                                                      //アクティビティインジケーターを停止
                                                                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                      
                                                                      //前画面に戻る
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [postedAlert addAction:defaultAction];
            [self presentViewController:postedAlert animated:YES completion:nil];
            
            //サーバーから帰ってきた値がOKじゃなかった時の処理(NG or nil)
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信エラー" message:@"画像を送信できませんでした\nやり直してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [_indicator stopAnimating];
            
            }
    }
    
    
}


/*
//送信ボタンが押された時の処理
- (void)sendButton {
    if(tagNo == nil){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"タッグNoが選択されていません" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    }
    [self postData];
}
*/

//キャンセルボタンが押された時の処理
- (void)cancelButton {
    // 前の画面に戻る
    [self.navigationController popViewControllerAnimated:YES];

}


-(NSDictionary *)postIBM:(NSString *)tag{
    IBMData = [[NSDictionary alloc]init];
    
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *iPadName = [deviceName uppercaseString];
    
    // キーチェーンアクセスから識別子を取得
    LUKeychainAccess *keychainAccess = [LUKeychainAccess standardKeychainAccess];
    NSString *idfv = [keychainAccess stringForKey:@"idfv"];
    if(idfv == nil){
        //IDFVの取得
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        idfv = uuid.UUIDString;
        
        //保存
        [keychainAccess setString:idfv forKey:@"idfv"];
        
    }


    NSString *userData = [NSString stringWithFormat:@"%@&IDENTIFIER=%@&PRCID=HBR001&PRC_TYP=OTH&TAGNO=%@",iPadName,idfv,tag];
    
    NSString *path = [@"http://maru8ibm.maruhachi.local:8080/htp2/wah001cl.pgm?COMPUTER=" stringByAppendingString:userData];
    NSLog(@"url = %@", path);
    
    NSURL *url = [NSURL URLWithString:path];
    //リクエストをするためのオブジェクトを作成 timeoutを3秒に設定
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0];
    //データの取得を開始
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //データの取得に失敗したらアラートを表示
    if(data == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VPN接続が確認できません" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        NSError *error;
        //サーバーから返ってきた値を、JSON型で格納する。
        IBMData = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableLeaves error:&error];
    }
    
    return IBMData;
}



@end
