//
//  FDAlbumLibraryController.m
//  FastDemo
//
//  Created by Jason on 2019/1/6.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAlbumLibraryController.h"
#import "FDAlbumCollectionCell.h"
#import "FDAlbumLibraryContext.h"
#import "FDAlbumModel.h"
#import "FDAlbumView.h"

@interface FDAlbumLibraryController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *showAlbumButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UICollectionView *albumCollectionView;

@property (nonatomic, strong) NSMutableArray<FDAlbumModel *> *assetCollectionList;

@property (nonatomic, strong) FDAlbumModel *albumModel;

@property (nonatomic, strong) FDAlbumView *albumView;

@end

@implementation FDAlbumLibraryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    [self.view addSubview:self.albumCollectionView];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 45)];
    self.navigationItem.titleView = titleView;
    [titleView addSubview:self.showAlbumButton];
    
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmButton];
    self.navigationItem.rightBarButtonItem = confirmItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getThumbnailImages];
    
    [self.albumCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)getThumbnailImages {
    self.assetCollectionList = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // 获得个人收藏相册
        PHFetchResult<PHAssetCollection *> *favoritesCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
        // 获得相机胶卷
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        // 获得全部相片
        PHFetchResult<PHAssetCollection *> *cameraRolls = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        for (PHAssetCollection *collection in cameraRolls) {
            FDAlbumModel *model = [[FDAlbumModel alloc] init];
            model.collection = collection;
            
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }
        
        for (PHAssetCollection *collection in favoritesCollection) {
            FDAlbumModel *model = [[FDAlbumModel alloc] init];
            model.collection = collection;
            
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }
        
        for (PHAssetCollection *collection in assetCollections) {
            FDAlbumModel *model = [[FDAlbumModel alloc] init];
            model.collection = collection;
            
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.albumModel = weakSelf.assetCollectionList.firstObject;
        });
    });
}

-(void)setAlbumModel:(FDAlbumModel *)albumModel {
    _albumModel = albumModel;
    [self.showAlbumButton setTitle:albumModel.collectionTitle forState:UIControlStateNormal];
    [self.albumCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumModel.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FDAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FDAlbumCollectionCell class]) forIndexPath:indexPath];
    
    cell.row = indexPath.row;
    cell.asset = self.albumModel.assets[indexPath.row];
    [cell loadImage:indexPath];
    cell.isSelect = [self.albumModel.selectRows containsObject:@(indexPath.row)];
    
    WEAKSELF
    __weak typeof(cell) weakCell = cell;
    cell.selectPhotoAction = ^(PHAsset *asset) {
        BOOL isReloadCollectionView = NO;
        if ([weakSelf.albumModel.selectRows containsObject:@(indexPath.row)]) {
            [weakSelf.albumModel.selectRows removeObject:@(indexPath.row)];
            [FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount--;
            
            isReloadCollectionView = [FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount == [FDAlbumLibraryContext standardAlbumLibraryContext].maxCount - 1;
        } else {
            if ([FDAlbumLibraryContext standardAlbumLibraryContext].maxCount == [FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount) {
                return;
            }
            [weakSelf.albumModel.selectRows addObject:@(indexPath.row)];
            [FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount++;
            isReloadCollectionView = [FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount == [FDAlbumLibraryContext standardAlbumLibraryContext].maxCount;
        }
        [weakSelf.confirmButton setTitle:[NSString stringWithFormat:@"OK (%d/%ld)",[FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount,[FDAlbumLibraryContext standardAlbumLibraryContext].maxCount] forState:UIControlStateNormal];
        
        if (isReloadCollectionView) {
            [weakSelf.albumCollectionView reloadData];
        } else {
            weakCell.isSelect = [weakSelf.albumModel.selectRows containsObject:@(indexPath.row)];
        }
    };
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((WindowSizeW - 20.f) / 3.f, (WindowSizeW - 20.f) / 3.f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - Actions
-(void)showAlbum:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.albumView.assetCollectionList = self.assetCollectionList;
        [self.albumView showInView:self.view originY:SafeAreaTopHeight];
    } else {
        [self.albumView endAnimate];
    }
}

-(void)backAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)confirmAction:(UIButton *)button {
    if ([FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount > 0) {
        button.enabled = NO;
        NSMutableArray<FDPictureModel *> *photoList = [NSMutableArray array];
        
        __weak typeof(self) weakSelf = self;
        for (FDAlbumModel *albumModel in self.assetCollectionList) {
            for (NSNumber *row in albumModel.selectRows) {
                if (row.integerValue < albumModel.assets.count) {
                    FDPictureModel *photoModel = [[FDPictureModel alloc] init];
                    
                    __weak typeof(photoModel) weakPhotoModel = photoModel;
                    photoModel.getPictureAction = ^{
                        [photoList addObject:weakPhotoModel];
                        
                        if (photoList.count == [FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount) {
                            button.enabled = YES;
                            
                            [FDAlbumLibraryContext standardAlbumLibraryContext].photoModelList = photoList;
                            if (weakSelf.confirmAction) {
                                weakSelf.confirmAction();
                            }
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        }
                    };
                    
                    photoModel.asset = albumModel.assets[row.integerValue];
                }
            }
        }
    }
}

#pragma mark - Getter
-(UICollectionView *)albumCollectionView {
    if (!_albumCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5.f;
        layout.minimumInteritemSpacing = 5.f;
        
        _albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _albumCollectionView.delegate = self;
        _albumCollectionView.dataSource = self;
        _albumCollectionView.backgroundColor = [UIColor whiteColor];
        _albumCollectionView.scrollEnabled = YES;
        _albumCollectionView.alwaysBounceVertical = YES;
        
        [_albumCollectionView registerClass:[FDAlbumCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FDAlbumCollectionCell class])];
        
        [self.view addSubview:_albumCollectionView];
    }
    
    return _albumCollectionView;
}

-(UIButton *)showAlbumButton {
    if (!_showAlbumButton) {
        _showAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showAlbumButton.frame = CGRectMake(0, 0, 180, 45);
        [_showAlbumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_showAlbumButton setImage:[UIImage imageNamed:@"photo_select_down"] forState:UIControlStateNormal];
        [_showAlbumButton setImage:[UIImage imageNamed:@"photo_select_up"] forState:UIControlStateSelected];
        _showAlbumButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _showAlbumButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10.f);
        [_showAlbumButton addTarget:self action:@selector(showAlbum:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _showAlbumButton;
}

-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 50, 50);
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

-(UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.enabled = NO;
        _confirmButton.frame = CGRectMake(0, 0, 80, 45);
        _confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton setTitle:[NSString stringWithFormat:@"OK (0/%ld)",[FDAlbumLibraryContext standardAlbumLibraryContext].maxCount] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    }
    
    return _confirmButton;
}

- (FDAlbumView *)albumView {
    if (!_albumView) {
        _albumView = [[FDAlbumView alloc] init];
        WEAKSELF
        _albumView.selectAction = ^(id albumModel) {
            if (albumModel) {
                weakSelf.albumModel = albumModel;
            }
            weakSelf.showAlbumButton.selected = NO;
        };
    }
    return _albumView;
}

@end
