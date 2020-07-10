//
//  ProfileHeader.h
//  BootLegram
//
//  Created by Clara Kim on 7/10/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeader : UITableViewHeaderFooterView

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) PFImageView *profilePicView;

@end

NS_ASSUME_NONNULL_END
