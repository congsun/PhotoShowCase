//
//  NewCollectionViewLayout.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/25/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "NewCollectionViewLayout.h"

@interface NewCollectionViewLayout()
@property (strong, nonatomic)NSMutableArray *attributeCache;
@property (assign, nonatomic)CGFloat contentWidth;
@property (assign, nonatomic)CGFloat contentHeight;
@end

@implementation NewCollectionViewLayout

-(NSMutableArray *)attributeCache{
    if(!_attributeCache){
        _attributeCache = [[NSMutableArray alloc]init];
    }
    return _attributeCache;
}

-(CGFloat)contentWidth{
    UIEdgeInsets insets = self.collectionView.contentInset;
    return CGRectGetWidth(self.collectionView.bounds) - (insets.left+insets.right);
}


-(void)prepareLayout{
    if(self.attributeCache.count == 0){
        CGFloat cellPadding = 6.0;
        CGFloat photoWidth = (self.contentWidth-3*cellPadding)/2;
        CGFloat cellWidth = photoWidth + 2*cellPadding;
        NSMutableArray *cellHeightArray = [[NSMutableArray alloc]init];
        for(int i = 0; i<[self.collectionView numberOfItemsInSection:0];i++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CGFloat photoHeight = [self.delegate collectionView:self.collectionView HeightForPhotoAtIndexPath:indexPath ForWidth:photoWidth];
            CGFloat cellHeight = photoHeight+2*cellPadding;
            [cellHeightArray addObject:@(cellHeight)];
            CGFloat cellXOffset = i%2==0? 0:cellWidth-cellPadding;
            CGFloat cellYOffset = i>1? ((UICollectionViewLayoutAttributes *)self.attributeCache[i-2]).frame.size.height+((UICollectionViewLayoutAttributes *)self.attributeCache[i-2]).frame.origin.y:0;
            CGRect cellFrame = CGRectMake(cellXOffset, cellYOffset, cellWidth, cellHeight);
            CGRect insetCellFrame = CGRectInset(cellFrame, cellPadding, cellPadding);
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = insetCellFrame;
            [self.attributeCache addObject:attributes];
        }
        CGFloat totalHeightLeft = 0;
        CGFloat totalHeightRight = 0;
        for(int i = 0; i<cellHeightArray.count/2*2;i+=2){
            totalHeightLeft += ((NSNumber *)cellHeightArray[i]).floatValue;
            totalHeightRight += ((NSNumber *)cellHeightArray[i+1]).floatValue;
        }
        if(cellHeightArray.count>cellHeightArray.count/2*2){
            totalHeightLeft += ((NSNumber *)cellHeightArray[cellHeightArray.count-1]).floatValue;
        }
        self.contentHeight = MAX(totalHeightLeft, totalHeightRight);
    }
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributesArray = [[NSMutableArray alloc]init];
    for (UICollectionViewLayoutAttributes *attributes in self.attributeCache){
        if(CGRectIntersectsRect(attributes.frame, rect)){
            [layoutAttributesArray addObject:attributes];
        }
        
    }
    return layoutAttributesArray;
}


@end
