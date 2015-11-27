//
//  PhotoObject.m
//  PhotoShowCase
//
//  Created by Cong Sun on 11/24/15.
//  Copyright © 2015 Cong Sun. All rights reserved.
//

#import "PhotoObject.h"

@implementation PhotoObject

-(instancetype)initWithCaptain:(NSString *)captain
                        Credit:(NSString *)credit
                 ThumbImageUrl:(NSURL *)thunbImageUrl
                OriginImageUrl:(NSURL *)originImageUrl
              ThumbImageHeight:(CGFloat)thumbImageHeight
            AndThumbImageWidth:(CGFloat)thumbImageWidth {
    self = [super init];
    if(self){
        _captain = captain;
        _credit = credit;
        _thumbImageUrl = thunbImageUrl;
        _originImageUrl = originImageUrl;
        _thumbImageHeight = thumbImageHeight;
        _thumbImageWidth = thumbImageWidth;
    }
    return self;
}


-(instancetype)init {
    return [self initWithCaptain:@"" Credit:@"" ThumbImageUrl:nil OriginImageUrl:nil ThumbImageHeight:0.0 AndThumbImageWidth:0.0];
}


@end
