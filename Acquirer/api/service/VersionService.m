//
//  VersionService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-3.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "VersionService.h"
#import "Acquirer.h"
#import "DeviceIntrospection.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "Helper.h"

@interface VerUpdateAlertView : UIAlertView{
    NSString *updateURL;
    NSString *serverVersion;
}
@property (nonatomic, copy) NSString *updateURL;
@property (nonatomic, copy) NSString *serverVersion;
@end

@implementation VerUpdateAlertView
@synthesize updateURL, serverVersion;

-(void)dealloc{
    [updateURL release];
    [serverVersion release];
    [super dealloc];
}
@end

@implementation VersionService

-(void)requestForVersionCheck{
    [[Acquirer sharedInstance] showUIPromptMessage:@"检查版本更新" animated:YES];
    
    NSString *URLstring = [NSString stringWithFormat:@"http://www.ttyfund.com/api/services/checkupdate.php"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"TTYFUND-CHINAPNR" forKey:@"key"];
    [dict setValue:@"sd_pos" forKey:@"app_client"];
    [dict setValue:getHardwareVersion() forKey:@"app_platform"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"app_version"];
    
    NSURL *URL = [NSURL URLWithString:[CPRequest embedQueryInPath:URLstring andQuery:dict]];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:URL];
    [req setDidFinishSelector:@selector(versionRequestDidFinished:)];
    req.delegate = self;
    [req startAsynchronous];
}

-(void)versionRequestDidFinished:(ASIHTTPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = [[req responseString] JSONValue];
    
    if (NotNilAndEqualsTo(body, @"return_code", @"1")){
        if (NotNilAndEqualsTo(body, @"is_need_update", @"1") && NotNil(body, @"latest_version")){
            
            NSString *serverVersion = [body objectForKey:@"latest_version"];
            NSString *title = [NSString stringWithFormat:@"软件升级至%@版本", serverVersion];
            
            NSString *message = @"";
            if (NotNil(body, @"string")) {
                message = [body objectForKey:@"string"];
            }
            
            if (NotNilAndEqualsTo(body, @"force_update", @"1")){
                //需要强制升级
                VerUpdateAlertView *alertView = [[VerUpdateAlertView alloc] initWithTitle:title
                                                                                  message:message
                                                                                 delegate:self
                                                                        cancelButtonTitle:@"确定"
                                                                        otherButtonTitles:nil];
                alertView.serverVersion = serverVersion;
                if (NotNil(body, @"update_url")) {
                    alertView.updateURL = [body objectForKey:@"update_url"];
                }
                
                alertView.tag = 1;
                [alertView show];
                [alertView release];
            }
            else{
                //不需要强制升级
                if (NotNil(body, @"latest_version")) {
                    
                    NSString *ignoreVersion = [Helper getValueByKey:ACQUIRER_IGNORE_VERSION];
                    
                    //比较服务端版本和忽略的版本
                    if (ignoreVersion == nil || ![ignoreVersion isEqualToString:serverVersion]) {
                        //弹出三个按钮的弹窗
                        VerUpdateAlertView *alertView = [[VerUpdateAlertView alloc] initWithTitle:title
                                                                                          message:message
                                                                                         delegate:self
                                                                                cancelButtonTitle:@"取消"
                                                                                otherButtonTitles:@"立即升级", @"不再提醒", nil];
                        alertView.serverVersion = serverVersion;
                        if (NotNil(body, @"update_url")) {
                            alertView.updateURL = [body objectForKey:@"update_url"];
                        }
                        alertView.tag = 2;
                        [alertView show];
                        [alertView release];
                    }
                }
            }
        }
        else
        {
            if (target && [target respondsToSelector:selector])
            {
                [target performSelector:selector];
            }
        }
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(VerUpdateAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *URL = [NSURL URLWithString:alertView.updateURL];
    if (alertView.tag==1) {
        //强制升级
        [[UIApplication sharedApplication] openURL:URL];
    }
    else if (alertView.tag == 2){
        //立即升级
        if (buttonIndex == 1) {
            //强制升级,这里如果在AppStore上架，需要App的Id号
            [[UIApplication sharedApplication] openURL:URL];
        }
        //不再提醒
        else if (buttonIndex == 2){
            if (alertView.serverVersion != nil) {
                [Helper saveValue:alertView.serverVersion forKey:ACQUIRER_IGNORE_VERSION];
            }
        }
        //取消
        else{
            //do nothing
        }
    }
}

@end