//
//  XJCollectionViewCenterLayout.h
//  Demo
//
//  Created by XJIMI on 2017/10/12.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJCollectionViewCenterLayout : UICollectionViewFlowLayout

/*
     itemDisplayCount : 螢幕範圍能顯示的區塊數量
 */

+ (instancetype)initWithItemDisplayCount:(NSInteger)itemDisplayCount
                              itemHeight:(CGFloat)itemHiehgt
                             itemSpacing:(CGFloat)itemSpacing
                         scrollDirection:(UICollectionViewScrollDirection)scrollDirection
                            contentInset:(UIEdgeInsets)contentInset;

@end
