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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoView.image = nil;
    self.photoView.file = self.post.image;
    [self.photoView loadInBackground];
    
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
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
    
    [self setHeart];
}

- (void) setHeart{
    if(PFUser.currentUser[@"likesArray"] != nil && [PFUser.currentUser[@"likesArray"] containsObject:self.post.objectId]){
        self.heartView.image = [UIImage systemImageNamed:@"heart.fill"];
        self.heartView.tintColor = [UIColor redColor];
    }
    else{
        self.heartView.image = [UIImage systemImageNamed:@"heart"];
        self.heartView.tintColor = [UIColor blackColor];
    }
}

- (void) reloadData{
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
    [self setHeart];
}

- (IBAction)onDoubleTap:(id)sender {
    NSMutableArray *tempLikesArray = [[NSMutableArray<NSString *> alloc] init];
    
    if(PFUser.currentUser[@"likesArray"] != nil){
        //tempLikesArray = PFUser.currentUser[@"likesArray"];
    }
    
    if ([tempLikesArray containsObject:self.post.objectId]){
        NSLog(@"Don't like the same thing twice");
    }
    
    // Note to self: ask about this! blocks within blocks seems like a bad idea...
    else{
        [tempLikesArray addObject:self.post.objectId];
        PFUser.currentUser[@"likesArray"] = tempLikesArray;
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error!=nil){
                NSLog(@"Error saving post to User's likes");
            }
            else{
                self.post.likeCount = @([self.post.likeCount floatValue] + 1);
                [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error!=nil){
                        NSLog(@"Error updating Post's like count");
                    }
                    else{
                        [self reloadData];
                    }
                }];
            }
        }];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
