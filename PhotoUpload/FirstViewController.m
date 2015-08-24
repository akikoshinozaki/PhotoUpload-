//
//  FirstViewController.m
//  PhotoUpload
//
//  Created by administrator on 2015/06/23.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import "FirstViewController.h"
#import <AdSupport/AdSupport.h>

@interface FirstViewController ()

@end

@implementation FirstViewController
{
    //バージョンを表示するラベル
    IBOutlet UILabel *versionLabel;
    //会社名を表示するラベル
    IBOutlet UILabel *userName;
    UIButton *myButton;
    NSDictionary *infoDic1;
    NSArray *titleList;
    //BOOL *loadSuccessful;
    UIDevice *device;
    UIView *portrait;
    UIView *landscape;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self saveDefault];
    [self callDefault];
    
    titleList = [infoDic1 objectForKey:@"TITLE"];
    _gyomuCD1 = [infoDic1 objectForKey:@"BUTTON"];

    device = [UIDevice currentDevice];
//    myView = [[UIView alloc] init];

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait){
        portrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT)];
        landscape = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH)];
        [self.view addSubview:portrait];
        [self buttonRect:portrait];
        
        
    }else {
        portrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH)];
        landscape = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT)];
        [self.view addSubview:landscape];
        [self buttonRect:landscape];
    }
    NSLog(@"portrait = %f,%f", portrait.WIDTH,portrait.HEIGHT);
    NSLog(@"landscape = %f,%f", landscape.WIDTH,landscape.HEIGHT);
/*
    
    //縦向きで起動した時
    if (orientation == UIDeviceOrientationPortrait){
        portrait = CGRectMake(0, 0, self.view.WIDTH, self.view.HEIGHT-44);
        landscape = CGRectMake(0, 0, self.view.HEIGHT, self.view.WIDTH-44);
        NSLog(@"PORTLAIT");
        myView.frame = portrait;
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
        myView.frame = landscape;
        
    }
    
    [self.view addSubview:myView];
    [self buttonRect:myView];

*/
    
    //バージョン情報を取得
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString" ];
    
    //アプリのバージョンを表示
    [versionLabel setText:[NSString stringWithFormat: @"Ver. %@", version]];
    //会社名を表示
//    NSString *kaisha = [infoDic1 objectForKey:@"userName"];
//    [userName setText:kaisha];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)viewDidLayoutSubviews
{
    if(device.orientation == UIDeviceOrientationPortrait)
    {
        myView.frame = portrait;
    }else {
        myView.frame = landscape;
    }
}
*/
- (void)buttonRect :(UIView *)view {
    //ボタンの数が7個以下の場合の配置（1列）
//    NSLog(@"%@", titleList);
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
    return (UIInterfaceOrientationMaskPortrait
            | UIInterfaceOrientationMaskLandscapeRight
            | UIInterfaceOrientationMaskLandscapeLeft);
}


//JSONの取得に成功したら、ユーザーデフォルトに保存するメソッド
-(void)saveDefault {
    _jsonData = [[NSDictionary alloc] init];
    _jsonData = [Json getJson:@"C000"];
    //jsonDataに値が入っていれば、ユーザーデフォルトに保存
    //jsonDataがnilの場合はアラートを表示
    if(_jsonData.count==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VPN 丸ハ接続" message:@"VPN 丸八接続 が「接続中」になっているか確認してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_jsonData forKey:@"jsonData1"];
        BOOL successful = [defaults synchronize];
        if (successful) {
            NSLog(@"%@", @"データの保存に成功しました。");
        }
    }
}
//保存されているユーザーデフォルトを呼び出すメソッド
-(void)callDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    infoDic1 = [defaults objectForKey:@"jsonData1"];
    if (!infoDic1) {
        NSLog(@"%@", @"データが存在しません。");
    }
}

//ボタンタップ時のアクション
- (void)clickButton:(UIButton*)button {
    _buttonTag = (int)button.tag;
    SecondViewController *view2 = [self.storyboard instantiateViewControllerWithIdentifier:@"view2"];
    view2.buttonTag = _buttonTag;
    view2.gyomuCD2 = _gyomuCD1;
    [self presentViewController:view2 animated:YES completion:nil];
    
}


@end
