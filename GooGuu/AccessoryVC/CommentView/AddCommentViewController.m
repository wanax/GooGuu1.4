//
//  AddCommentViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AddCommentViewController.h"
#import "AFImageRequestOperation.h"
#import "AFNetworking.h"

@interface AddCommentViewController ()

@end

static NSString *herf_1 = @"<a target=\"_blank\" href=\"";
static NSString *herf_2 = @"\"><img src=\"";
static NSString *herf_3 = @"\" broder=\"0\" /></a>";

@implementation AddCommentViewController

- (id)initWithTopical:(NSString *)topical type:(GooGuuCommentType)type
{
    self = [super init];
    if (self) {
        self.topical = topical;
        self.type = type;
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.smallImgs = temp;
        NSMutableArray *temp2 = [[[NSMutableArray alloc] init] autorelease];
        self.upImgURLs = temp2;
        self.imgNum = 0;
        self.sendingNum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.smallImgViews = @[self.smallImg1,self.smallImg2,self.smallImg3,self.smallImg4];
    
    self.commentText.returnKeyType = UIReturnKeyNext;
    self.commentText.layer.borderWidth = 1.0;
    self.commentText.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#FFFFFF"]];
    
    UIBarButtonItem *backBarItem = self.topBar.items[0];
    backBarItem.action = @selector(backBtClick:);
    UIBarButtonItem *sendBarItem = self.topBar.items[2];
    sendBarItem.action = @selector(sendComment);

}

-(void)backBtClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundTap:(id)sender {
    [self.commentText resignFirstResponder];
}

- (IBAction)pickFromCamera:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}
- (IBAction)pickFromPhotoPickera:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark -
#pragma Image Picker Method Delegate

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {

    if ([self.smallImgs count] > 3) {
        [ProgressHUD showError:@"最多只能添加四张图片"];
    } else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        self.imagePickerController = imagePickerController;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    
}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.smallImgs count] > 0) {
        int n = 0;
        for (id img in self.smallImgs) {
            [self.smallImgViews[n++] setImage:img];
        }
    }
    
    self.imagePickerController = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.sendingNum ++;
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIProgressView *uploadFileProgressView = [[[UIProgressView alloc] initWithFrame:CGRectMake(0,0,55,2)] autorelease];
    uploadFileProgressView.center = CGPointMake(30, 30);
    uploadFileProgressView.progress = 0;
    uploadFileProgressView.progressTintColor = [UIColor blueColor];
    uploadFileProgressView.trackTintColor = [UIColor grayColor];
    [self.smallImgViews[self.imgNum] addSubview:uploadFileProgressView];
    [uploadFileProgressView sizeThatFits:CGSizeMake(60,5)];
    
    AFHTTPClient *upImgClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.googuu.net/m/imageup"]];
    NSMutableURLRequest *fileUpRequest = [upImgClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:@"thumb.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *fileUploadOp = [[AFHTTPRequestOperation alloc]initWithRequest:fileUpRequest];
    
    [fileUploadOp setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite;
        [uploadFileProgressView setProgress:progress animated:YES];

    }];
    
    [fileUploadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [uploadFileProgressView removeFromSuperview];
        self.sendingNum--;
        id info = [operation.responseString objectFromJSONString];
        if ([info[@"status"] isEqualToString:@"1"]) {
            [self.upImgURLs addObject:info[@"data"]];
            NSLog(@"yes:%@",info[@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    [fileUploadOp start];
    
    [self.smallImgs addObject:image];
    [self finishAndUpdate];
    self.imgNum ++;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -
#pragma mark TextField Methods Delegate

-(void)sendComment {
    
    if ([Utiles isBlankString:self.commentText.text]) {
        [Utiles showToastView:self.view withTitle:nil andContent:@"请填写内容" duration:1.5];
    } else {
        if (self.sendingNum == 0) {
            NSDictionary *params = nil;
            NSString *url = @"";
            NSString *msg = self.commentText.text;
            
            if ([self.upImgURLs count] > 0) {
                for (NSString *url in self.upImgURLs) {
                    url = [url replaceAll:@"small" with:@"big"];
                    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@%@",herf_1,url,herf_2,url,herf_3]];
                }
            }
            
            if(self.type == CompanyReview){
                url = @"CompanyReview";
                params = [NSDictionary dictionaryWithObjectsAndKeys:self.topical,@"stockcode",msg,@"msg",[Utiles getUserToken],@"token",@"googuu",@"from",nil];
            }else{
                url = @"ArticleReview";
                params = [NSDictionary dictionaryWithObjectsAndKeys:self.topical,@"articleid",msg,@"msg",[Utiles getUserToken],@"token",@"googuu",@"from",nil];
            }
            
            [Utiles postNetInfoWithPath:url andParams:params besidesBlock:^(id obj){
                if([[obj objectForKey:@"status"] isEqualToString:@"1"]){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [ProgressHUD showError:@"发布失败"];
                }
            } failure:^(AFHTTPRequestOperation *operation,NSError *error){
                [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
            }];
        } else {
            [Utiles showToastView:self.view withTitle:nil andContent:@"图片正在上传,请稍后" duration:1.5];
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
















@end
