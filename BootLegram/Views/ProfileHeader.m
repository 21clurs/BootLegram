//
//  ProfileHeader.m
//  BootLegram
//
//  Created by Clara Kim on 7/10/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ProfileHeader.h"

@implementation ProfileHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    ProfileHeader *header =  [super initWithReuseIdentifier:reuseIdentifier];
    
    if(self.profilePicView == nil){
        self.profilePicView = [[PFImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    }
    if(PFUser.currentUser[@"profileImage"]){
        self.profilePicView.file = PFUser.currentUser[@"profileImage"];
    }
    else{
        self.profilePicView.image = [UIImage imageNamed:@"default_profile_image"];
    }
    [self.profilePicView loadInBackground];
    self.profilePicView.layer.cornerRadius = 40;
    self.profilePicView.layer.masksToBounds = YES;
    [self.profilePicView setUserInteractionEnabled:YES];
    
    if(self.nameLabel == nil){
        CGRect labelFrame = CGRectMake(20, 108, 280, 20);
        self.nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
    }
    self.nameLabel.text = PFUser.currentUser.username;
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.nameLabel.textAlignment =  NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor blackColor];
    
    [header.contentView addSubview:self.profilePicView];
    [header.contentView addSubview:self.nameLabel];
    
    return header;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
