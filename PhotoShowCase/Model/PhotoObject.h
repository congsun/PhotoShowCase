//
//  PhotoObject.h
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoObject : NSObject
@property (strong, nonatomic) NSString *captain;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSURL *thumbImageUrl;
@property (strong, nonatomic) NSURL *originImageUrl;

@property (strong, nonatomic) UIImage *thumbImage;
@property (strong, nonatomic) UIImage *originImage;

-(instancetype)initWithCaptain:(NSString *)captain
                        Credit:(NSString *)credit
                 ThumbImageUrl:(NSURL *)thunbImageUrl
                OriginImageUrl:(NSURL *)originImageUrl;
@end
