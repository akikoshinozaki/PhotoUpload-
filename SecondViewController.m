//
//  SecondViewController.m
//  PhotoUpload
//
//  Created by administrator on 2015/07/01.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
- (IBAction)backButton:(UIBarButtonItem *)sender;


@end

@implementation SecondViewController
{
    UIButton *myButton;
    NSDictionary *infoDic2;
    NSArray *titleList;
    UIDevice *device;
    UIView *portrait;
    UIView *landscape;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self saveDefault];
    [self callDefault];

    titleList = [infoDic2 objectForKey:@"TITLE"];
    _gyomuCD2 = [infoDic2 objectForKey:@"BUTTON"];
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
    NSLog(@"portrait = %f,%f", portrait.WIDTH,portrait.HEIGHT);
    NSLog(@"landscape = %f,%f", landscape.WIDTH,landscape.HEIGHT);

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
    _jsonData = [Json getJson:_gyomuCD2[_buttonTag]];
//    NSLog(@"%@", _jsonData);
    //jsonDataに値が入っていれば、ユーザーデフォルトに保存
    //jsonDataがnilの場合はアラートを表示
    if(_jsonData.count==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VPN 丸ハ接続" message:@"VPN 丸八接続 が「接続中」になっているか確認してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_jsonData forKey:@"jsonData2"];
        BOOL successful = [defaults synchronize];
        if (successful) {
            NSLog(@"%@", @"データの保存に成功しました。");
        }
    }
}
//保存されているユーザーデフォルトを呼び出すメソッド
-(void)callDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    infoDic2 = [defaults objectForKey:@"jsonData2"];
    if (!infoDic2) {
        NSLog(@"%@", @"データが存在しません。");
    }
}

//ボタンタップ時のアクション
- (void)clickButton:(UIButton*)button {
    _buttonTag = (int)button.tag;
    ThirdViewController *view3 = [self.storyboard instantiateViewControllerWithIdentifier:@"view3"];
    view3.buttonTag = _buttonTag;
    view3.gyomuCD3 = _gyomuCD2;
    [self presentViewController:view3 animated:YES completion:nil];
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(UIBarButtonItem *)sender {
    //前画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
