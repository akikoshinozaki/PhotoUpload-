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
@property (weak, nonatomic) IBOutlet UILabel *tagNoLabel;
@property (weak, nonatomic) UITextField *textInAlert;
@property (strong, nonatomic) AVCaptureSession* session;
- (IBAction)barcodeCancel:(UIBarButtonItem *)sender;

@end

@implementation PhotoViewController
{
    NSString *tagNo;
    UIAlertView *alert2;
//    NSDictionary *jsonData;
    UIBarButtonItem *postButtonItem;
    UIBarButtonItem *cancelButtonItem;
    UIBarButtonItem *tagNoButtonItem;
    AVCaptureVideoPreviewLayer *preview;
    IBOutlet UIView *aView;
    IBOutlet UIBarButtonItem *barcodeCancel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setToolbarHidden:NO];
    [aView setHidden:YES];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton)];
    tagNoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"タッグNo.入力" style:UIBarButtonItemStylePlain target:self action:@selector(selectNo:)];
    postButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"送信" style:UIBarButtonItemStylePlain target:self action:@selector(sendButton)];

    
    [self setToolbarItems:[NSArray arrayWithObjects:cancelButtonItem, flexSpace, tagNoButtonItem, flexSpace,postButtonItem, nil] animated:YES];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _myImageView.image = delegate.image;
    _infoDic = delegate.infoDic;
    _buttonTag = delegate.buttonTag;
    _naviTitle.title = @"サーバーへ画像を送信";
    
    if (tagNo == nil){
        [postButtonItem setEnabled:NO];
        [_tagNoLabel setHidden:YES];

    }else {
            [postButtonItem setEnabled:YES];
        }
    
}

//20160507 回転を検知
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(didChangedOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//20160507 回転を検知
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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

*/


//タッグNo.を選択するアクションシートを表示
- (void)selectNo:(id)sender{
    UIDevice *device = [UIDevice currentDevice];
    //(iOS8)
    if ([device.systemVersion floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"タッグNoを入力してください"
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleAlert];
    // addAction
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action){
                                                                  [self buttonPushed:tagNo];
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
        }];
    
    alertController.popoverPresentationController.barButtonItem = sender;
    
    [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    tagNo = _textInAlert.text;
    
}



- (void)barcodeReader {
    [aView setHidden:NO];

    // Device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // session
    self.session = [[AVCaptureSession alloc] init];
    
    // Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
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
    
    [self didChangedOrientation];//20160507 回転向き調整
    
    [aView.layer insertSublayer:preview atIndex:0];

    // Start
    [self.session startRunning];

}

-(IBAction)barcodeCancel:(UIBarButtonItem *)sender{
    [self.session stopRunning];
    [preview removeFromSuperlayer];//20160507 レイヤから外す
//    aView = nil;
    [aView setHidden:YES];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    SystemSoundID soundID;
    NSURL* soundURL = [[NSBundle mainBundle] URLForResource:@"scan"
                                              withExtension:@"mp3"];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundURL, &soundID);
    AudioServicesPlaySystemSound (soundID);
    
    // 複数のmetadataが来るので順に調べる
    for (AVMetadataObject *data in metadataObjects) {
        if (![data isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) continue;
        // barcode data
        NSString *strValue = [(AVMetadataMachineReadableCodeObject *)data stringValue];
        // type ?

        if ([data.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            // JANコードの場合
            tagNo =[strValue substringWithRange:NSMakeRange(4,8)];
            NSLog(@"tagNo = %@",tagNo);
            [self.session stopRunning];
            [preview removeFromSuperlayer];//20160507 レイヤから外す
            [postButtonItem setEnabled:YES];
            _tagNoLabel.text = [NSString stringWithFormat:@"%@を送信します",tagNo];
            [_tagNoLabel setHidden:NO];
            [aView setHidden:YES];
            
        }
    }
}

//(iOS8)UIAlertControllerで項目を選択した後のアクション
- (void) buttonPushed:(NSString*)selectTagNo {
    if(selectTagNo != nil){
//    NSLog(@"tagNo = %@",tagNo);
            [postButtonItem setEnabled:YES];
            _tagNoLabel.text = [NSString stringWithFormat:@"%@を送信します",selectTagNo];
            [_tagNoLabel setHidden:NO];
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
    float resize = 0.4;
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
    [self.navigationController popViewControllerAnimated:YES];

    }
}



//送信ボタンが押された時の処理
- (void)sendButton {
    if(tagNo == nil){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"タッグNoが選択されていません" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    }
    [self postData];
}

//キャンセルボタンが押された時の処理
- (void)cancelButton {
    // 前の画面に戻る
    [self.navigationController popViewControllerAnimated:YES];

}

//20160507 回転を検知
- (void)didChangedOrientation
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
            
        case UIDeviceOrientationPortrait:
            [preview connection].videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [preview connection].videoOrientation = AVCaptureVideoOrientationLandscapeRight;//20160507 逆になる
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [preview connection].videoOrientation = AVCaptureVideoOrientationLandscapeLeft;//20160507 逆になる
            break;
            
        case UIDeviceOrientationFaceUp:
            break;
            
        case UIDeviceOrientationFaceDown:
            break;
            
        case UIDeviceOrientationUnknown:
            break;
            
        default:
            break;
    }
}

@end
