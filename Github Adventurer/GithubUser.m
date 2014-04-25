//
//  RTUser.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/24/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "GithubUser.h"

@implementation GithubUser

- (id)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        self.login = [json objectForKey:@"login"];
        self.html_url = [NSURL URLWithString:json[@"html_url"]];
        
        _avatarURL = [NSURL URLWithString:json[@"avatar_url"]];
    }
    return self;
}

- (void)downloadAvatarWithCompletionBlock:(void (^)())completion
{
    [self downloadAvatarOnQueue:[NSOperationQueue new] withCompletionBlock:completion];
}

- (void)downloadAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void(^)())completion
{
    self.downloadOp = [NSBlockOperation blockOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:self.avatarURL];
        _avatar = [UIImage imageWithData:imageData];
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];
    }];
    [queue addOperation:self.downloadOp];
}

-(void)cancelAvatarDownload
{
    if (!self.downloadOp.isExecuting) {
        [self.downloadOp cancel];
    }
}

@end
