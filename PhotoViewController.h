//
//  PhotoViewController.h
//  PhotoUpload
//
//  Created by administrator on 2015/06/23.
//  Copyright (c) 2015年 administrator. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FirstViewController.h"
#import "Json.h"
@import AVFoundation;

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate,UIAlertViewDelegate, NSURLConnectionDataDelegate,NSURLSessionDataDelegate, NSURLSessionTaskDelegate,UIActionSheetDelegate, UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>

//何番目のボタンが押されたかを判別する変数
@property int buttonTag;
@property(retain) NSArray *gyomuCD;
//読み込んだjsonDataを受け取るDictionary
@property(retain) NSDictionary *infoDic;
@property (nonatomic, retain) IBOutlet UIImageView *myImageView;

@end
