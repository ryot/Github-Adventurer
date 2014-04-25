//
//  RTRepoTableViewController.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 3/17/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTSearchTableViewController.h"
#import "Repo.h"
#import "RTRepoDetailViewController.h"

@interface RTSearchTableViewController () <UISearchBarDelegate, RepoImageDownloadDelegate>

@property (nonatomic, strong) NSMutableArray *repos;

@end

@implementation RTSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleRootButtonPressed:(id)sender {
    [self.rootDelegate handleRootButtonPressed];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _repos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    Repo *repo = _repos[indexPath.row];
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.description;
    cell.imageView.image = repo.authorAvatar;
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getReposForQuery:searchBar.text];
    [self.view endEditing:YES];
}

- (void)getReposForQuery:(NSString *)query
{
    NSOperationQueue *downloadQueue = [NSOperationQueue new];
    [downloadQueue addOperationWithBlock:^{
        
        NSString *searchURLString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", query];
        NSURL *searchURL = [NSURL URLWithString:searchURLString];
        NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
        
        NSDictionary *searchDict = [NSJSONSerialization JSONObjectWithData:searchData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
        NSMutableArray *tempRepos = [NSMutableArray new];
        for (NSDictionary *repo in [searchDict objectForKey:@"items"]) {
            Repo *downloadedRepo = [[Repo alloc] initWithJSON:repo isUserRepo:NO];
            downloadedRepo.downloadDelegate = self;
            [tempRepos addObject:downloadedRepo];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _repos = tempRepos;
            [self.tableView reloadData];
        }];
        
    }];
}

-(void)repoImageDoneDownloading:(id)thisRepo
{
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    RTRepoDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"repoDetailVC"];
    detail.title = @"Repo";
    detail.thisRepo = [self.repos objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        RTRepoDetailViewController *detail = segue.destinationViewController;
        NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
        detail.thisRepo = [self.repos objectAtIndex:selectedRow];
    }
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
