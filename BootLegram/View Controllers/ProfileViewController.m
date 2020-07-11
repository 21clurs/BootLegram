//
//  ProfileViewController.m
//  BootLegram
//
//  Created by Clara Kim on 7/8/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCell.h"
#import "Post.h"
#import "ProfileHeader.h"

@import Parse;

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Post *> *posts;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet PFImageView *profilePicView;

@end

@implementation ProfileViewController

NSString *CellIdentifier = @"TableViewCell";
NSString *HeaderViewIdentifier = @"TableViewHeaderView";

#pragma mark - Private Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[ProfileHeader class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
    
    [self getPosts];
}

- (void) getPosts{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    __weak typeof(self) weakSelf = self;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (posts) {
            strongSelf.posts = [posts mutableCopy];
            [strongSelf.tableView reloadData];
        }
        else {
            NSLog(@"Error getting profile posts");
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (IBAction)didTap:(UITapGestureRecognizer *)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize size = CGSizeMake(200, 200);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    PFUser.currentUser[@"profileImage"] = [PFFileObject fileObjectWithName:@"profile_image.png" data:imageData];
    
    __weak typeof(self) weakSelf = self;
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error != nil){
            NSLog(@"Error updating profile image");
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            //[self.tableView reloadData];
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ProfileHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [header.profilePicView addGestureRecognizer:tapGestureRecognizer];
    
    return header;
    /*
    for(UIView * view in header.subviews){
        if(![view isEqual:header.contentView])
            [view removeFromSuperview];
    }
    
    PFImageView *profilePicView = [[PFImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    if(PFUser.currentUser[@"profileImage"]){
        profilePicView.file = PFUser.currentUser[@"profileImage"];
    }
    else{
        profilePicView.image = [UIImage imageNamed:@"default_profile_image"];
    }
    [profilePicView loadInBackground];
    
    profilePicView.layer.cornerRadius = 40;
    profilePicView.layer.masksToBounds = YES;
    
    [profilePicView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [profilePicView addGestureRecognizer:tapGestureRecognizer];
    
    [header.contentView addSubview:profilePicView];
     
    CGRect labelFrame = CGRectMake(20, 108, self.tableView.contentSize.width, 20);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
    nameLabel.text = PFUser.currentUser.username;
    nameLabel.numberOfLines = 1;
    nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    nameLabel.textAlignment =  NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    [header.contentView addSubview:nameLabel];
    */
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 140;
    // Don't love that this is hard coded
}

@end
