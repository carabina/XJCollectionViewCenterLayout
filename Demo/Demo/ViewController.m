//
//  ViewController.m
//  Demo
//
//  Created by XJIMI on 2017/10/12.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import "ViewController.h"
#import "XJCollectionViewCenterLayout.h"

NSString *const CellIdentifier = @"CellIdentifier";

@interface ViewController () < UICollectionViewDataSource,
                               UICollectionViewDelegate >

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    CGFloat inset = 20;
    CGFloat spacing = 10.0f;
    CGFloat itemDisplayCount = 2;
    CGFloat size = (self.view.frame.size.width - inset * 2 - ((itemDisplayCount - 1) * spacing)) / itemDisplayCount;
    
    XJCollectionViewCenterLayout *layout = [XJCollectionViewCenterLayout
                                            initWithItemDisplayCount:itemDisplayCount
                                            itemHeight:0
                                            itemSpacing:spacing
                                            scrollDirection:UICollectionViewScrollDirectionHorizontal
                                            contentInset:UIEdgeInsetsMake(0, inset, 0, inset)];
    
    self.collectionViewHeightConstraint.constant = size + 40;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

@end
