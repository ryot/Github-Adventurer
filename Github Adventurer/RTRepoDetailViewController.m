//
//  RTRepoDetailViewController.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 3/17/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTRepoDetailViewController.h"

@interface RTRepoDetailViewController () <UIWebViewDelegate>

@end

@implementation RTRepoDetailViewController

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
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setThisRepo:(Repo *)newRepo
{
    if (_thisRepo != newRepo) {
        _thisRepo = newRepo;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.thisRepo.html_url) {
        if (!self.thisRepo.htmlCache) {
            NSData *cacheData = [NSData dataWithContentsOfURL:_thisRepo.html_url];
            NSString *cacheString = [[NSString alloc] initWithData:cacheData encoding:NSUTF8StringEncoding];
            _thisRepo.htmlCache = cacheString;
            [self configureView];
        } else {
            [_repoWebView loadHTMLString:_thisRepo.htmlCache baseURL:nil];
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
