//
//  ThirdViewController.h
//  PhotoUpload
//
//  Created by administrator on 2015/07/01.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Json.h"
#import "AppDelegate.h"
#import "PhotoViewController.h"
#import "WebViewController.h"
#import "SecondViewController.h"
#import "FirstViewController.h"



@interface ThirdViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDelegate>
@property int buttonTag;
@property(retain) NSDictionary *jsonData;
@property(retain) NSArray *gyomuCD3;

@end
