//
//  ViewController.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/30.
//  Copyright © 2016年 QQpicture. All rights reserved.
#import "PictureViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "PictureCollectionViewCell.h"
#import "PictureAddCell.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import "NewLuYinActionView.h"

@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIButton *VoiceButton;
@property(nonatomic,strong)UIButton *Record;
@property(nonatomic,strong)NSMutableArray *itemsSectionPictureArray;
@property(nonatomic,strong)NSMutableArray *Mp3Array;
@property(nonatomic,strong)NSMutableArray *Mp3TimeArray;
@end

@implementation PictureViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsSectionPictureArray = [[NSMutableArray alloc] init];
    self.Mp3Array                        = [[NSMutableArray alloc] init];
    self.Mp3TimeArray                 = [[NSMutableArray alloc] init];

    [_Mp3TimeArray setObject:@"0s" atIndexedSubscript:0];
    [_Mp3Array setObject:@"" atIndexedSubscript:0];

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize                               = CGSizeMake(KScreenWidth/3-8, KScreenWidth/3-8);
    layout.minimumInteritemSpacing     = 3;
    layout.minimumLineSpacing            = 3;  //上下的间距 可以设置0看下效果
    layout.sectionInset                          = UIEdgeInsetsMake(0.f, 0, 5.f, 5);
    //创建 UICollectionView
    self.pictureCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 220, self.view.frame.size.width-10, self.view.frame.size.height*0.83) collectionViewLayout:layout];
//    self.pictureCollectonView.backgroundColor = UIColor.blackColor;
    [self.pictureCollectonView registerClass:[PictureCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    [self.pictureCollectonView registerClass:[PictureAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
    self.pictureCollectonView.backgroundColor = [UIColor whiteColor];
    self.pictureCollectonView.delegate              = self;
    self.pictureCollectonView.dataSource         = self;
    [self.view addSubview:self.pictureCollectonView];
    [self addFootView];
}

#pragma 录制Button
-(void)addFootView{
    _RecordButtonView = [[UIView alloc] init];
    _Record = [[UIButton alloc]init];
    _RecordButtonView.frame = CGRectMake(KScreenMiddle+5, KScreenHeight*0.85,120, 44);
    _RecordButtonView.layer.cornerRadius = 10.0f;
    _RecordButtonView.layer.masksToBounds = YES;
    _Record.frame                  = CGRectMake(0,0,120, 44);
    _Record.backgroundColor =  [UIColor colorWithRed:249/255.0 green:94/255.0 blue:94/255.0 alpha:1/1.0];
    [_Record setTitle:@"上传" forState:UIControlStateNormal];
    _Record.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    _Record.titleLabel.textAlignment =NSTextAlignmentCenter;
    _Record.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [_Record addTarget:self action:@selector(Up) forControlEvents:UIControlEventTouchUpInside];
    [_RecordButtonView addSubview:_Record];
    
    
    _VoiceButtonView = [[UIView alloc] init];
    _VoiceButton = [[UIButton alloc]init];
    _VoiceButtonView.frame = CGRectMake(KScreenMiddle-125, KScreenHeight*0.85,120, 44);
    _VoiceButtonView.layer.cornerRadius = 10.0f;
    _VoiceButtonView.layer.masksToBounds = YES;
    _VoiceButton.frame                  = CGRectMake(0,0,120, 44);
    _VoiceButton.backgroundColor =  [UIColor colorWithRed:249/255.0 green:94/255.0 blue:120/255.0 alpha:1/1.0];
    [_VoiceButton setTitle:@"录音" forState:UIControlStateNormal];
    _VoiceButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    _VoiceButton.titleLabel.textAlignment =NSTextAlignmentCenter;
    _VoiceButton.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    _VoiceButton.tag=0;
    [_VoiceButton addTarget:self action:@selector(JmpToLuYin:) forControlEvents:UIControlEventTouchUpInside];
    [_VoiceButtonView addSubview:_VoiceButton];
    
}

#pragma 点击录制Button事件
-(void)Up{
    
        if(_itemsSectionPictureArray.count != 0 && [self judegeMp3sFull]){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认上传？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                __weak typeof(alert) wAlert = alert;
            
                [wAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    if (self.updateData) {
                        NSLog(@"%@", _itemsSectionPictureArray);
                        self.updateData(_itemsSectionPictureArray,_Mp3Array,_Mp3TimeArray);
                    }
                }]];
            
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请完善信息后再上传" message:nil preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(alert) wAlert = alert;
            [wAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    
}

-(BOOL)judegeMp3sFull{
    if([[_Mp3TimeArray objectAtIndex:0]  isEqual: @"0s"]){
            return false;
    }
    return true;
}

#pragma 点击录制Button事件
-(void)setUpdateData:(void (^)(NSMutableArray *, NSMutableArray *,NSMutableArray*))updateData{
    _updateData = updateData;
}

#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.itemsSectionPictureArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.row == self.itemsSectionPictureArray.count) {
         if(self.itemsSectionPictureArray.count == 9){
             UICollectionViewCell* addCell = [[UICollectionViewCell alloc] init];
             return addCell;
         }
        static NSString *addItem = @"addItemCell";
        UICollectionViewCell *addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        return addItemCell;
    }else
    {
        static NSString *identify = @"cell";
        PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.imageView.image = self.itemsSectionPictureArray[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.imageView setClipsToBounds:YES];
        //[cell.record setTag:indexPath.row];
        //[cell.record addTarget:self action:@selector(JmpToLuYin:)  forControlEvents:UIControlEventTouchUpInside];
//        if([[self secondToMin:[_Mp3TimeArray objectAtIndex:indexPath.row]]  isEqual: @"0s"]){
//            [cell.record setTitle:@"录制" forState:UIControlStateNormal];
//        }else{
//            [cell.record setTitle:[self secondToMin:[_Mp3TimeArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
//        }
    
        return cell;
    }
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.itemsSectionPictureArray.count  ) {
        if (self.itemsSectionPictureArray.count > 8) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法进入录制" message:@"请至少选择一张图片" preferredStyle:UIAlertControllerStyleAlert];
//            __weak typeof(alert) wAlert = alert;
//            [wAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
//            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择",@"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
    }else
    {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        for (int i = 0;i< self.itemsSectionPictureArray.count; i ++) {
            UIImage *image = self.itemsSectionPictureArray[i];
            MJPhoto *photo = [MJPhoto new];
            photo.image = image;
            PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = cell.imageView;
            [photoArray addObject:photo];
        }
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photoArray;
        [browser show];
    }
}

