//
//  Repo.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 3/17/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject

- (id)initWithJSON:(NSDictionary *)json;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) UIImage *authorAvatar;
@property (nonatomic,strong) NSURL *html_url;

@property (nonatomic, strong) NSString *htmlCache;

@end
