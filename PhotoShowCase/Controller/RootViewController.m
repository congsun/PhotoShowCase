//
//  RootViewController.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/26/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "RootViewController.h"
#import "APIClient.h"
#import "PhotoAlbum.h"
#import "PhotoObject.h"
#import "AlbumViewModel.h"
#import "AlbumCollectionViewCell.h"
#import "PhotoArrayViewController.h"

@interface RootViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *photoAlbumArray;
@property (strong, nonatomic) NSMutableArray *albumViewModelArray;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Avenir Book" size:17]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [APIClient getPhotoAlbumWithCompletion:^(BOOL isSuccess, NSArray *photoAlbumArray) {
        if(isSuccess){
            self.photoAlbumArray = photoAlbumArray;
            self.navigationItem.title = @"Photo Showcase";
            [self.collectionView reloadData];
        }
    }];
}

-(void)setPhotoAlbumArray:(NSArray *)photoAlbumArray{
    _photoAlbumArray = photoAlbumArray;
    self.albumViewModelArray = [[NSMutableArray alloc]init];
    for(PhotoAlbum *album in photoAlbumArray){
        AlbumViewModel *albumViewModel = [[AlbumViewModel alloc]initWithPhotoAlbum:album];
        [self.albumViewModelArray addObject:albumViewModel];
    }
    [self.collectionView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PhotoArrayViewController *destVC = [storyboard instantiateViewControllerWithIdentifier:@"photoVC"];
    PhotoAlbum *photoAlbum = (PhotoAlbum *)self.photoAlbumArray[indexPath.row];
    destVC.photoAlbum = photoAlbum;
    [self showViewController:destVC sender:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumViewModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
    AlbumViewModel *album = self.albumViewModelArray[indexPath.row];
    cell.titleLabel.text = album.title;
    if (album.topImageUrl) {
        if (album.topImage) {
            cell.topImageView.image = album.topImage;
        }else{
            [APIClient getImageWithUrl:album.topImageUrl WithCompletion:^(BOOL isSuccess, UIImage *image) {
                if (isSuccess) {
                    AlbumViewModel *album = self.albumViewModelArray[indexPath.row];
                    album.topImage = image;
                    AlbumCollectionViewCell *cellToUpdate = (AlbumCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    if(cellToUpdate){
                        cellToUpdate.topImageView.image = image;
                    }
                }
            }];
        }
    }
    if (album.midImageUrl) {
        if (album.midImage) {
            cell.midImageView.image = album.midImage;
        }else{
            [APIClient getImageWithUrl:album.midImageUrl WithCompletion:^(BOOL isSuccess, UIImage *image) {
                if (isSuccess) {
                    AlbumViewModel *album = self.albumViewModelArray[indexPath.row];
                    album.midImage = image;
                    AlbumCollectionViewCell *cellToUpdate = (AlbumCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    if(cellToUpdate){
                        cellToUpdate.midImageView.image = image;
                    }
                }
            }];
        }
    }
    if (album.botImageUrl) {
        if (album.botImage) {
            cell.botImageView.image = album.botImage;
        }else{
            [APIClient getImageWithUrl:album.botImageUrl WithCompletion:^(BOOL isSuccess, UIImage *image) {
                if (isSuccess) {
                    AlbumViewModel *album = self.albumViewModelArray[indexPath.row];
                    album.botImage = image;
                    AlbumCollectionViewCell *cellToUpdate = (AlbumCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    if(cellToUpdate){
                        cellToUpdate.botImageView.image = image;
                    }
                }
            }];
        }
    }
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 24;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(300, 300);
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
