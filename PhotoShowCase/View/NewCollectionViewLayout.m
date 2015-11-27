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
        CGFloat sectionYOffset = 0;
        for(int section = 0; section<self.collectionView.numberOfSections;section++){
            NSMutableArray *attributeCacheOfSectionArray = [[NSMutableArray alloc]init];
            for(int i = 0; i<[self.collectionView numberOfItemsInSection:section];i++){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                CGFloat photoHeight = [self.delegate collectionView:self.collectionView HeightForPhotoAtIndexPath:indexPath ForWidth:photoWidth];
                CGFloat cellHeight = photoHeight+2*cellPadding;
                [cellHeightArray addObject:@(cellHeight)];
                CGFloat cellXOffset = i%2==0? 0:cellWidth-cellPadding;
                CGFloat cellYOffset = i>1? ((UICollectionViewLayoutAttributes *)(attributeCacheOfSectionArray[i-2])).frame.size.height+((UICollectionViewLayoutAttributes *)(attributeCacheOfSectionArray[i-2])).frame.origin.y:sectionYOffset;
                CGRect cellFrame = CGRectMake(cellXOffset, cellYOffset, cellWidth, cellHeight);
                CGRect insetCellFrame = CGRectInset(cellFrame, cellPadding, cellPadding);
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = insetCellFrame;
                [attributeCacheOfSectionArray addObject:attributes];
                if(i == [self.collectionView numberOfItemsInSection:section]-1){
                    if(i/2!=0&&i>0){
                        UICollectionViewLayoutAttributes *attributes = attributeCacheOfSectionArray[i-1];
                        sectionYOffset = MAX(cellYOffset+cellHeight, attributes.frame.size.height+attributes.frame.origin.y)+self.heightForHeader;
                    }else{
                        sectionYOffset = cellYOffset+cellHeight+self.heightForHeader;
                    }
                }
            }
            [self.attributeCache addObject:attributeCacheOfSectionArray];
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

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *attributeCacheOfSectionArray = self.attributeCache[indexPath.section];
    return attributeCacheOfSectionArray[indexPath.row];
    
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributesArray = [[NSMutableArray alloc]init];
    for(NSArray *sectionAttributesArray in self.attributeCache){
        for (UICollectionViewLayoutAttributes *attributes in sectionAttributesArray){
            if(CGRectIntersectsRect(attributes.frame, rect)){
                [layoutAttributesArray addObject:attributes];
            }
        }
    }
    return layoutAttributesArray;
}


@end
