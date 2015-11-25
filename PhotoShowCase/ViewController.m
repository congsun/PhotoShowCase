//
//  ViewController.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "ViewController.h"
#import "APIClient.h"
#import "PhotoCollectionCell.h"
#import "PhotoAlbum.h"
#import "PhotoObject.h"
#import "SingleImageViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) PhotoAlbum *photoAlbum;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [APIClient getPhotoAlbumWithCompletion:^(BOOL isSuccess, PhotoAlbum *photoAlbum) {
        if(isSuccess){
            self.photoAlbum = photoAlbum;
            [self.collectionView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
                ((PhotoObject *)self.photoAlbum.photoObjectArray[indexPath.row]).thumbImage = image;
                PhotoCollectionCell *cellToUpdate = (PhotoCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                if(cellToUpdate){
                    cell.imageView.image = image;
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

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 24;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 150);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 24, 8, 24);
}

@end
