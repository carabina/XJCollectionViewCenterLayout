//
//  XJCollectionViewCenterLayout.m
//  Demo
//
//  Created by XJIMI on 2017/10/12.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import "XJCollectionViewCenterLayout.h"

@interface XJCollectionViewCenterLayout ()

/*
     itemDisplayCount : 螢幕範圍能顯示的區塊數量
 */
@property (nonatomic, assign) NSInteger itemDisplayCount;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, assign) CGFloat adjustPos;

@end

@implementation XJCollectionViewCenterLayout

+ (instancetype)initWithItemDisplayCount:(NSInteger)itemDisplayCount
                              itemHeight:(CGFloat)itemHiehgt
                             itemSpacing:(CGFloat)itemSpacing
                         scrollDirection:(UICollectionViewScrollDirection)scrollDirection
                            contentInset:(UIEdgeInsets)contentInset
{
    XJCollectionViewCenterLayout *layout = [[XJCollectionViewCenterLayout alloc] init];
    layout.itemDisplayCount = itemDisplayCount;
    layout.itemHeight = itemHiehgt;
    layout.scrollDirection = scrollDirection;
    layout.minimumLineSpacing = itemSpacing;
    layout.contentInset = contentInset;
    return layout;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.collectionView.contentInset = self.contentInset;
    
    CGSize itemSize = self.collectionView.bounds.size;
    itemSize.width -= self.collectionView.contentInset.left;
    itemSize.width -= self.collectionView.contentInset.right;

    if (self.itemDisplayCount > 1)
    {
        itemSize.width = (itemSize.width - ((self.itemDisplayCount - 1) * self.minimumLineSpacing)) / self.itemDisplayCount;
        CGFloat rate = (self.itemDisplayCount % 2) ? 1.0f : 0.5f;
        self.adjustPos = (itemSize.width + self.minimumLineSpacing) * rate - self.minimumLineSpacing;
    }
    itemSize.height = self.itemHeight ? : itemSize.width;
    self.itemSize = itemSize;
}

- (CGRect)determineProposedRectWtihProposedContentOffset:(CGPoint)proposedContentOffset
{
    CGSize size = self.collectionView.bounds.size;
    CGPoint origin;

    switch (self.scrollDirection)
    {
        case UICollectionViewScrollDirectionHorizontal:
            origin = CGPointMake(proposedContentOffset.x, 0);
            break;

        case UICollectionViewScrollDirectionVertical:
            origin = CGPointMake(0, proposedContentOffset.y);
            break;
    }
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (UICollectionViewLayoutAttributes *)attributesForRectWithLayoutAttributes:(NSArray *)layoutAttributes
                                                      proposedContentOffset:(CGPoint)proposedContentOffset
{
    UICollectionViewLayoutAttributes *candidateAttributes;
    CGFloat proposedCenterOffset;

    switch (self.scrollDirection)
    {
        case UICollectionViewScrollDirectionHorizontal:
        {
            proposedCenterOffset = proposedContentOffset.x + (self.collectionView.bounds.size.width * .5) + self.adjustPos;
            break;
        }
        case UICollectionViewScrollDirectionVertical:
            proposedCenterOffset = proposedContentOffset.y + (self.collectionView.bounds.size.height * .5) + self.adjustPos;
            break;
    }

    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes)
    {
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }

        if (candidateAttributes == nil) {
            candidateAttributes = attributes;
            continue;
        }

        switch (self.scrollDirection)
        {
            case UICollectionViewScrollDirectionHorizontal:
                if (fabs(attributes.center.x - proposedCenterOffset) < fabs(candidateAttributes.center.x - proposedCenterOffset)) {
                    candidateAttributes = attributes;
                }
                break;

            case UICollectionViewScrollDirectionVertical:
                if (fabs(attributes.center.y - proposedCenterOffset) < fabs(candidateAttributes.center.y - proposedCenterOffset)) {
                    candidateAttributes = attributes;
                }
                break;
        }
    }
    return candidateAttributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect proposedRect = [self determineProposedRectWtihProposedContentOffset:proposedContentOffset];
    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:proposedRect];
    UICollectionViewLayoutAttributes *candidateAttributesForRect = [self attributesForRectWithLayoutAttributes:layoutAttributes
                                                                                         proposedContentOffset:proposedContentOffset];
    CGFloat newOffset;
    CGFloat offset;

    switch (self.scrollDirection)
    {
        case UICollectionViewScrollDirectionHorizontal:
            newOffset = candidateAttributesForRect.center.x - (self.collectionView.bounds.size.width * .5) - self.adjustPos;
            offset = newOffset - self.collectionView.contentOffset.x;

            if ((velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0))
            {
                CGFloat pageWidth = self.itemSize.width + self.minimumLineSpacing;
                newOffset += velocity.x > 0 ? pageWidth : -pageWidth;
            }
            return CGPointMake(newOffset, proposedContentOffset.y);

        case UICollectionViewScrollDirectionVertical:
            newOffset = candidateAttributesForRect.center.y - (self.collectionView.bounds.size.height * .5) - self.adjustPos;
            offset = newOffset - self.collectionView.contentOffset.y;

            if ((velocity.y < 0 && offset > 0) || (velocity.y > 0 && offset < 0))
            {
                CGFloat pageHeight = self.itemSize.height + self.minimumLineSpacing;
                newOffset += velocity.y > 0 ? pageHeight : -pageHeight;
            }
            return CGPointMake(proposedContentOffset.x, newOffset);
    }

    return proposedContentOffset;
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return itemSize;
}*/

@end
