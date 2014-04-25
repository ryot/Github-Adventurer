//
//  RTSocialCollectionViewController.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/24/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTSocialCollectionViewController.h"
#import "GithubUser.h"
#import "RTGithubUserCollectionViewCell.h"
#import "RTUserDetailViewController.h"

@interface RTSocialCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UserImageDownloadDelegate, RTRootMenuButtonProtocol>

@property (nonatomic, strong) NSMutableArray *users;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation RTSocialCollectionViewController

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
    _downloadQueue = [NSOperationQueue new];
    // Do any additional setup after loading the view.
}

- (IBAction)handleRootButtonPressed:(id)sender {
    [self.rootDelegate handleRootButtonPressed];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _users.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTGithubUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GithubUserCell" forIndexPath:indexPath];
    GithubUser *user = _users[indexPath.row];
    cell.textLabel.text = user.login;
    
    if (user.avatar)
    {
        cell.imageView.image = user.avatar;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"burgerbutton"];
        [user downloadAvatarOnQueue:_downloadQueue withCompletionBlock:^{
            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
    
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getUsersForQuery:searchBar.text];
    [self.view endEditing:YES];
}

- (void)getUsersForQuery:(NSString *)query
{
    NSOperationQueue *downloadQueue = [NSOperationQueue new];
    [downloadQueue addOperationWithBlock:^{
        
        NSString *searchURLString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", query];
        NSURL *searchURL = [NSURL URLWithString:searchURLString];
        NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
        
        NSDictionary *searchDict = [NSJSONSerialization JSONObjectWithData:searchData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
        NSMutableArray *tempUsers = [NSMutableArray new];
        for (NSDictionary *user in searchDict[@"items"]) {
            GithubUser *downloadedUser = [[GithubUser alloc] initWithJSON:user];
            downloadedUser.downloadDelegate = self;
            [tempUsers addObject:downloadedUser];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _users = tempUsers;
            [self.collectionView reloadData];
        }];
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    RTUserDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"userDetailVC"];
    detail.title = @"User";
    detail.thisUser = [self.users objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    GithubUser *user = self.users[indexPath.row];
    if (!user.avatar)
    {
        [user cancelAvatarDownload];
    }
}

-(void)userImageDoneDownloading:(id)thisCell
{
    [self.collectionView reloadData];
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
