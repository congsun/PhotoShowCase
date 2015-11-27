//
//  AlbumViewModel.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/26/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "AlbumViewModel.h"
#import "PhotoAlbum.h"
#import "PhotoObject.h"

@implementation AlbumViewModel
-(instancetype)initWithPhotoAlbum:(PhotoAlbum *)photoAlbum{
    self = [super init];
    if(self){
        _title = photoAlbum.title;
        NSArray *photoObjectArray = photoAlbum.photoObjectArray;
        if (photoObjectArray.count>2) {
            _botImageUrl = ((PhotoObject *)photoObjectArray[2]).thumbImageUrl;
        }
        if (photoObjectArray.count>1) {
            _midImageUrl = ((PhotoObject *)photoObjectArray[1]).thumbImageUrl;
        }
        if (photoObjectArray.count>0) {
            _topImageUrl = ((PhotoObject *)photoObjectArray[0]).thumbImageUrl;
        }
    }
    return self;
}
@end
