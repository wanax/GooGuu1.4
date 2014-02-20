//
//  AddCommentViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AddCommentViewController.h"
#import "AFNetWorking.h"
#import "Queue.h"

@interface AddCommentViewController ()

@end

static NSString *herf_1 = @"<a target=\"_blank\" href=\"";
static NSString *herf_2 = @"\"><img src=\"";
static NSString *herf_3 = @"\" broder=\"0\" /></a>";

@implementation AddCommentViewController

- (id)initWithArg:(NSString *)arg type:(GooGuuCommentType)type
{
    self = [super init];
    if (self) {
        if (type == CompanyComment) {
            self.stockCode = arg;
        } else {
            self.articleId = arg;
        }
        self.type = type;
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.smallImgs = temp;
        NSMutableArray *temp2 = [[[NSMutableArray alloc] init] autorelease];
        self.upImgURLs = temp2;
        self.imgNum = 0;
        self.sendingNum = 0;
        Queue *temp3 = [[[Queue alloc] initAQueue] autorelease];
        self.queue = temp3;
        self.isSending = NO;
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
    self.sendingNum++;
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIActivityIndicatorView *loadingView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,10,10)] autorelease];
    loadingView.center = CGPointMake(30, 30);
    [self.smallImgViews[self.imgNum] addSubview:loadingView];
    [loadingView startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"http://www.googuu.net/m/imageup" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *uuid = [NSString stringWithFormat:@"%@",[NSUUID UUID]];
        NSString *name = [NSString stringWithFormat:@"%@.jpeg",[uuid substringToIndex:6]];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:@"file" fileName:name mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", [responseObject JSONString]);
        
        self.sendingNum--;
        id info = [operation.responseString objectFromJSONString];
        if ([info[@"status"] isEqualToString:@"1"]) {
            [self.upImgURLs addObject:info[@"data"]];
        }
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self.smallImgs addObject:image];
    self.imgNum ++;
    [self finishAndUpdate];
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
            
            if (self.type == CompanyReview) {
                url = @"CompanyReview";

                params = @{
                           @"stockcode":self.stockCode,
                           @"msg":msg,
                           @"token":[Utiles getUserToken],
                           @"from":@"googuu"
                           };
            } else {
                url = @"ArticleReview";

                params = @{
                           @"articleid":self.articleId,
                           @"msg":msg,
                           @"token":[Utiles getUserToken],
                           @"from":@"googuu"
                           };
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
