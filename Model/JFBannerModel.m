//
// Created by Jeffrey on 2017/11/24.
// Copyright (c) 2017 Jeffrey. All rights reserved.
//

#import "JFBannerModel.h"


@implementation JFBannerModel

- (instancetype)initWithImageName:(NSString *)imageName clickUrl:(NSString *)clickUrl {
    self = [super init];
    if (self) {
        self.imageName = imageName;
        self.clickUrl = clickUrl;
    }

    return self;
}

+ (instancetype)modelWithImageName:(NSString *)imageName clickUrl:(NSString *)clickUrl {
    return [[self alloc] initWithImageName:imageName clickUrl:clickUrl];
}

@end