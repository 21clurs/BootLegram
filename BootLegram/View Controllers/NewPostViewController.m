//
//  NewPostViewController.m
//  BootLegram
//
//  Created by Clara Kim on 7/7/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "NewPostViewController.h"
#import "UIKit/UIKit.h"
#import "Post.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation NewPostViewController

#pragma mark - Private Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captionTextView.delegate = self;
    self.captionTextView.text = @"Write a caption";
    self.captionTextView.textColor = [UIColor lightGrayColor];
    
    self.photoView.userInteractionEnabled = YES;
    
}
- (IBAction)onTapAway:(id)sender {
    [self.captionTextView endEditing:YES];
}

- (IBAction)didTapShare:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.photoView.image != nil){
        NSString *captionText = self.captionTextView.text;
        if([captionText isEqualToString:@"Write a caption"]){
            captionText = @"";
        }
        
        __weak typeof(self) weakSelf = self;
        [Post postUserImage:self.photoView.image withCaption:captionText withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            __strong typeof(self) strongSelf = weakSelf;
            if(error){
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                NSLog(@"Error sharing: %@", error.localizedDescription);
            }
            else{
                //[self.tabBarController setSelectedIndex:0];
                [strongSelf.delegate didPost];
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Sharing" message:@"Please select or take a photo to share your post" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
    }
}
- (IBAction)onTapAddImage:(id)sender {
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

# pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGSize size = CGSizeMake(500, 500);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    self.photoView.image = resizedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a caption"]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
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
