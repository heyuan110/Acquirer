//
//  LoginViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "ActivateViewController.h"
#import "NSNotificationCenter+CP.h"
#import "Acquirer.h"
#import "AcquirerService.h"
#import "ACUser.h"
#import "ValiIdentityViewController.h"
#import "GeneralTableView.h"
#import "FormCellContent.h"
#import "FormTableCell.h"
#import "ActivateViewController.h"

@interface LoginFormTableCell : FormTableCell
@end
@implementation LoginFormTableCell
-(void)adjustLayoutForViewController{}
@end


@implementation LoginViewController

@synthesize loginTableView;

-(void)dealloc{
    [loginTableView release];
    [patternList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        self.isShowNaviBar = NO;
        self.isShowTabBar = NO;
        patternList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpFormCellPatternList{
    NSArray *titleList = [NSArray arrayWithObjects:@"机  构  号　|", @"操作员号　|", @"密　　码　|", nil];
    NSArray *placeHolderList = [NSArray arrayWithObjects:@"以6开头的8位数字", @"请输入您的操作员号", @"请输入密码", nil];
    
    NSString *instSTR = [Helper getValueByKey:ACQUIRER_LOGIN_INSTITUTE];
    instSTR = [Helper stringNullOrEmpty:instSTR] ? @"" : instSTR;
    NSString *operatorSTR = [Helper getValueByKey:ACQUIRER_LOGIN_OPERATOR];
    operatorSTR = [Helper stringNullOrEmpty:operatorSTR] ? @"" : operatorSTR;
    NSString *passSTR = @"";
    
    NSArray *textList = [NSArray arrayWithObjects:instSTR, operatorSTR, passSTR, nil];
    NSArray *keyboardTypeList = [NSArray arrayWithObjects:[NSNumber numberWithInt:UIKeyboardTypeNumberPad],
                                                          [NSNumber numberWithInt:UIKeyboardTypeAlphabet],
                                                          [NSNumber numberWithInt:UIKeyboardTypeAlphabet],nil];
    NSArray *secureList = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                                                    [NSNumber numberWithBool:NO],
                                                    [NSNumber numberWithBool:YES], nil];
    NSArray *maxLengthList = [NSArray arrayWithObjects:[NSNumber numberWithInt:8],
                                                       [NSNumber numberWithInt:20],
                                                       [NSNumber numberWithInt:32],nil];
    
    [patternList removeAllObjects];
    for (int i=0; i<[titleList count]; i++) {
        FormCellContent *pattern = [[[FormCellContent alloc] init] autorelease];
        pattern.titleSTR = [titleList objectAtIndex:i];
        pattern.placeHolderSTR = [placeHolderList objectAtIndex:i];
        pattern.textSTR = [textList objectAtIndex:i];
        pattern.titleColor = [UIColor grayColor];
        pattern.titleFont = [UIFont boldSystemFontOfSize:16];
        pattern.keyboardType = [[keyboardTypeList objectAtIndex:i] integerValue];
        pattern.secure = [[secureList objectAtIndex:i] boolValue];
        pattern.maxLength = [[maxLengthList objectAtIndex:i] integerValue];
        pattern.formCellClass = [LoginFormTableCell class];
        [patternList addObject:pattern];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpFormCellPatternList];
    [self addSubViews];
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [contentView addGestureRecognizer:tg];
    tg.delegate = self;
    [tg release];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.isNeedRefresh)
    {
        self.isNeedRefresh = NO;
        
        [self setUpFormCellPatternList];
        [self.loginTableView reloadData];
    }
    
    //接收激活通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDoActivate:) name:NOTIFICATION_JUMP_ACTIVATE_PAGE object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addSubViews
{
    UIImage *loginBgImg = IS_IPHONE5 ? [UIImage imageNamed:@"sd_logo-568h@2x.png"]:[UIImage imageNamed:@"sd_logo"];
    UIImageView *loginBgImgView = [[[UIImageView alloc] init] autorelease];
    loginBgImgView.userInteractionEnabled = YES;
    loginBgImgView.frame = self.bgImageView.bounds;
    loginBgImgView.frame = self.bgImageView.bounds;
    loginBgImgView.image = loginBgImg;
    
    [self.bgImageView addSubview:loginBgImgView];
    [self.bgImageView sendSubviewToBack:loginBgImgView];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    CGRect tableFrame = CGRectMake(0, 90, contentWidth, 160);
    self.loginTableView = [[[GeneralTableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    loginTableView.scrollEnabled = NO;
    loginTableView.backgroundColor = [UIColor clearColor];
    loginTableView.backgroundView = nil;
    [self.contentView addSubview:loginTableView];
    //loginTableView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), loginTableView.center.y);
    [loginTableView setGeneralTableDataSource:[NSMutableArray arrayWithObject:patternList]];
    [loginTableView setDelegateViewController:self];
    
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(0, 255, btnSelImg.size.width, btnSelImg.size.height);
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = buttonFrame;
    loginBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), loginBtn.center.y);
    loginBtn.backgroundColor = [UIColor clearColor];
    [loginBtn setBackgroundImage:btnDeSelImg forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:btnSelImg forState:UIControlStateSelected];
    loginBtn.layer.cornerRadius = 10.0;
    loginBtn.clipsToBounds = YES;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:loginBtn];
    
    CGRect notLoginFrame = CGRectMake(0, 320, 120, 40);
    UIButton *notLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    notLoginBtn.frame = notLoginFrame;
    notLoginBtn.center = CGPointMake(CGRectGetMaxX(loginBtn.frame) - CGRectGetWidth(notLoginBtn.frame) / 2.0f, notLoginBtn.center.y);
    notLoginBtn.backgroundColor = [UIColor clearColor];
    notLoginBtn.titleLabel.font = [UIFont systemFontOfSize:19];//[UIFont fontWithName:@"Arial" size:19];
    [notLoginBtn setTitle:@"找回机构号" forState:UIControlStateNormal];
    [notLoginBtn setTitleColor:[Helper hexStringToColor:@"#4D77A4"] forState:UIControlStateNormal];
    [notLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    notLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [notLoginBtn addTarget:self action:@selector(notLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:notLoginBtn];
    
    UILabel *serviceTitleLabel = [[[UILabel alloc] init] autorelease];
    serviceTitleLabel.bounds = CGRectMake(0, 0, 80, 30);
    serviceTitleLabel.backgroundColor = [UIColor clearColor];
    serviceTitleLabel.font = [UIFont systemFontOfSize:13];
    serviceTitleLabel.text = @"客服电话:";
    serviceTitleLabel.textColor = [Helper hexStringToColor:@"#666666"];
    serviceTitleLabel.center = CGPointMake(110, contentHeight-40);
    [self.contentView addSubview:serviceTitleLabel];
    
    UILabel *servicePhoneLabel = [[[UILabel alloc] init] autorelease];
    servicePhoneLabel.bounds = CGRectMake(0, 0, 150, 30);
    servicePhoneLabel.backgroundColor = [UIColor clearColor];
    servicePhoneLabel.font = [UIFont systemFontOfSize:15];
    servicePhoneLabel.text = @"400-820-2819";
    servicePhoneLabel.textColor = [Helper hexStringToColor:@"#4D77A4"];
    servicePhoneLabel.center = CGPointMake(210, contentHeight-41);
    [self.contentView addSubview:servicePhoneLabel];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *touchView = [touch view];
    if([touchView isKindOfClass:[UIControl class]])
    {
        return (NO);
    }
    return (YES);
}

-(void) tapGesture:(UITapGestureRecognizer *)sender{
    for (FormTableCell *cell in [self.loginTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
}

-(void)login:(id)sender{
    NSArray *visibleCellList = [self.loginTableView visibleCells];
    for (FormTableCell *cell in visibleCellList) {
        [cell.textField resignFirstResponder];
    }
    
    NSString *corpIdSTR = ((FormTableCell *)[visibleCellList objectAtIndex:0]).textField.text;
    NSString *opratorIdSTR = ((FormTableCell *)[visibleCellList objectAtIndex:1]).textField.text;
    NSString *passSTR = ((FormTableCell *)[visibleCellList objectAtIndex:2]).textField.text;
    
    //校验合规
    if ([Helper stringNullOrEmpty:corpIdSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"机构号为空，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([corpIdSTR rangeOfString:@"6"].location != 0){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"机构号有误，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return ;
    }
    
    if ([Helper stringNullOrEmpty:opratorIdSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"操作员号为空，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([Helper containInvalidChar:opratorIdSTR]){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"操作员号有误，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if ([Helper stringNullOrEmpty:passSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"密码为空，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([Helper containInvalidChar:passSTR]){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"密码有误，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000013"];
    
    ACUser *usr = [[[ACUser alloc] init] autorelease];
    usr.instSTR = corpIdSTR;
    usr.opratorSTR = opratorIdSTR;
    usr.passSTR = passSTR;
    usr.state = USER_STATE_UNKNOWN;
    [Acquirer sharedInstance].currentUser = usr;
    
    ((FormTableCell *)[visibleCellList objectAtIndex:2]).textField.text = @"";
    
    [[AcquirerService sharedInstance].logService onRespondTarget:self];
    [[AcquirerService sharedInstance].logService requestForLogin];
}

-(void)LoginForActivate:(NSString *)mobileSTR{
    ActivateViewController *activateCTRL = [[[ActivateViewController alloc] init] autorelease];
    activateCTRL.CTRLType = ACTIVATE_FIRST_CONFIRM;
    activateCTRL.mobileSTR = mobileSTR;
    [self.navigationController pushViewController:activateCTRL animated:YES];
}

-(void)notLogin:(id)sender{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000001"];
    
    ValiIdentityViewController *valiIdentityCTRL = [[[ValiIdentityViewController alloc] init] autorelease];
    [self.navigationController pushViewController:valiIdentityCTRL animated:YES];
}

//接收激活通知
- (void)userDoActivate:(NSNotification *)notification
{
    NSDictionary *body = notification.object;
    if(NotNil(body, @"mobile"))
    {
        NSString *mobile = [body objectForKey:@"mobile"];
        ActivateViewController *activateCTRL = [[ActivateViewController alloc] init];
        activateCTRL.CTRLType = ACTIVATE_FIRST_CONFIRM;
        activateCTRL.mobileSTR = mobile;
        [self.navigationController pushViewController:activateCTRL animated:YES];
        [activateCTRL release];
    }
}

@end
