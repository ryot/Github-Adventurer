//
//  RTUserData.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/22/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GithubUser.h"

@interface RTUserData : GithubUser

@property (nonatomic, strong) NSDictionary *userDict;
@property (nonatomic, strong) NSMutableArray *userReposArray;

+(RTUserData *)shared;
-(void)buildDataFromUserDictionary:(NSDictionary *)dataDict;
-(void)buildReposFromUserArray:(NSArray *)reposArray;
-(void)killUserData;


@end
