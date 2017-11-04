//
//  PictureCollectionViewCell.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.imageView = [[UIImageView alloc] init];
    //self.record = [[UIButton alloc] init];
    
    [self.contentView addSubview: self.imageView];
    //[self.contentView addSubview:self.record];

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(13.5, 0, KScreenWidth/3-38, KScreenWidth/3-38);
    self.imageView.layer.cornerRadius = 7.0f;
    self.imageView.layer.masksToBounds = YES;

//    self.record.frame = CGRectMake(KScreenWidth/9-12.5, KScreenWidth/3-35,KScreenWidth/9+15,28);
//    self.record.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:94/255.0 alpha:1/1.0];
//    self.record.titleLabel.textColor = UIColor.whiteColor;
//    [self.record setFont: [UIFont systemFontOfSize:14.0]];
//    self.record.layer.cornerRadius = 7.0f;
//    self.record.layer.masksToBounds = YES;
}

@end
