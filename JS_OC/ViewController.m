//
//  ViewController.m
//  JS_OC
//
//  Created by Victor on 2017/8/15.
//  Copyright © 2017年 Victor Du. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@protocol JSObjcDelegate <JSExport>
//方法一
- (void)share:(NSString *)shareString;
@end

@interface ViewController ()<UIWebViewDelegate,JSObjcDelegate>

@property(nonatomic, strong) JSContext *jsContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    webView.delegate = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"jscalloc" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    
    /*
     JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
     NSString *textJS = @"showAlert('调用js')";，将showAlert定义成js的function即可
     [context evaluateScript:textJS];
     */
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //开始加载html
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    //加载出错
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //加载完毕
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //方法一
    self.jsContext[@"resultForApp"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    
    
    //此为方法二
    self.jsContext[@"share"] = ^() {
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
        
    };
    
    
}
#pragma mark - 方法一JS回调
- (void)share:(NSString *)result{
    NSLog(@"方法一js调用oc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
