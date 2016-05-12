//
//  NavigationController.h
//  PhotoUpload
//
//  Created by administrator on 2016/05/11.
//  Copyright © 2016年 administrator. All rights reserved.
//
// アプリ全体を横向きで固定させるため、NavigationControllerの継承クラスを作成

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
