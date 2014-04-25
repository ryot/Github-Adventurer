//
//  RTUserData.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/22/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTUserData.h"
#import "Repo.h"

@implementation RTUserData

+(RTUserData *)shared
{
    static RTUserData *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[RTUserData alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        _userReposArray = [NSMutableArray new];
    }
    return self;
}

-(void)buildDataFromUserDictionary:(NSDictionary *)dataDict
{
    _userDict = dataDict;
}

-(void)buildReposFromUserArray:(NSArray *)reposArray
{
    for (NSDictionary *repoDict in reposArray) {
        Repo *userRepo = [[Repo alloc] initWithJSON:repoDict isUserRepo:YES];
        [_userReposArray addObject:userRepo];
    }
}

-(void)killUserData
{
    _userDict = nil;
    _userReposArray = nil;
}

@end
