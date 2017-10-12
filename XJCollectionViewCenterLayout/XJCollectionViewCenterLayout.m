//
//  XJCollectionViewCenterLayout.m
//  Demo
//
//  Created by XJIMI on 2017/10/12.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import "XJCollectionViewCenterLayout.h"

@implementation XJCollectionViewCenterLayout

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
            proposedCenterOffset = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
            break;

        case UICollectionViewScrollDirectionVertical:
            proposedCenterOffset = proposedContentOffset.y + self.collectionView.bounds.size.height / 2;
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
            newOffset = candidateAttributesForRect.center.x - self.collectionView.bounds.size.width / 2;
            offset = newOffset - self.collectionView.contentOffset.x;

            if ((velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0))
            {
                CGFloat pageWidth = self.itemSize.width + self.minimumLineSpacing;
                newOffset += velocity.x > 0 ? pageWidth : -pageWidth;
            }
            return CGPointMake(newOffset, proposedContentOffset.y);

        case UICollectionViewScrollDirectionVertical:
            newOffset = candidateAttributesForRect.center.y - self.collectionView.bounds.size.height / 2;
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

@end
