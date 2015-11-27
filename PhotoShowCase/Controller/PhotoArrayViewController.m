//
//  ViewController.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "PhotoArrayViewController.h"
#import "APIClient.h"
#import "PhotoCollectionCell.h"
#import "PhotoAlbum.h"
#import "PhotoObject.h"
#import "SingleImageViewController.h"
#import "NewCollectionViewLayout.h"

@interface PhotoArrayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NewCollectionViewLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *photoAlbumArray;
@end

@implementation PhotoArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NewCollectionViewLayout *layout = [[NewCollectionViewLayout alloc]init];
    layout.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.navigationItem.title = self.photoAlbum.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoAlbum.photoObjectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionCell *cell = (PhotoCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    PhotoObject *photoObject = self.photoAlbum.photoObjectArray[indexPath.row];
    cell.imageView.image = nil;
    if(photoObject.thumbImage){
        cell.imageView.image = photoObject.thumbImage;
    }else{
        [APIClient getImageWithUrl:photoObject.thumbImageUrl WithCompletion:^(BOOL isSuccess, UIImage *image) {
            if (isSuccess) {
                PhotoObject *photoObject = self.photoAlbum.photoObjectArray[indexPath.row];
                photoObject.thumbImage = image;
                PhotoCollectionCell *cellToUpdate = (PhotoCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                if(cellToUpdate){
                    cellToUpdate.imageView.image = image;
                }
            }
        }];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SingleImageViewController *destVC = [storyboard instantiateViewControllerWithIdentifier:@"singleImageVC"];
    destVC.photoObject = self.photoAlbum.photoObjectArray[indexPath.row];
    [self presentViewController:destVC animated:YES completion:nil];
}

#pragma mark <NewCollectionViewLayoutDelegate>
-(CGFloat) collectionView:(UICollectionView *)collectionView HeightForPhotoAtIndexPath:(NSIndexPath*)indexPath ForWidth:(CGFloat)width{
    PhotoObject *object = self.photoAlbum.photoObjectArray[indexPath.row];
    return object.thumbImageHeight/object.thumbImageWidth*width;
}

@end
