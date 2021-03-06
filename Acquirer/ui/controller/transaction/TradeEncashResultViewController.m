//
//  TradeEncashResultViewController.m
//  Acquirer
//
//  Created by peer on 10/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeEncashResultViewController.h"

@implementation TradeEncashResultViewController

@synthesize encashRes, bankIdSTR;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavigationTitle:@"取现结果"];
    naviBackBtn.hidden = YES;
    
    UIImage *successImg = [UIImage imageNamed:@"success.png"];
    UIImage *failureImg = [UIImage imageNamed:@"fail.png"];
    UIImage *pendingImg = [UIImage imageNamed:@"dealing.png"];
    
    NSArray *imgList = @[successImg, failureImg, pendingImg];
    NSArray *textList = @[@"取现成功！", @"取现失败！", @"处理中..."];
    
    NSString *successSTR = [NSString stringWithFormat:@"取现金额已到账，请查看您的银行卡（尾号：%@）。", bankIdSTR];
    NSString *failureSTR = @"取现失败，请重新操作";
    NSString *pendingSTR = @"资金处理中，稍候可在“结算管理－结算查询”中查看结果";
    
    NSArray *descList = @[successSTR, failureSTR, pendingSTR];
    
    CGFloat heightOffset = 40;
    
    UIImageView *stateImgView = [[[UIImageView alloc] initWithImage:[imgList objectAtIndex:encashRes]] autorelease];
    stateImgView.frame = CGRectMake(70, 0, stateImgView.bounds.size.width, stateImgView.bounds.size.height);
    [self.contentView addSubview:stateImgView];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.frame = CGRectMake(stateImgView.frame.origin.x+stateImgView.frame.size.width+20, heightOffset, 180, 40);
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.textAlignment = NSTextAlignmentLeft;
    stateLabel.font = [UIFont boldSystemFontOfSize:24];
    stateLabel.text = [textList objectAtIndex:encashRes];
    [self.contentView addSubview:stateLabel];
    [stateLabel release];
    
    stateImgView.center = CGPointMake(stateImgView.center.x, stateLabel.center.y);
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(stateLabel.frame)+VERTICAL_PADDING*3, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.frame = CGRectMake(0, frameHeighOffset(dashFrame)+VERTICAL_PADDING, 280, 50);
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = [UIFont boldSystemFontOfSize:18];
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.numberOfLines = 3;
    descLabel.text = [descList objectAtIndex:encashRes];
    [self.contentView addSubview:descLabel];
    descLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), descLabel.center.y);
    [descLabel release];
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_whi_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_whi_off.png"];
    CGRect buttonFrame = CGRectMake(10, frameHeighOffset(descLabel.frame)+VERTICAL_PADDING*4, 100, 40);
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = buttonFrame;
    submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), submitBtn.center.y);
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setBackgroundImage:btnDeSelImg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:btnSelImg forState:UIControlStateSelected];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 10.0;
    submitBtn.clipsToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(pressConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
}

-(void)pressConfirm:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
