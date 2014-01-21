//
//  CommonFunction.m
//  MathMonsters
//
//  Created by Xcode on 13-12-12.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "CommonFunction.h"

@implementation CommonFunction

+ (void)userLoginUserName:(NSString *)userName pwd:(NSString *)pwd callBack:(void (^)(id))block{
    
    if ([Utiles isNetConnected]) {

        NSDictionary *params = @{@"username":[userName lowercaseString],
                                 @"password":[Utiles md5:pwd],
                                 @"from":@"googuu"
                                 };
        
        [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id info){
            
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){

                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
                SetUserDefaults(info[@"token"],@"UserToken");
                NSMutableDictionary *dic = [[[NSMutableDictionary alloc] initWithDictionary:info] autorelease];
                [dic setObject:pwd forKey:@"password"];
                [dic setObject:userName forKey:@"username"];
                SetUserDefaults([dic JSONString],@"UserInfo");
                block(info);
               
            }/*else {
                NSString *msg=@"";
                if ([info[@"status"] isEqual:@"0"]) {
                    msg=@"用户不存在";
                } else if ([info[@"status"] isEqual:@"2"]){
                    msg=@"邮箱未激活";
                } else if ([info[@"status"] isEqual:@"3"]){
                    msg=@"密码错误";
                }
            }*/
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"from user login %@",error);
        }];
    } else {
        NSLog(@"net failed from user login");
    }
    
}

+(void)userLogoutcallBack:(void(^)(id obj))block{
    NSString *token= [Utiles getUserToken];
    if(token){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                token, @"token",@"googuu",@"from",
                                nil];
        [Utiles postNetInfoWithPath:@"LogOut" andParams:params besidesBlock:^(id info){
            block(info);
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"%@",error);
        }];
        
    }else{
        NSLog(@"logout failed");
    }
}


@end
