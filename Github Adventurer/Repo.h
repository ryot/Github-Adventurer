//
//  Repo.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 3/17/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RepoImageDownloadDelegate <NSObject>

-(void)repoImageDoneDownloading:(id)thisRepo;

@end

@interface Repo : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) UIImage *authorAvatar;
@property (nonatomic,strong) NSURL *html_url;
@property (nonatomic, strong) NSString *htmlCache;
@property (nonatomic, unsafe_unretained) id<RepoImageDownloadDelegate> downloadDelegate;

- (id)initWithJSON:(NSDictionary *)json isUserRepo:(BOOL)userRepo;

@end
