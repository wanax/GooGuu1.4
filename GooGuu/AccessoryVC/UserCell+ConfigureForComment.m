//
//  UserCell+ConfigureForComment.m
//  googuu
//
//  Created by Xcode on 13-9-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UserCell.h"
#import "UserCell+ConfigureForComment.h"
#import "UIImageView+AFNetworking.h"

@implementation UserCell (ConfigureForComment)

- (void)configureForCommentCell:(id)model
{
    self.name = [model objectForKey:@"author"];
    self.dec = [model objectForKey:@"content"];
    self.loc = [model objectForKey:@"updatetime"];
    
    @try {
        if([[NSString stringWithFormat:@"%@",[model objectForKey:@"headerpicurl"]] length]>7){
            //异步加载cell图片
            [self.imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[model objectForKey:@"headerpicurl"]]]
                                  placeholderImage:[UIImage imageNamed:@"pumpkin.png"]
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                               self.image = image;
                                               
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                               
                                           }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,86)];
    backView.backgroundColor=[Utiles colorWithHexString:@"#EFEBD9"];
    [self setBackgroundView:backView];
}



@end
