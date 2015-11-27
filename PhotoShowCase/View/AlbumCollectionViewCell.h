//
//  AlbumCollectionViewCell.h
//  PhotoShowCase
//
//  Created by Cong Sun on 11/26/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UIImageView *botImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
