//
//  IntroductionViewController.m
//  UIDemo
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-股票介绍

#import "IntroductionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MHTabBarController.h"
#import "UIImageView+Addition.h"
#import "UIImageView+WebCache.h"



@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

@synthesize photos;
@synthesize imageView;
@synthesize browser;
@synthesize photoDataSource;

- (void)dealloc
{
    SAFE_RELEASE(browser);
    SAFE_RELEASE(photoDataSource);
    SAFE_RELEASE(photos);
    SAFE_RELEASE(imageView);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.photoDataSource = temp;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#F3F2EF"]];
    self.navigationController.navigationBarHidden=YES;
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    id comInfo=delegate.comInfo;
    NSString *comPicUrl=[NSString stringWithFormat:@"%@",[comInfo objectForKey:@"companypicurl"]];
    if ([Utiles isNetConnected]) {
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        self.browser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
        
        DemoPhoto *photo = nil;
        if([Utiles isBlankString:comPicUrl]){
            photo = [[DemoPhoto alloc] initWithImage:[UIImage imageNamed:@"defaultDiagram"]];
        }else{
            photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:comPicUrl]];
        }
        [self.photoDataSource addObject:photo];
        [self.navigationController pushViewController:self.browser animated:YES];
        SAFE_RELEASE(photo);
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }
    
}


#pragma mark - CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return [self.photoDataSource count];
}
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count)
        return [self.photoDataSource objectAtIndex:index];
    return nil;
}




-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if(change.x<-100){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:2 animated:YES];
    }else if(change.x>100){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:0 animated:YES];
    }
}

-(void)move:(UIPanGestureRecognizer *)tapGr{
    
    CGPoint change=[tapGr translationInView:self.view];
    
    if(tapGr.state==UIGestureRecognizerStateChanged){
        
        imageView.frame=CGRectMake(0,MAX(MIN(standard.y+change.y,0),-2300),SCREEN_WIDTH,2600);
        
    }else if(tapGr.state==UIGestureRecognizerStateEnded){
        standard=imageView.frame.origin;
    }
    
    //手指向左滑动，向右切换scrollView视图
    if(change.x<-FINGERCHANGEDISTANCE&&change.y<5){
        
        [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}


















@end