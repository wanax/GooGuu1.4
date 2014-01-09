//
//  CustomCell.h
//  Custom Cell
//
//  Created by Yang on 13-05-07.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-07 | Wanax | 用户评论中自定义cell

#import "UserCell.h"
#import "CommonlyMacros.h"

@implementation UserCell
@synthesize imageView;
@synthesize nameLabel;
@synthesize decLabel;
@synthesize locLabel;

@synthesize image;
@synthesize name;
@synthesize dec;
@synthesize loc;

- (void)dealloc
{
    SAFE_RELEASE(imageView);
    SAFE_RELEASE(nameLabel);
    SAFE_RELEASE(decLabel);
    SAFE_RELEASE(locLabel);
    SAFE_RELEASE(image);
    SAFE_RELEASE(name);
    SAFE_RELEASE(dec);
    SAFE_RELEASE(loc);
    [super dealloc];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"UserCell" bundle:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:image]) {
        image = [img copy];
        self.imageView.image = image;
    }
}

-(void)setName:(NSString *)n {
    if (![n isEqualToString:name]) {
        name = [n copy];
        self.nameLabel.text = name;
    }
}

-(void)setDec:(NSString *)d {
    if (![d isEqualToString:dec]) {
        dec = [d copy];
        self.decLabel.text = dec;
    }
}

-(void)setLoc:(NSString *)l {
    if (![l isEqualToString:loc]) {
        loc = [l copy];
        self.locLabel.text = loc;
    }
}

@end
