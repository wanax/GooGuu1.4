//
//  AddCommentViewController.h
//  UIDemo
//
//  Created by Xcode on 13-7-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-16 | Wanax | 估股新闻三级添加评论页面

#import <UIKit/UIKit.h>

@interface AddCommentViewController : UIViewController<UITextViewDelegate>


@property (nonatomic,retain) IBOutlet UITextField *commentField;
@property (nonatomic,retain) IBOutlet UITextView *commentText;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) NSString *articleId;
@property CommentType type;

- (IBAction)backgroundTap:(id)sender;


@end
