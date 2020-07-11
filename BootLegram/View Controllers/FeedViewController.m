//
//  FeedViewController.m
//  BootLegram
//
//  Created by Clara Kim on 7/7/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "PostCell.h"
#import "PostDetailViewController.h"
#import "NewPostViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NewPostViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Post *> *posts;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@end

@implementation FeedViewController

#pragma mark - Private Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self getFeed];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error Logging Out: %@", error.localizedDescription);
        }
    }];
}

- (void) getFeed{
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    // fetch data asynchronously
    __weak typeof(self) weakSelf = self;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (posts) {
            // do something with the data fetched
            strongSelf.posts = [posts mutableCopy];
            [strongSelf.tableView reloadData];
        }
        else {
            // handle error
            NSLog(@"Error getting posts");
        }
    }];
    [self.refreshControl endRefreshing];
}

- (void) loadMorePosts{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    postQuery.skip += 20;

    __weak typeof(self) weakSelf = self;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable morePosts, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (morePosts) {
            [strongSelf.posts addObjectsFromArray:morePosts];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.tableView reloadData];
        }
        else {
            NSLog(@"Error getting more posts");
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }
    }];
    [self.refreshControl endRefreshing];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.post = self.posts[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            [self loadMorePosts];
        }
        
    }
}
#pragma mark - ComposeViewControllerDelegate

- (void)didPost{
    [self getFeed];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        PostDetailViewController *postDetailViewController = (PostDetailViewController *)[navigationController topViewController];
        
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        postDetailViewController.post = post;
    }
    else if([segue.identifier isEqualToString:@"newPostSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        NewPostViewController *newPostViewController =(NewPostViewController *)[navigationController topViewController];
        newPostViewController.delegate = self;
    }
}


@end
