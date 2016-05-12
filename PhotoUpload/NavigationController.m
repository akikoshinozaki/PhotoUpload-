//
//  NavigationController.m
//  PhotoUpload
//
//  Created by administrator on 2016/05/11.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

- (NSUInteger)supportedInterfaceOrientations
{
//    return [self.visibleViewController supportedInterfaceOrientations];
    return UIInterfaceOrientationMaskLandscape;
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
