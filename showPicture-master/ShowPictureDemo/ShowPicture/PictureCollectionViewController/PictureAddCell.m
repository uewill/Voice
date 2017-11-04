//
//  PictureAddCell.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "PictureAddCell.h"

@implementation PictureAddCell
{
    UIImageView *addImageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    addImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:addImageView];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    addImageView.frame =  CGRectMake(13.5, 0, KScreenWidth/3-38, KScreenWidth/3-38);
    addImageView.image = [UIImage imageNamed:@"addPicture"];
}


@end
