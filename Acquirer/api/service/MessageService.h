//
//  MessageService.h
//  Acquirer
//
//  短信请求
//
//  Created by chinapnr on 13-9-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface MessageService : BaseService

//请求短信
-(void)requestForShortMessage;
- (void)requestForShortMessageByPnrDevId:(NSString *)pnrDevId;

@end
