//
//  FirstViewController.h
//  PhotoUpload
//
//  Created by administrator on 2015/06/23.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Json.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "PhotoViewController.h"

@interface FirstViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDelegate>
@property int buttonTag;
@property(retain) NSDictionary *jsonData;
@property(retain) NSArray *gyomuCD1;

//- (IBAction)startCamera:(UIBarButtonItem *)sender;

@end

