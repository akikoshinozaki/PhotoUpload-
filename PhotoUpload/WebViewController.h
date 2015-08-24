//
//  WebViewController.h
//  PhotoUpload
//
//  Created by administrator on 2015/07/03.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Json.h"
#import "ThirdViewController.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property int buttonTag;
//読み込んだjsonDataを受け取るDictionary
@property(retain) NSDictionary *infoDic;
@property NSArray *urlList;
@end
