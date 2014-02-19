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

@interface AddCommentViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//记录已上传的图片数量，用户添加当前上传图片框中的进度条
@property NSInteger imgNum;
//记录正在上传的图片数量，用于发表时判断所有图片是否已上传完毕
@property NSInteger sendingNum;

@property GooGuuCommentType type;
@property (nonatomic,retain) NSString *topical;
@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSMutableArray *smallImgs;
@property (nonatomic,retain) NSMutableArray *upImgURLs;
@property (nonatomic,retain) NSArray *smallImgViews;

@property (nonatomic,retain) UIImagePickerController *imagePickerController;
@property (nonatomic,retain) IBOutlet UITextView *commentText;
@property (nonatomic,retain) IBOutlet UIToolbar *topBar;
@property (nonatomic,retain) IBOutlet UIButton *pickImgButton;

@property (nonatomic,retain) IBOutlet UIImageView *smallImg1;
@property (nonatomic,retain) IBOutlet UIImageView *smallImg2;
@property (nonatomic,retain) IBOutlet UIImageView *smallImg3;
@property (nonatomic,retain) IBOutlet UIImageView *smallImg4;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)pickFromCamera:(id)sender;
- (IBAction)pickFromPhotoPickera:(id)sender;

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type;


@end
