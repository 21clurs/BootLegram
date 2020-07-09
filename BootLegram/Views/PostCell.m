//
//  PostCell.m
//  BootLegram
//
//  Created by Clara Kim on 7/8/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setPost:(Post *)post{
    _post = post;
    
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", post.likeCount];
    self.authorLabel.text = post.author.username;
    self.authorLowerLabel.text = post.author.username;
    self.captionLabel.text = post.caption;
    
    self.photoView.file = post.image;
    [self.photoView loadInBackground];
    
    if(post.author[@"profileImage"]){
        self.profilePhotoView.file = post.author[@"profileImage"];
        [self.profilePhotoView loadInBackground];
    }
}

@end
