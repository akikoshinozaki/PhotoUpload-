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
    NSDictionary *infoDic1; //起動時に取得するTitle、URLの情報
    NSArray *titleList;
    //BOOL *loadSuccessful;
    UIDevice *device;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setToolbarHidden:YES];
    [self saveDefault];
    [self callDefault];
    
    titleList = [infoDic1 objectForKey:@"TITLE"];
    _gyomuCD1 = [infoDic1 objectForKey:@"BUTTON"];

//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (int i=0; i<titleList.count; i++){
        UIButton *myButton = [[UIButton alloc] init];
        UIImage *img = [UIImage imageNamed:@"btn_green.png"];
        myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myButton setBackgroundImage:img forState:UIControlStateNormal];
        [myButton setTitle:titleList[i] forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        myButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        myButton.tag = i;
        myButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:myButton];
        [myButton addTarget:self
                     action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

        
        //幅
        NSLayoutConstraint *constraint00 = [NSLayoutConstraint constraintWithItem:myButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0 constant:300.0];
        [self.view addConstraint:constraint00];
        
        //高さ
        NSLayoutConstraint *constraint01 = [NSLayoutConstraint constraintWithItem:myButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0 constant:60.0];
        [self.view addConstraint:constraint01];
        
        
        //横方向ビュー合わせ
        NSLayoutConstraint *constraint02 = [NSLayoutConstraint constraintWithItem:myButton
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0 constant:0.0];
        [self.view addConstraint:constraint02];
        
        //縦方向ビュー合わせ
        NSLayoutConstraint *constraint03 = [NSLayoutConstraint constraintWithItem:myButton
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0 constant:150 + i * 90.0];
        [self.view addConstraint:constraint03];
        


    }
    


    
    //バージョン情報を取得
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString" ];
    
    //アプリのバージョンを表示
    [versionLabel setText:[NSString stringWithFormat: @"Ver. %@", version]];
    //会社名を表示
    NSString *kaisha = [infoDic1 objectForKey:@"userName"];
    [userName setText:kaisha];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ThirdViewController *view3 = [self.storyboard instantiateViewControllerWithIdentifier:@"view3"];
    view3.buttonTag = _buttonTag;
    view3.gyomuCD3 = _gyomuCD1;
    
//    [self presentViewController:view3 animated:YES completion:nil];
    [self.navigationController pushViewController:view3 animated:YES];
    
}


@end
