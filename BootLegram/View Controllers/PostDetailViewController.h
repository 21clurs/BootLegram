//
//  PostDetailViewController.h
//  BootLegram
//
//  Created by Clara Kim on 7/8/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostDetailViewController : UIViewController
@property (strong,nonatomic)Post *post;

@end

NS_ASSUME_NONNULL_END
