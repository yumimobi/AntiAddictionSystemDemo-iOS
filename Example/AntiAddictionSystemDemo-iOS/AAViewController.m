//
//  AAViewController.m
//  AntiAddictionSystem
//
//  Created by wzy2010416033@163.com on 04/21/2020.
//  Copyright (c) 2020 wzy2010416033@163.com. All rights reserved.
//

#import "AAViewController.h"
#import <AntiAddictionSystem/AATools.h>
#import <AntiAddictionSystem/AAPrivacyPolicyViewController.h>
#import <AntiAddictionSystem/AALoginViewController.h>
#import <AntiAddictionSystem/AAUserAuthenticationViewController.h>
#import <AntiAddictionSystem/AAWarningViewController.h>
#import <AntiAddictionSystem/AANotification.h>
#import <AntiAddictionSystem/AALogin.h>
#import <AntiAddictionSystem/AAPayNumberReport.h>
#import <AntiAddictionSystem/RPProgressHUD.h>
#import <Masonry/Masonry.h>

@interface AAViewController ()<AANotificationDelegate>
@property (nonatomic) UIButton *showLoginVc;
@property (nonatomic) UIButton *showAuthVc;
@property (nonatomic) UIButton *showWarningButton;
@property (nonatomic) UIButton *thirdPlatformLogin;
@property (nonatomic) UIButton *loginOutButton;
@property (nonatomic) UITextField *payNumberText;
@property (nonatomic) UIButton *payNumberCheck;
@property (nonatomic) UIButton *paySuccess;
@property (nonatomic) UIView *mask;
@property (nonatomic) UITextView *console;

@property (nonatomic) AAPrivacyPolicyViewController *privacyPolicyVC;
@property (nonatomic) AALoginViewController *loginVc;
@property (nonatomic) AAUserAuthenticationViewController *authVc;
@property (nonatomic) AAWarningViewController *warningVc;
@property (nonatomic) AALogin *loginManager;
@property (nonatomic) AAPayNumberReport *payReport;
@end

@implementation AAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [AANotification shared].delegate = self;
    [self setUpUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [self showPrivacyPolicyViewController];
}

- (void)showPrivacyPolicyViewController {
    self.privacyPolicyVC = [[AAPrivacyPolicyViewController alloc] init];
    [self.privacyPolicyVC showPrivacyPolicyViewWithRootViewController:self];
}

