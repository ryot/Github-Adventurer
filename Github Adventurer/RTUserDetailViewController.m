//
//  RTUserDetailViewController.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/24/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTUserDetailViewController.h"

@interface RTUserDetailViewController () <UIWebViewDelegate>

@end

@implementation RTUserDetailViewController

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

    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setThisUser:(GithubUser *)newUser
{
    if (_thisUser != newUser) {
        _thisUser = newUser;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.thisUser.html_url) {
        if (!self.thisUser.htmlCache) {
            NSData *cacheData = [NSData dataWithContentsOfURL:_thisUser.html_url];
            NSString *cacheString = [[NSString alloc] initWithData:cacheData encoding:NSUTF8StringEncoding];
            _thisUser.htmlCache = cacheString;
            [self configureView];
        } else {
            NSOperationQueue *pageLoadQueue = [NSOperationQueue new];
            [pageLoadQueue addOperationWithBlock:^{
                [_userWebView loadHTMLString:_thisUser.htmlCache baseURL:nil];
            }];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
