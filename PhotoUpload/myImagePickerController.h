//
//  myImagePickerController.h
//  PhotoUpload
//
//  Created by administrator on 2016/05/06.
//  Copyright © 2016年 administrator. All rights reserved.
//
//フォトアルバムを横向きビューで表示させるため、UIImagePickerの継承クラスを作成

#import <UIKit/UIKit.h>


@interface myImagePickerController : UIImagePickerController
- (NSUInteger)supportedInterfaceOrientations;

@end
