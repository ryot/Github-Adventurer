//
//  RTRootMenuVC.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/21/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTRootMenuVC.h"
#import "RTSearchTableViewController.h"
#import "RTUserViewController.h"
#import "RTSocialCollectionViewController.h"
#import "RTRootMenuButtonProtocol.h"


@interface RTRootMenuVC () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, RTRootMenuButtonProtocol>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) BOOL menuOpen;

@end

@implementation RTRootMenuVC

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
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.userInteractionEnabled = NO;
    
    [self setupViewControllers];
    [self setupPanRecognizer];
}

-(void)setupViewControllers
{
    RTUserViewController *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userVC"];
    userVC.title = @"App User";
    userVC.rootDelegate = self;
    
    UINavigationController *searchSocialNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchSocialNavController"];
    RTSocialCollectionViewController *socialVC = [[searchSocialNavController childViewControllers] firstObject];
    socialVC.title = @"Social Search";
    socialVC.rootDelegate = self;
    
    UINavigationController *searchReposNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchReposNavController"];
    RTSearchTableViewController *searchVC = [[searchReposNavController childViewControllers] firstObject];
    searchVC.title = @"Repo Search";
    searchVC.rootDelegate = self;
    
    _viewControllers = @[userVC, searchSocialNavController, searchReposNavController];
    
    _topViewController = _viewControllers.firstObject;
    
    [self addChildViewController:_topViewController];
    [self.view addSubview:_topViewController.view];
    [_topViewController didMoveToParentViewController:self];
}

-(void)setupPanRecognizer
{
    [self.view removeGestureRecognizer:_panRecognizer];
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    _panRecognizer.minimumNumberOfTouches = 1;
    _panRecognizer.maximumNumberOfTouches = 1;
    _panRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panRecognizer];
}

-(void)movePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint translatedPoint = [pan translationInView:self.view];
    //CGPoint velocity = [pan velocityInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (translatedPoint.x > 0) {
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
            [pan setTranslation:CGPointZero inView:self.view];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3) {
            [self openRootMenu];
        } else {
            [UIView animateWithDuration:0.4 animations:^{
                self.topViewController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}

-(void)switchToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.2 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        CGRect offScreen = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        [self.topViewController removeFromParentViewController];
        self.topViewController = self.viewControllers[indexPath.row];
        [self addChildViewController:self.topViewController];
        self.topViewController.view.frame = offScreen;
        [self.view addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        [self closeRootMenu:nil];
    }];
}

-(void)openRootMenu
{
    [UIView animateWithDuration:0.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * 0.75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeGestureRecognizer:_tapRecognizer];
            self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeRootMenu:)];
            [self.topViewController.view addGestureRecognizer:self.tapRecognizer];
            self.menuOpen = YES;
            self.menuTableView.userInteractionEnabled = YES;
        }
    }];
}

-(void)closeRootMenu:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.topViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [_topViewController.view removeGestureRecognizer:self.tapRecognizer];
        self.menuOpen = NO;
    }];
}

-(void)handleRootButtonPressed
{
    if (self.menuOpen) {
        [self closeRootMenu:nil];
    } else {
        [self openRootMenu];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.viewControllers[indexPath.row] title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchToViewControllerAtIndexPath:(indexPath)];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
