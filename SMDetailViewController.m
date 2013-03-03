//
//  SMDetailViewController.m
//  SM_RSS_Reader
//
//  Created by Jamie Thomason on 3/2/13.
//  Copyright (c) 2013 Solstice Mobile. All rights reserved.
//

#import "SMDetailViewController.h"
#import "NSString+HTML.h"

@interface SMDetailViewController ()

@end

@implementation SMDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set delegate for webview
    _myWebView.delegate = self;

    // Prepare URL request for webview
    NSString* loadString = _urlString;
    NSLog(@"loadstring = %@", loadString);
    NSURL* url=[NSURL URLWithString:loadString];
    NSURLRequest* request=[NSURLRequest requestWithURL:url];
    [_myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"error = %@", error);
}

@end
