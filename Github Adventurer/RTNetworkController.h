//
//  RTNetworkController.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/22/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTNetworkControllerOAuthDelegate <NSObject>

-(void)didSetOAuthToken;

@end

@interface RTNetworkController : NSObject

@property (nonatomic, unsafe_unretained) id<RTNetworkControllerOAuthDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *token;

+ (RTNetworkController *)shared;

-(void)requestOAuthAccessWithParameters:(NSArray *)parameters;
-(void)handleOAuthCallbackWithURL:(NSURL *)url;
-(void)killOAuthToken;
-(void)getUserInfoWithCompletion:(void (^)(void))completion;
-(void)getUserReposWithCompletion:(void (^)(void))completion;


@end
