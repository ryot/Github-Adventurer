//
//  RTUserViewController.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/21/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTUserViewController.h"
#import "Repo.h"
#import "RTNetworkController.h"
#import "RTUserData.h"
#import "RTRepoDetailViewController.h"

@interface RTUserViewController () <UITableViewDelegate, UITableViewDataSource, RTNetworkControllerOAuthDelegate>

@property (weak, nonatomic) RTNetworkController *networkController;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *reposTableView;
@property (strong, nonatomic, readonly) RTUserData *userData;

@end

@implementation RTUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _reposTableView.layer.borderWidth = 2;
    _reposTableView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [[RTNetworkController shared] setDelegate:self];
    if ([RTNetworkController shared].token) {
        [self didSetOAuthToken];
    }
}

- (IBAction)handleRootButtonPressed:(id)sender {
    [self.rootDelegate handleRootButtonPressed];
}

- (IBAction)authButtonPressed:(UIButton *)sender {
    if ([RTNetworkController shared].token) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Authorized" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else { //get auth
        [[RTNetworkController shared] requestOAuthAccessWithParameters:@[@"user"]];
    }
}

-(void)didSetOAuthToken
{
    [[RTNetworkController shared] getUserInfoWithCompletion:^{
        _usernameLabel.text = self.userData.userDict[@"login"];
        [_usernameLabel sizeToFit];
        [[RTNetworkController shared] getUserReposWithCompletion:^{
            [_reposTableView reloadData];
        }];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userData.userReposArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.reposTableView dequeueReusableCellWithIdentifier:@"UserRepoCell" forIndexPath:indexPath];
    Repo *thisRepo = self.userData.userReposArray[indexPath.row];
    cell.textLabel.text = thisRepo.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_reposTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(RTUserData *)userData {
    return [RTUserData shared];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
