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
    
    //端末識別子の取得
    // キーチェーンアクセスから識別子を取得
    LUKeychainAccess *keychainAccess = [LUKeychainAccess standardKeychainAccess];
    NSString *idfv = [keychainAccess stringForKey:@"idfv"];
    
    if(idfv == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"識別子エラー" message:@"丸八システムを先に起動してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        NSLog(@"識別子エラー");
        idfv = @"";
    }
    NSLog(@"idfv = %@",idfv);


    //日付・時刻を取得
    
    NSDateFormatter *IRAIHI = [[NSDateFormatter alloc]init];
    [IRAIHI setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *IRAITM = [[NSDateFormatter alloc]init];
    [IRAITM setDateFormat:@"HHmmss"];
    NSDate *date = [NSDate date];
    NSString *strIRAIHI = [IRAIHI stringFromDate:date];
    NSString *strIRAITM = [IRAITM stringFromDate:date];
    
    NSString *userData = [NSString stringWithFormat:@"%@&IDENTIFIER=%@&PRCID=HIC002&PRC_TYP=OTH&GYOMUCD=%@&IRAIHI=%@&IRAITM=%@",iPadName,idfv,buttonCD,strIRAIHI,strIRAITM];
    
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
