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