- (void)setUpUI {
    AATools *tool = [AATools sharedTool];
    CGFloat margin = [tool adaptedValue6:10];
    CGFloat topMargin = 20;
    if ([tool isiPhoneX]) {
        topMargin = topMargin + kIPHONEXSTATUSBAR;
    }
    if ([tool isiPhoneXR]) {
        topMargin = topMargin + kIPHONEXRSTATUSBAR;
    }
    
    self.showLoginVc = [[UIButton alloc] init];
    [self.showLoginVc addTarget:self action:@selector(showLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    self.showLoginVc.backgroundColor = [UIColor blackColor];
    self.showLoginVc.layer.cornerRadius = 8;
    self.showLoginVc.layer.masksToBounds = YES;
    [self.showLoginVc setTitle:@"展示登录界面" forState:UIControlStateNormal];
    CGSize showLoginSize = [self.showLoginVc.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.showLoginVc.titleLabel.font,NSFontAttributeName,nil]];
    [self.view addSubview:self.showLoginVc];
    [self.showLoginVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(topMargin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(showLoginSize.width, showLoginSize.height));
    }];
    
    self.showAuthVc = [[UIButton alloc] init];
    [self.showAuthVc addTarget:self action:@selector(showAuthViewController) forControlEvents:UIControlEventTouchUpInside];
    self.showAuthVc.backgroundColor = [UIColor blackColor];
    self.showAuthVc.layer.cornerRadius = 8;
    self.showAuthVc.layer.masksToBounds = YES;
    [self.showAuthVc setTitle:@"展示实名认证界面" forState:UIControlStateNormal];
    CGSize authButtonSize = [self.showAuthVc.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.showAuthVc.titleLabel.font,NSFontAttributeName,nil]];
    [self.view addSubview:self.showAuthVc];
    [self.showAuthVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showLoginVc.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(authButtonSize.width, authButtonSize.height));
    }];
    
    self.showWarningButton = [[UIButton alloc] init];
    [self.showWarningButton addTarget:self action:@selector(showWarningViewController) forControlEvents:UIControlEventTouchUpInside];
    self.showWarningButton.backgroundColor = [UIColor blackColor];
    self.showWarningButton.layer.cornerRadius = 8;
    self.showWarningButton.layer.masksToBounds = YES;
    [self.showWarningButton setTitle:@"展示提示界面" forState:UIControlStateNormal];
    CGSize warningButtonSize = [self.showAuthVc.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.showAuthVc.titleLabel.font,NSFontAttributeName,nil]];
    [self.view addSubview:self.showWarningButton];
    [self.showWarningButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showAuthVc.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(warningButtonSize.width, warningButtonSize.height));
    }];
    
    self.thirdPlatformLogin = [[UIButton alloc] init];
    [self.thirdPlatformLogin addTarget:self action:@selector(thirdPlatFormLoginRequest) forControlEvents:UIControlEventTouchUpInside];
    self.thirdPlatformLogin.backgroundColor = [UIColor blackColor];
    self.thirdPlatformLogin.layer.cornerRadius = 8;
    self.thirdPlatformLogin.layer.masksToBounds = YES;
    [self.thirdPlatformLogin setTitle:@"三方平台登录" forState:UIControlStateNormal];
    CGSize thirdPlatformLoginSize = [self.thirdPlatformLogin.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.thirdPlatformLogin.titleLabel.font,NSFontAttributeName,nil]];
    [self.view addSubview:self.thirdPlatformLogin];
    [self.thirdPlatformLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showWarningButton.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(thirdPlatformLoginSize.width, thirdPlatformLoginSize.height));
    }];
    
    self.loginOutButton = [[UIButton alloc] init];
    [self.loginOutButton addTarget:self action:@selector(clickLoginOutButton) forControlEvents:UIControlEventTouchUpInside];
    self.loginOutButton.backgroundColor = [UIColor blackColor];
    self.loginOutButton.layer.cornerRadius = 8;
    self.loginOutButton.layer.masksToBounds = YES;
    [self.loginOutButton setTitle:@"注销用户" forState:UIControlStateNormal];
    CGSize loginOutButtonSize = [self.loginOutButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loginOutButton.titleLabel.font,NSFontAttributeName,nil]];
    [self.view addSubview:self.loginOutButton];
    [self.loginOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdPlatformLogin.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(loginOutButtonSize.width, loginOutButtonSize.height));
    }];
    
    self.payNumberText = [[UITextField alloc] init];
    self.payNumberText.backgroundColor = [UIColor blackColor];
    self.payNumberText.text = @"50";
    self.payNumberText.keyboardType = UIKeyboardTypeNumberPad;
    self.payNumberText.textAlignment = NSTextAlignmentCenter;
    self.payNumberText.textColor = [UIColor whiteColor];
    [self.view addSubview:self.payNumberText];
    [self.payNumberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginOutButton.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(200, loginOutButtonSize.height));
    }];
    
    self.payNumberCheck = [[UIButton alloc] init];
    [self.payNumberCheck addTarget:self action:@selector(payNumberCheckMethod) forControlEvents:UIControlEventTouchUpInside];
    self.payNumberCheck.backgroundColor = [UIColor blackColor];
    self.payNumberCheck.layer.cornerRadius = 8;
    self.payNumberCheck.layer.masksToBounds = YES;
    [self.payNumberCheck setTitle:@"付费金额检查" forState:UIControlStateNormal];
    CGSize payNumberCheckSize = [self.payNumberCheck.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.payNumberCheck.titleLabel.font,NSFontAttributeName,nil]];
    [self.view addSubview:self.payNumberCheck];
    [self.payNumberCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payNumberText.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(payNumberCheckSize.width, payNumberCheckSize.height));
    }];
    
    self.paySuccess = [[UIButton alloc] init];
    [self.paySuccess addTarget:self action:@selector(paySuccessMethod) forControlEvents:UIControlEventTouchUpInside];
    self.paySuccess.backgroundColor = [UIColor blackColor];
    self.paySuccess.layer.cornerRadius = 8;
    self.paySuccess.layer.masksToBounds = YES;
    [self.paySuccess setTitle:@"支付成功上报" forState:UIControlStateNormal];
    CGSize paySuccessSize = [self.paySuccess.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.paySuccess.titleLabel.font,NSFontAttributeName,nil]];
    [self.view addSubview:self.paySuccess];
    [self.paySuccess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payNumberCheck.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(paySuccessSize.width, paySuccessSize.height));
    }];
    
    self.console = [[UITextView alloc] init];
    self.console.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.console];
    [self.console mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paySuccess.mas_bottom).with.offset(margin);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.8);
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)addLog:(NSString *)newLog {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.console.layoutManager.allowsNonContiguousLayout = NO;
        NSString *oldLog = weakSelf.console.text;
        NSString *text = [NSString stringWithFormat:@"%@\n%@", oldLog, newLog];
        if (oldLog.length == 0) {
            text = [NSString stringWithFormat:@"%@", newLog];
        }
        [weakSelf.console scrollRangeToVisible:NSMakeRange(text.length, 1)];
        weakSelf.console.text = text;
    });
}

- (void)paySuccessMethod {
    self.payReport = [[AAPayNumberReport alloc] init];
    [self.payReport reportNumberAfterPayment:[self.payNumberText.text integerValue]];
}

