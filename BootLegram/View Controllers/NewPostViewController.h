//
//  NewPostViewController.h
//  BootLegram
//
//  Created by Clara Kim on 7/7/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN
@protocol NewPostViewControllerDelegate

- (void)didPost;

@end

@interface NewPostViewController : UIViewController
@property (weak, nonatomic)id<NewPostViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
