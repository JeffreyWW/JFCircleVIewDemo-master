//
// Created by Jeffrey on 2017/11/24.
// Copyright (c) 2017 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFBannerModel : NSObject
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *clickUrl;


+ (instancetype)modelWithImageName:(NSString *)imageName clickUrl:(NSString *)clickUrl;

@end