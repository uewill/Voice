//
//  PictureViewController.h
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/4/1.
//  Copyright © 2016年 QQpicture. All rights reserved.
#import <UIKit/UIKit.h>
@interface PictureViewController : UIViewController
@property(nonatomic,strong)UICollectionView *pictureCollectonView;
@property(nonatomic,strong)UIView *RecordButtonView;
@property(nonatomic,strong)UIView *VoiceButtonView;

@property(nonatomic,copy) void(^updateData)(NSMutableArray* imgs,NSMutableArray* mp3s,NSMutableArray* voiceTime);
@end
