//
//  Repo.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 3/17/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "Repo.h"

@implementation Repo

- (id)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        self.name = [json objectForKey:@"name"];
        
        if ([json objectForKey:@"description"] != [NSNull null]) {
            self.description = [json objectForKey:@"description"];
        }
        
        self.html_url = [NSURL URLWithString:[json objectForKey:@"html_url"]];
        
        NSURL *avatarURL = [NSURL URLWithString:[json[@"owner"] objectForKey:@"avatar_url"]];
        [self downloadImageForURL:avatarURL];
    }
    
    return self;
}

- (void)downloadImageForURL:(NSURL *)url
{
    NSOperationQueue *downloadQueue = [NSOperationQueue new];
    [downloadQueue addOperationWithBlock:^{
        NSData *avatarData = [NSData dataWithContentsOfURL:url];
        self.authorAvatar = [UIImage imageWithData:avatarData];
    }];
}

@end
