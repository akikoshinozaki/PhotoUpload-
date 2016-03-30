//
//  AppDelegate.h
//  PhotoUpload
//
//  Created by administrator on 2015/06/23.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LUKeychainAccess.h"

#define WIDTH bounds.size.width
#define HEIGHT bounds.size.height

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// ViewController
@property(nonatomic,retain) UIViewController *viewController;
//firstViewからsecondViewへ値を渡す変数
@property int buttonTag;
//@property(retain) NSArray *gyomuCD;

//受け渡しをする画像
@property UIImage *image;
@property(retain) NSDictionary *infoDic;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

