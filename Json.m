//
//  Json.m
//  PhotoUpload
//
//  Created by administrator on 2015/07/01.
//  Copyright (c) 2015年 administrator. All rights reserved.
//

#import "Json.h"

@implementation Json

+(NSDictionary *)getJson:(NSString *)buttonCD{
    NSDictionary *jsonDic = [[NSDictionary alloc]init];
    
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *iPadName = [deviceName uppercaseString];
    
    //IDFAの取得 UDIDに変わるiOSが発行するID
    ASIdentifierManager *im = [ASIdentifierManager sharedManager];
    NSString *idfa = @"";
    if (im.advertisingTrackingEnabled) {
        idfa = im.advertisingIdentifier.UUIDString;
    }
    //日付・時刻を取得
    
    NSDateFormatter *IRAIHI = [[NSDateFormatter alloc]init];
    [IRAIHI setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *IRAITM = [[NSDateFormatter alloc]init];
    [IRAITM setDateFormat:@"HHmmss"];
    NSDate *date = [NSDate date];
    NSString *strIRAIHI = [IRAIHI stringFromDate:date];
    NSString *strIRAITM = [IRAITM stringFromDate:date];
    
    NSString *userData = [NSString stringWithFormat:@"%@&IDENTIFIER=%@&PRCID=HIC002&PRC_TYP=OTH&GYOMUCD=%@&IRAIHI=%@&IRAITM=%@",iPadName,idfa,buttonCD,strIRAIHI,strIRAITM];
    
    NSString *path = [@"http://maru8ibm.maruhachi.local:8080/htp2/wah001cl.pgm?COMPUTER=" stringByAppendingString:userData];
    NSLog(@"url = %@", path);
    
    NSURL *url = [NSURL URLWithString:path];
    //リクエストをするためのオブジェクトを作成 timeoutを3秒に設定
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0];
    //データの取得を開始
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //データの取得に失敗したらアラートを表示
    if(data == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VPN接続が確認できません" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        NSError *jsonError;
        //サーバーから返ってきた値を、JSON型で格納する。
        jsonDic = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableLeaves error:&jsonError];
    }
    
    return jsonDic;
}

    



@end
