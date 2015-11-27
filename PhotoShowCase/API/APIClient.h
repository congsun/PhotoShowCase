//
//  APIClient.h
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PhotoAlbum;

@interface APIClient : NSObject

+(void)getPhotoAlbumWithCompletion:(void (^)(BOOL isSuccess,NSArray *photoAlbum))completionBlock;

+(void)getImageWithUrl:(NSURL *)url WithCompletion:(void(^)(BOOL isSuccess,UIImage *image))completionBlock;

@end
