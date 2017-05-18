//
//  ThirdViewController.m
//  PhotoUpload
//
//  Created by administrator on 2015/07/01.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()
- (IBAction)backButton:(UIBarButtonItem *)sender;

@end

@implementation ThirdViewController
{
    UIButton *myButton;
    NSDictionary *infoDic3;
    NSArray *titleList;
    NSArray *urlList;
    BOOL *loadSuccessful;
    UIDevice *device;
    UIView *portrait;
    UIView *landscape;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self saveDefault];
    [self callDefault];
    
    titleList = [infoDic3 objectForKey:@"TITLE"];
    _gyomuCD3 = [infoDic3 objectForKey:@"BUTTON"];
    device = [UIDevice currentDevice];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //縦向きで起動した時
    if (orientation == UIDeviceOrientationPortrait){
        portrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT-44)];
        landscape = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH-44)];
        
        [self.view addSubview:portrait];
        [self buttonRect:portrait];
        //横向きで起動した時
    }else {
        //iOS8以上の場合
        if ([device.systemVersion floatValue] >= 8.0) {
            portrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH-44)];
            landscape = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT-44)];
            //iOS7の場合
        }else {
            portrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT-44)];
            landscape = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH-44)];
        }
        
        [self.view addSubview:landscape];
        [self buttonRect:landscape];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonRect :(UIView *)view {
    //ボタンの数が7個以下の場合の配置（1列）
    NSLog(@"%@", titleList);
    if (titleList.count < 7){
        for (int i=0; i<titleList.count; i++){
            myButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
            UIImage *img = [UIImage imageNamed:@"btn_green.png"];
            CGRect buttonRect = CGRectMake((view.WIDTH - myButton.WIDTH)/2, 150+i*90, myButton.WIDTH, myButton.HEIGHT);
            
            myButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [myButton setBackgroundImage:img forState:UIControlStateNormal];
            [myButton setTitle:titleList[i] forState:UIControlStateNormal];
            [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [myButton sizeToFit];
            myButton.frame = buttonRect;
            myButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            myButton.tag = i;
            [view addSubview:myButton];
            [myButton addTarget:self
                         action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        //ボタンの数が7個以上の場合の配置（2列）
    }else {
        for (int i=0; i<titleList.count; i++){
            myButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
            UIImage *img = [UIImage imageNamed:@"btn_green.png"];
            CGRect buttonRect = CGRectMake(view.WIDTH/2 - (20+myButton.WIDTH)*((i+1)%2)+20*(i%2), 150+i/2*90, myButton.WIDTH, myButton.HEIGHT);
            
            myButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [myButton setBackgroundImage:img forState:UIControlStateNormal];
            [myButton setTitle:titleList[i] forState:UIControlStateNormal];
            [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [myButton sizeToFit];
            myButton.frame = buttonRect;
            myButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            myButton.tag = i;
            
            [view addSubview:myButton];
            [myButton addTarget:self
                         action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    
    
}

- (BOOL)shouldAutorotate
{
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            [self.view addSubview:portrait];
            [self buttonRect:portrait];
            [portrait setHidden:NO];
            [landscape setHidden:YES];
            NSLog(@"PORTRAIT");
            return YES;
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self.view addSubview:landscape];
            [self buttonRect:landscape];
            [portrait setHidden:YES];
            [landscape setHidden:NO];
            NSLog(@"LEFT");
            return  YES;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [self.view addSubview:landscape];
            [self buttonRect:landscape];
            [portrait setHidden:YES];
            [landscape setHidden:NO];
            NSLog(@"RIGHT");
            return YES;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    //return UIInterfaceOrientationMaskPortrait;
    return (UIInterfaceOrientationMaskPortrait
            | UIInterfaceOrientationMaskLandscapeRight
            | UIInterfaceOrientationMaskLandscapeLeft);
}


//JSONの取得に成功したら、ユーザーデフォルトに保存するメソッド
-(void)saveDefault {
    _jsonData = [[NSDictionary alloc] init];
    _jsonData = [Json getJson:_gyomuCD3[_buttonTag]];
    NSLog(@"%@", _jsonData);
    //jsonDataに値が入っていれば、ユーザーデフォルトに保存
    //jsonDataがnilの場合はアラートを表示
    if(_jsonData.count==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VPN 丸ハ接続" message:@"VPN 丸八接続 が「接続中」になっているか確認してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_jsonData forKey:@"jsonData3"];
        BOOL successful = [defaults synchronize];
        if (successful) {
            NSLog(@"%@", @"データの保存に成功しました。");
        }
    }
}
//保存されているユーザーデフォルトを呼び出すメソッド
-(void)callDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    infoDic3 = [defaults objectForKey:@"jsonData3"];
    if (!infoDic3) {
        NSLog(@"%@", @"データが存在しません。");
    }
}

//ボタンを押した時の処理
- (void)clickButton:(UIButton*)button {
    NSLog(@"%@",_gyomuCD3[_buttonTag]);
    
    //業務コードがGXXXの時は、カメラを起動して画像をアップロード
    if([_gyomuCD3[_buttonTag] hasPrefix:@"G"]){
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.buttonTag = (int)button.tag;
    delegate.infoDic = infoDic3;
    
    // カメラが使用可能かどうか判定する
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    // UIImagePickerControllerのインスタンスを生成
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // デリゲートを設定
    imagePicker.delegate = self;
    
    // 画像の取得先をカメラに設定
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 画像取得後に編集するかどうか（デフォルトはNO）
    imagePicker.allowsEditing = NO;
    
    // 撮影画面をモーダルビューとして表示する
    [self presentViewController:imagePicker animated:YES completion:nil];
        
    //業務コードがGXXX以外のときは、対応するURLをWebViewで表示
    }else {
        _buttonTag = (int)button.tag;
//        urlList = [[NSArray alloc] init];
//        urlList = [infoDic3 objectForKey:@"URL"];

        urlList = [[NSArray alloc] initWithObjects:@"http://www.apple.com/jp/",@"http://www.google.co.jp",@"http://www.yahoo.co.jp",@"http://www.disney.co.jp/home.html",@"http://www.maruhachi.co.jp", nil];

        WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
        webView.buttonTag = _buttonTag;
        webView.urlList = urlList;
 
        [self presentViewController:webView animated:YES completion:nil];
        NSLog(@"go to webView");
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 最初の画面に戻る
    [self dismissViewControllerAnimated:NO completion:nil];
    
    PhotoViewController *photo = [self.storyboard instantiateViewControllerWithIdentifier:@"photo"];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.image = img;
    
    [self presentViewController:photo animated:YES completion:nil];
    
}

// キャンセルボタンのデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 最初の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // キャンセルされたときの処理を記述・・・
}


- (IBAction)backButton:(UIBarButtonItem *)sender {
    //前画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
