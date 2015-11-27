//
//  AlbumViewModel.h
//  PhotoShowCase
//
//  Created by Cong Sun on 11/27/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PhotoAlbum;

@interface AlbumViewModel : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *topImage;
@property (strong, nonatomic) UIImage *midImage;
@property (strong, nonatomic) UIImage *botImage;
@property (strong, nonatomic) NSURL *topImageUrl;
@property (strong, nonatomic) NSURL *midImageUrl;
@property (strong, nonatomic) NSURL *botImageUrl;

-(instancetype)initWithPhotoAlbum:(PhotoAlbum *)photoAlbum;
@end
