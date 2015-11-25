//
//  PhotoAlbum.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "PhotoAlbum.h"

@implementation PhotoAlbum

-(instancetype)initWithTitle:(NSString *)title
            PhotoObjectArray:(NSArray *)photoObjectArray{
    self = [super init];
    if (self) {
        _title = title;
        _photoObjectArray = photoObjectArray;
    }
    return self;
}
@end
