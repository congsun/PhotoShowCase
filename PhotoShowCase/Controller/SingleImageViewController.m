//
//  SingleImageViewController.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/25/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "SingleImageViewController.h"
#import "PhotoObject.h"
#import "APIClient.h"

@interface SingleImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *aSpinner;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation SingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapped:)];
    [self.imageView addGestureRecognizer:tapGesRecog];
    self.imageView.userInteractionEnabled = YES;
}

-(UIActivityIndicatorView *)aSpinner{
    if (!_aSpinner) {
        _aSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _aSpinner.frame = CGRectMake(self.view.frame.size.width/2-12, self.view.frame.size.height/2-12, 24, 24);
        [self.view addSubview:_aSpinner];
    }
    return _aSpinner;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.descriptionLabel.text = self.photoObject.captain;
    if(self.photoObject.originImage){
        self.imageView.image = self.photoObject.originImage;
    }else{
        [self.aSpinner startAnimating];
        [self.view addSubview:self.aSpinner];
        [APIClient getImageWithUrl:self.photoObject.originImageUrl WithCompletion:^(BOOL isSuccess, UIImage *image) {
            [self.aSpinner stopAnimating];
            if (isSuccess) {
                self.photoObject.originImage = image;
                self.imageView.image = image;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)imageViewTapped:(UIGestureRecognizer *)sender {
    [self dismissSingleImageController];
}


-(void)dismissSingleImageController{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)displayActivityViewController{
    NSArray *activityItems;
    if (self.photoObject.thumbImage) {
        activityItems = @[self.photoObject.captain,self.photoObject.originImageUrl,self.photoObject.thumbImage];
    }else{
        activityItems = @[self.photoObject.captain,self.photoObject.originImageUrl];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        //iPhone
        [self presentViewController:activityVC animated:YES completion:nil];
    }else{
        //iPad
    }
}
- (IBAction)moreButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"More" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveToCameraRollAction = [UIAlertAction actionWithTitle:@"Save to Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.photoObject.originImage) {
            UIImageWriteToSavedPhotosAlbum(self.photoObject.originImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wait..." message:@"Please Wait For the Finish of the Download" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    [alertController addAction:saveToCameraRollAction];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayActivityViewController];
    }];
    [alertController addAction:shareAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo{
    UIAlertController *alertController;
    if(error){
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Try Again Later" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        alertController = [UIAlertController alertControllerWithTitle:@"Success!" message:@"The image has been successfully saved to the camera roll" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
