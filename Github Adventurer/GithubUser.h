//
//  RTUser.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/24/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserImageDownloadDelegate <NSObject>

-(void)userImageDoneDownloading:(id)thisRepo;

@end

@interface GithubUser : NSObject

@property (nonatomic, strong) NSBlockOperation *downloadOp;
@property (nonatomic,strong) NSString *login;
@property (nonatomic,strong) NSURL *avatarURL;
@property (nonatomic,strong) UIImage *avatar;
@property (nonatomic,strong) NSURL *html_url;
@property (nonatomic, strong) NSString *htmlCache;
@property (nonatomic, unsafe_unretained) id<UserImageDownloadDelegate> downloadDelegate;

-(id)initWithJSON:(NSDictionary *)json;
-(void)downloadAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void(^)())completion;
-(void)cancelAvatarDownload;

@end
