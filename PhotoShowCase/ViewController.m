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
#import "NewCollectionViewLayout.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NewCollectionViewLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *photoAlbumArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NewCollectionViewLayout *layout = [[NewCollectionViewLayout alloc]init];
    layout.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [APIClient getPhotoAlbumWithCompletion:^(BOOL isSuccess, NSArray *photoAlbumArray) {
        if(isSuccess){
            PhotoAlbum *album = photoAlbumArray[0];
            NSMutableArray *array = photoAlbumArray.mutableCopy;
            [array addObject:album];
            self.photoAlbumArray = array;
            
//            self.photoAlbumArray = photoAlbumArray;
            self.navigationItem.title = @"Photo Show Case";
            [self.collectionView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Avenir Book" size:17]};
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.photoAlbumArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.photoAlbumArray !=nil){
       return ((PhotoAlbum *)(self.photoAlbumArray[section])).photoObjectArray.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionCell *cell = (PhotoCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    PhotoAlbum *photoAlbum = self.photoAlbumArray[indexPath.section];
    PhotoObject *photoObject = photoAlbum.photoObjectArray[indexPath.row];
    cell.imageView.image = nil;
    if(photoObject.thumbImage){
        cell.imageView.image = photoObject.thumbImage;
    }else{
        [APIClient getImageWithUrl:photoObject.thumbImageUrl WithCompletion:^(BOOL isSuccess, UIImage *image) {
            if (isSuccess) {
                PhotoAlbum *photoAlbum = self.photoAlbumArray[indexPath.section];
                PhotoObject *photoObject = photoAlbum.photoObjectArray[indexPath.row];
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
    PhotoAlbum *photoAlbum = self.photoAlbumArray[indexPath.section];
    destVC.photoObject = photoAlbum.photoObjectArray[indexPath.row];
    [self presentViewController:destVC animated:YES completion:nil];
}

-(CGFloat) collectionView:(UICollectionView *)collectionView HeightForPhotoAtIndexPath:(NSIndexPath*)indexPath ForWidth:(CGFloat)width{
    PhotoAlbum *photoAlbum = self.photoAlbumArray[indexPath.section];
    PhotoObject *object = photoAlbum.photoObjectArray[indexPath.row];
    return object.thumbImageHeight/object.thumbImageWidth*width;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView HeightForHeaderAtSection:(NSUInteger)section{
    return 20;
}

@end
