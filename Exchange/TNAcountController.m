//
//  TNAcountController.m
//  Exchange
//
//  Created by Terry on 3/18/16.
//  Copyright © 2016 Terry. All rights reserved.
//

#import "TNAcountController.h"

@interface TNAcountController ()

@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *errorInfo;
@property (weak, nonatomic) NSString *errorMsg;

@property (weak, nonatomic) IBOutlet UITextField *signUpUsername;
@property (weak, nonatomic) IBOutlet UITextField *signUpPassword;
@property (weak, nonatomic) IBOutlet UITextField *signUpVerifyPassword;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@end

@implementation TNAcountController

- (void)viewDidLoad {
    [super viewDidLoad];
    _password.secureTextEntry = YES;
    NSLog(@"%@",self.view.subviews);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    if([_account.text rangeOfString:@" "].location != NSNotFound || [_account.text isEqualToString:@""] ) {
        _errorMsg = @"用户名包含非法字符!";
        [self handleError:_errorMsg];
    }else if([_password.text isEqualToString:@""]){
        _errorMsg = @"请输入密码!";
        [self handleError:_errorMsg];
    }else {
        NSString *urlStr = [NSString stringWithFormat:@"http://119.29.156.162:8000/?username=%@&password=%@",_account.text,_password.text];
        NSURL *url = [NSURL URLWithString:urlStr];
        dispatch_async(dispatch_queue_create("signin.com.terrynie", DISPATCH_QUEUE_CONCURRENT), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSError *error ;
            NSDictionary *json;
            //将数据解析为json
            @try {
                json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            }
            @catch (NSException *exception) {
                _errorMsg = @"貌似网络开了小车。。。";
                [self handleError:_errorMsg];
            }

            if ([[json objectForKey:@"login"] isEqualToString:@"true"]) {
                //登录成功
                NSLog(@"登录成功");
                
                
            }else {
                //登录失败
                NSLog(@"登录失败");
            }
            
        });
        
    }
    
}


- (IBAction)signUpAcount:(id)sender {
    if([_signUpUsername.text rangeOfString:@" "].location != NSNotFound || [_signUpUsername.text isEqualToString:@""] ) {
        _errorMsg = @"用户名包含非法字符!";
        [self handleError:_errorMsg];
    }else if([_signUpPassword.text isEqualToString:@""]){
        _errorMsg = @"请输入密码!";
        [self handleError:_errorMsg];
    }else if(![_signUpPassword.text isEqualToString:_signUpVerifyPassword.text]){
        _errorMsg = @"两次输入密码不一致!";
        [self handleError:_errorMsg];
    }else if([_email.text isEqualToString:@""]&& [_phoneNumber.text isEqualToString:@""]){
        _errorMsg = @"请输入邮箱或手机号码！";
        [self handleError:_errorMsg];
    }else {
        NSString *urlStr = [NSString stringWithFormat:@"http://119.29.156.162:8000/signup?username=%@&password=%@&email=%@&phonenumber=%@",_signUpUsername.text,_signUpPassword.text,_email.text,_phoneNumber.text];
        //在后台线程进行注册请求
        dispatch_async(dispatch_queue_create("com.terrynie.signup", DISPATCH_QUEUE_CONCURRENT), ^{
           
        });
    }
    
}


- (IBAction)signUp:(id)sender {
    [[self.view.subviews objectAtIndex:self.view.subviews.count-3] setHidden:YES];
    [[self.view.subviews objectAtIndex:self.view.subviews.count-4] setHidden:NO];
}

/**
 隐藏通知
 */
- (void)hidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        _errorInfo.hidden = YES;
    });
}

/**
 弹出提示
 */
- (void)handleError:(NSString *)errorMsg {
    _errorInfo.text = errorMsg;
    _errorInfo.hidden = NO;
    //2秒后隐藏
    dispatch_async(dispatch_queue_create("show", DISPATCH_QUEUE_CONCURRENT), ^{
        [NSThread sleepForTimeInterval:1.5];
//        [self hidden];
        dispatch_async(dispatch_get_main_queue(), ^{
            _errorInfo.hidden = YES;
        });
    });
}




@end
