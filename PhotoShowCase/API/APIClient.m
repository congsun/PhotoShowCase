//
//  APIClient.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "APIClient.h"
#import "PhotoAlbum.h"
#import "PhotoObject.h"
#import "Constants.h"

@implementation APIClient

+(void)getPhotoAlbumWithUrl:(NSURL *)url AndCompletion:(void(^)(BOOL isSuccess,PhotoAlbum *photoAlbum))completionBlock{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failure! Error: %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil);
            });
        }else{
            NSError *jsonError = nil;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonResponse) {
                NSArray *responseArray = jsonResponse[@"albums"];
                NSDictionary *responseDict = responseArray[0];
                NSString *title = responseDict[@"title"];
                NSArray *photoDicArray = responseDict[@"slides"];
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                for (NSDictionary *photoDic in photoDicArray) {
                    NSDictionary *metaData = ((NSDictionary *)photoDic[@"metaData"])[@"items"];
                    NSString *captain = metaData[@"caption"];
                    NSString *credit = metaData[@"credit"];
                    NSString *baseImageUrlString = metaData[@"publishurl"];
                    NSString *originImageUrlString = metaData[@"basename"];
                    NSString *smallImageUrlString = metaData[@"smallbasename"];
                    NSURL *thumbImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseImageUrlString,smallImageUrlString]];
                    NSURL *originImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseImageUrlString,originImageUrlString]];
                    NSString *thumbImageHeightString = metaData[@"simageheight"];
                    NSString *thumbImageWidthString = metaData[@"simagewidth"];
                    CGFloat thumbImageHeight = [thumbImageHeightString floatValue];
                    CGFloat thumbImageWidth = [thumbImageWidthString floatValue];
                    PhotoObject *photoObject = [[PhotoObject alloc]initWithCaptain:captain Credit:credit ThumbImageUrl:thumbImageUrl OriginImageUrl:originImageUrl ThumbImageHeight:thumbImageHeight AndThumbImageWidth:thumbImageWidth];
                    [resultArray addObject:photoObject];
                }
                PhotoAlbum *album = [[PhotoAlbum alloc]initWithTitle:title PhotoObjectArray:resultArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(YES,album);
                });
            }else{
                NSLog(@"Failure! Error: %@",jsonError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO,nil);
                });
            }
        }
    }];
    [task resume];
}

+(void)getPhotoAlbumWithCompletion:(void (^)(BOOL isSuccess,PhotoAlbum *photoAlbum))completionBlock{
    NSURL *url = [NSURL URLWithString:kPHOTOALBUMURL];
    [APIClient getPhotoAlbumWithUrl:url AndCompletion:^(BOOL isSuccess, PhotoAlbum *photoAlbum) {
        completionBlock(isSuccess,photoAlbum);
    }];
}

+(void)getImageWithUrl:(NSURL *)url WithCompletion:(void (^)(BOOL isSuccess,UIImage *))completionBlock{
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil);
            });
        }else{
            UIImage *resultImage = [UIImage imageWithData:data];
            if (resultImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(YES,resultImage);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO,nil);
                });
            }
        }
        
    }];
    [task resume];
}

@end
