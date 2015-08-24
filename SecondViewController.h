//
//  SecondViewController.h
//  PhotoUpload
//
//  Created by administrator on 2015/07/01.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Json.h"
#import "FirstViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController : UIViewController
@property int buttonTag;
@property(retain) NSDictionary *jsonData;
@property(retain) NSArray *gyomuCD2;
@end
