//
//  RTNetworkController.m
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/22/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTNetworkController.h"
#import "RTUserData.h"
#import "Repo.h"

#define GITHUB_CLIENT_ID @"05b11277ff1bc6e5f595"
#define GITHUB_CLIENT_SECRET @"e9be182672e8d4e8ed7dfd08d59547d6ab350c7c"
#define GITHUB_CALLBACK_URI @"gitauthadventurer://git_callback"
#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&scope=%@"

@interface RTNetworkController ()

@property (nonatomic, strong, readonly) RTUserData *userData;

@end

@implementation RTNetworkController

+ (RTNetworkController *)shared
{
    static RTNetworkController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[RTNetworkController alloc] init];
    });
    return sharedInstance;
}

-(void)requestOAuthAccessWithParameters:(NSArray *)parameters
{
    NSString *paramString = [[NSString alloc]init];
    for (int i = 0; i < parameters.count; i++) {
        if (i == parameters.count - 1) {
            paramString = [paramString stringByAppendingString:parameters[i]];
        } else {
            paramString = [paramString stringByAppendingString:parameters[i]];
            paramString = [paramString stringByAppendingString:@","];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL, GITHUB_CLIENT_ID, paramString];
    
    [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:urlString] afterDelay:0.1];
}

-(void)handleOAuthCallbackWithURL:(NSURL *)url
{
    NSString *tempCode = [self getTempCodeFromCallbackURL:url];
    
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, tempCode];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)postData.length];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /*
    if (self.token) {
        sessionConfig.HTTPAdditionalHeaders = @{@"Authorization": [NSString stringWithFormat:@"token %@", self.token]};
    }
    */ 
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *token = [self convertResponseDataIntoToken:data];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate didSetOAuthToken];
    }];
    [postDataTask resume];
    
}

-(NSString *)convertResponseDataIntoToken:(NSData *)responseData
{
    NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSArray *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *accessTokenWithCode = tokenComponents.firstObject;
    NSArray *accessTokenArray = [accessTokenWithCode componentsSeparatedByString:@"="];
    return accessTokenArray[1];
}

-(NSString *)getTempCodeFromCallbackURL:(NSURL *)callbackURL
{
    NSString *query = [callbackURL query];
    NSArray *components = [query componentsSeparatedByString:@"code="];
    return components.lastObject;
}

-(void)getUserInfoWithCompletion:(void (^)(void))completion
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPAdditionalHeaders = @{@"Authorization" : [NSString stringWithFormat:@"token %@", self.token]};
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSMutableURLRequest *userRequest = [NSMutableURLRequest new];
    [userRequest setURL:[NSURL URLWithString:@"https://api.github.com/user"]];
    [userRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getUserDataTask = [session dataTaskWithRequest:userRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        [self.userData buildDataFromUserDictionary:userDict];
        //on mainqueue because receiver is view controller
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];
    }];
    [getUserDataTask resume];
}

-(void)getUserReposWithCompletion:(void (^)(void))completion
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPAdditionalHeaders = @{@"Authorization" : [NSString stringWithFormat:@"token %@", self.token]};
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    //get repos
    NSMutableURLRequest *reposRequest = [NSMutableURLRequest new];
    [reposRequest setURL:[NSURL URLWithString:@"https://api.github.com/user/repos"]];
    [reposRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getUserReposTask = [session dataTaskWithRequest:reposRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *reposArray = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:nil];
        [self.userData buildReposFromUserArray:reposArray];
        //on mainqueue because receiver is view controllerb
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];
    }];
    [getUserReposTask resume];
}

-(void)killOAuthToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

-(RTUserData *)userData {
    return [RTUserData shared];
}

@end