-(void)JmpToLuYin:(id) sender{
    if(_itemsSectionPictureArray.count==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请至少上传一张图片再录音" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSLog(@"%ld",(long)[sender tag]);

    UIImage* image = [_itemsSectionPictureArray objectAtIndex:0];
    NewLuYinActionView * lyView = [[NewLuYinActionView alloc] initWithBackground:image];
    lyView.index = [NSString stringWithFormat:@"%ld",(long)0];
    __weak typeof(self) weakSelf = self;
    
    lyView.callBackVoiceUrl = ^(NSString * url){
        [weakSelf.Mp3Array setObject:url atIndexedSubscript:0];
        NSLog(@"在%ld  %@",(long)0,url);
    };
    
    lyView.callBackVoiceTime = ^(NSString* time){
        [weakSelf.Mp3TimeArray setObject:time atIndexedSubscript:0];
        [self setVoiceInfo];
        [self.pictureCollectonView reloadData];
    };
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:lyView];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
    
}

-(void) setVoiceInfo{
    if(_Mp3TimeArray.count>0){
        if([[self secondToMin:[_Mp3TimeArray objectAtIndex:0]]  isEqual: @"0s"]){
                [_VoiceButton setTitle:@"录制" forState:UIControlStateNormal];
            }else{
                [_VoiceButton setTitle:[self secondToMin:[_Mp3TimeArray objectAtIndex:0]] forState:UIControlStateNormal];
            }
        
    }
}
-(void)deletedPictures:(NSSet *)set
{
    NSMutableArray *cellArray = [NSMutableArray array];
    for (NSString *index1 in set) {
        [cellArray addObject:index1];
    }
    if (cellArray.count == 0) {
    }else if (cellArray.count == 1 && self.itemsSectionPictureArray.count == 1) {
        NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.itemsSectionPictureArray removeObjectAtIndex:indexPathTwo.row];
        [self.Mp3TimeArray removeObjectAtIndex:indexPathTwo.row];
        [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPathTwo]];
    }else{
        for (int i = 0; i<cellArray.count-1; i++) {
            for (int j = 0; j<cellArray.count-1-i; j++) {
                if ([cellArray[j] intValue]<[cellArray[j+1] intValue]) {
                    NSString *temp = cellArray[j];
                    cellArray[j] = cellArray[j+1];
                    cellArray[j+1] = temp;
                }
            }
        }
        for (int b = 0; b<cellArray.count; b++) {
            int idexx = [cellArray[b] intValue]-1;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idexx inSection:0];
            [self.itemsSectionPictureArray removeObjectAtIndex:indexPath.row];
            [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPath]];
        }
        [self.Mp3TimeArray removeObjectAtIndex:0];
    }
