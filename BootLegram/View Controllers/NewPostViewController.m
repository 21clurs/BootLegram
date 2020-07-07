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

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation NewPostViewController

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
    if (self.photoView.image != nil){
        NSString *captionText = self.captionTextView.text;
        if([captionText isEqualToString:@"Write a caption"]){
            captionText = @"";
        }
        [Post postUserImage:self.photoView.image withCaption:captionText withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error)
                NSLog(@"Error sharing: %@", error.localizedDescription);
            else{
                [self.tabBarController setSelectedIndex:0];
                
                // CHANGE THIS LATER IF YOU DO MODALLY INSTEAD
            }
        }];
    }
    else{
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
    // Do any additional setup after loading the view.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGSize size = CGSizeMake(500, 500);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    
    self.photoView.image = resizedImage;
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a caption"]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption";
        textView.textColor = [UIColor lightGrayColor]; //optional
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