- (void)payNumberCheckMethod {
    self.payReport = [[AAPayNumberReport alloc] init];
    [self.payReport checkNumberLimitBeforePayment:[self.payNumberText.text integerValue]];
}

- (void)clickLoginOutButton {
    self.loginManager = [[AALogin alloc] init];
    [self.loginManager loginOut];
}

- (void)thirdPlatFormLoginRequest {
    self.loginManager = [[AALogin alloc] init];
    [self.loginManager loginWithPlatformToken:@"ddd" otherID:@"dd" platformName:@"wx"];
}

- (void)showAuthViewController {
    self.authVc = [[AAUserAuthenticationViewController alloc] init];
    [self.authVc showUserAuthenticationViewControllerWith:self];
}

- (void)showLoginViewController {
    self.loginVc = [[AALoginViewController alloc] init];
    // 展示登录界面
    [self.loginVc showLoginViewControllerWith:self];
}

- (void)showWarningViewController {
    self.warningVc = [[AAWarningViewController alloc] init];
    [self.warningVc showWarningViewController];
}

#pragma mark - notification delegate
// 隐私弹框已经展示
- (void)privacyPolicyViewControllerHasBeenShown {
    [self addLog:@"privacyPolicyViewControllerHasBeenShown"];
    NSLog(@"AA---privacyPolicyViewControllerHasBeenShown");
}
// 用户同意隐私政策
- (void)userAgreesToPrivacyPolicy {
    [self addLog:@"userAgreesToPrivacyPolicy"];
    NSLog(@"AA---userAgreesToPrivacyPolicy");
}

// 登录成功
- (void)loginSuccessWith:(NSString *)zplayKey {
    NSString *str = [[NSString alloc] initWithFormat:@"loginSuccess. zplayKey:%@",zplayKey];
    [self addLog:str];
    NSLog(@"AA---loginSuccess");
    if (self.mask) {
        [self.mask removeFromSuperview];
    }
}
// 登录失败
- (void)loginFail {
    [self addLog:@"loginFail"];
    NSLog(@"AA---loginFail");
}
// 开始展示用户登录界面
- (void)loginViewControllerHasBeenShown {
    [self addLog:@"loginViewControllerHasBeenShown"];
    NSLog(@"AA---loginViewControllerHasBeenShown");
}
// 登录界面消失
- (void)loginViewControllerHasBeenDismissed {
    [self addLog:@"loginViewControllerHasBeenDismissed"];
    NSLog(@"AA---loginViewControllerHasBeenDismissed");
}
// 注销登录
- (void)loginOutSuccessfull {
    [self addLog:@"loginOutSuccessfull"];
    NSLog(@"AA---loginOutSuccessful");
}

// 实名认证界面已经展示
- (void)userAuthVcHasBeenShown {
    [self addLog:@"userAuthVcHasBeenShown"];
    NSLog(@"AA---userAuthVcHasBeenShown");
}
// 实名认证成功
- (void)userAuthSuccessWithRemainTime:(NSNumber *)remainTime {
    NSString *str = [[NSString alloc] initWithFormat:@"userAuthSuccessWithRemainTime. remainTime:%@",remainTime];
    [self addLog:str];
    NSLog(@"AA---userAuthSuccess");
}

// warning vc已展示
- (void)warningVcHasBeenShown {
    [self addLog:@"warningVcHasBeenShown"];
    NSLog(@"AA---warningVcHasBeenShown");
    self.mask = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mask.backgroundColor = [UIColor blackColor];
    self.mask.alpha = 0.5;
    [self.view addSubview:self.mask];
}
// 用户在提示界面点击登录
- (void)userClickLoginButton {
    [self addLog:@"userClickLoginButton"];
    NSLog(@"AA---userClickLoginButton");
    [self showLoginViewController];
}
// 用户在提示界面点击退出游戏
- (void)userClickLoginOutButton {
    [self addLog:@"userClickLoginOutButton"];
    NSLog(@"AA---userClickLoginOutButton");
    if (self.mask) {
        [self.mask removeFromSuperview];
    }
}

// 用户在提示界面点击确定
- (void)userClickConfirmButton {
    [self addLog:@"userClickConfirmButton"];
    NSLog(@"AA---userClickConfirmButton");
    if (self.mask) {
        [self.mask removeFromSuperview];
    }
    RPProgressHUD *hud = [RPProgressHUD showHUDAddedTo:[[AATools sharedTool] topMostController].view animated:YES];
    hud.mode = RPProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"支付失败", @"HUD message title");
    [hud hideAnimated:YES afterDelay:1.f];
}

// 不可支付
- (void)paymentIsRestricted {
    [self addLog:@"paymentIsRestricted"];
    NSLog(@"AA---paymentIsRestricted");
}
// 可以支付
- (void)paymentUnlimited {
    [self addLog:@"paymentUnlimited"];
    NSLog(@"AA---paymentUnlimited");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.payNumberText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
