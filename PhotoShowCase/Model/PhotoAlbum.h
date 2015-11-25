//
//  PhotoAlbum.h
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoAlbum : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *photoObjectArray;

-(instancetype)initWithTitle:(NSString *)title
            PhotoObjectArray:(NSArray *)photoObjectArray;

@end
