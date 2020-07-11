//
//  PostDetailViewController.m
//  BootLegram
//
//  Created by Clara Kim on 7/8/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "PostDetailViewController.h"
#import "NSDate+DateTools.h"
@import Parse;

@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartView;


@end

@implementation PostDetailViewController

#pragma mark - Private Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoView.image = nil;
    self.photoView.file = self.post.image;
    [self.photoView loadInBackground];
    
    
    self.authorLabel.text = self.post.author.username;
    self.captionLabel.text = self.post.caption;
        
    NSDate *date = self.post.createdAt;
    
    if( [date hoursAgo]<1){
        self.timestampLabel.text = [NSString stringWithFormat:@"%.0f minutes ago",[date minutesAgo]];
    }
    else if([date daysAgo]<1){
        self.timestampLabel.text = [NSString stringWithFormat:@"%.0fh",[date hoursAgo]];
    }
    else if([date weeksAgo]<1){
        self.timestampLabel.text = [NSString stringWithFormat:@"%ld days ago",[date daysAgo]];
    }
    else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM d, yyyy";
        self.timestampLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    }
    
    [self reloadData];
}

- (void) reloadData{
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
    if(PFUser.currentUser[@"likesArray"] != nil && [PFUser.currentUser[@"likesArray"] containsObject:self.post.objectId]){
        self.heartView.image = [UIImage systemImageNamed:@"heart.fill"];
        self.heartView.tintColor = [UIColor redColor];
    }
    else{
        self.heartView.image = [UIImage systemImageNamed:@"heart"];
        self.heartView.tintColor = [UIColor blackColor];
    }
}

- (IBAction)onDoubleTap:(id)sender {
    NSMutableArray *tempLikesArray = [[NSMutableArray<NSString *> alloc] init];
    
    if(PFUser.currentUser[@"likesArray"] != nil){
        tempLikesArray = PFUser.currentUser[@"likesArray"];
    }
    
    if ([tempLikesArray containsObject:self.post.objectId]){
        NSLog(@"Don't like the same thing twice");
    }
    
    else{
        [tempLikesArray addObject:self.post.objectId];
        PFUser.currentUser[@"likesArray"] = tempLikesArray;

        // Note to self: ask about this! blocks within blocks seems like a bad idea...
        // But how else to ensure that both are successful?
        __weak typeof(self) weakSelf = self;
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            __strong typeof(self) strongSelf = weakSelf;
            if(error!=nil){
                NSLog(@"Error saving post to User's likes");
            }
            else{
                strongSelf.post.likeCount = @([strongSelf.post.likeCount floatValue] + 1);
                [strongSelf.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error!=nil){
                        NSLog(@"Error updating Post's like count");
                    }
                    else{
                        [strongSelf reloadData];
                    }
                }];
            }
        }];
        
    }
}

@end