//    if (self.itemsSectionPictureArray.count <3) {
//        self.pictureCollectonView.frame = CGRectMake(0, 100, self.view.frame.size.width, 150);
//    }else if (self.itemsSectionPictureArray.count <6)
//    {
//        self.pictureCollectonView.frame = CGRectMake(0, 100, self.view.frame.size.width, 250);
//    }else
//    {
//        self.pictureCollectonView.frame = CGRectMake(0, 100, self.view.frame.size.width, 300);
//    }
}
#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 9 - self.itemsSectionPictureArray.count;
        elcPicker.returnsOriginalImage = YES;
        elcPicker.returnsImage = YES;
        elcPicker.onOrder = NO;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        elcPicker.imagePickerDelegate = self;
        elcPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡特效
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }else if (buttonIndex == 3)
    {
        NSLog(@"点击了精美配图");
        
    }else if (buttonIndex == 1)
    {
        NSLog(@"点击了拍照");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
    }
}
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    __weak PictureViewController *wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        BOOL hasVideo = NO;
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    [images addObject:image];
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
                if (!hasVideo) {
                    hasVideo = YES;
                }
            } else {
                NSLog(@"Uknown asset type");
            }
        }
        
        NSMutableArray *indexPathes = [NSMutableArray array];
        for (unsigned long i = wself.itemsSectionPictureArray.count; i < wself.itemsSectionPictureArray.count + images.count; i++) {
            [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [wself.itemsSectionPictureArray addObjectsFromArray:images];
        
        // 调整集合视图的高度
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
//            
//            if (wself.itemsSectionPictureArray.count <3) {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 150);
//            }else if (wself.itemsSectionPictureArray.count <6)
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 250);
//            }else
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 300);
//            }
            
            [wself.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            [wself.pictureCollectonView performBatchUpdates:^{
                [wself.pictureCollectonView insertItemsAtIndexPaths:indexPathes];
            } completion:^(BOOL finished) {
                if (hasVideo) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持视频发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }
            }];
        }];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self.itemsSectionPictureArray addObject:image];
    __weak PictureViewController *wself = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
//            if (wself.itemsSectionPictureArray.count <3) {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 150);
//            }else if (wself.itemsSectionPictureArray.count <6)
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 250);
//            }else
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 300);
//            }
            [wself.view layoutIfNeeded];
        } completion:nil];
        
        [self.pictureCollectonView performBatchUpdates:^{
            [wself.pictureCollectonView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:wself.itemsSectionPictureArray.count - 1 inSection:0]]];
        } completion:nil];
    }];
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)secondToMin:(NSString*)Second{
    int Min = [Second intValue];
    if(Min < 60){
        return [NSString stringWithFormat:@"%ds",Min];
    }
    int minNumber = 0;
    if(Min>=60){
        minNumber = Min/60;
    }
    return [NSString stringWithFormat:@"%d:%d",minNumber,Min%60];
}
@end
