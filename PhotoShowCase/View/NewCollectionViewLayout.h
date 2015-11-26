//
//  NewCollectionViewLayout.h
//  PhotoShowCase
//
//  Created by Cong Sun on 11/25/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewCollectionViewLayoutDelegate <NSObject>

-(CGFloat) collectionView:(UICollectionView *)collectionView HeightForPhotoAtIndexPath:(NSIndexPath *)indexPath ForWidth:(CGFloat)width;

@end
@interface NewCollectionViewLayout : UICollectionViewLayout
@property (weak, nonatomic) id<NewCollectionViewLayoutDelegate> delegate;
@end
