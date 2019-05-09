//
//  DYMineVerticalCollectionLayout.m
//  Douyin
//
//  Created by Ternence on 2019/5/9.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineVerticalCollectionLayout.h"

@implementation DYMineVerticalCollectionLayout

- (instancetype)initWithTopHeight:(CGFloat)height{
    self = [super init];
    if (self) {
        self.topHeight = height;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray<UICollectionViewLayoutAttributes *> * attributesArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for (UICollectionViewLayoutAttributes *attribute in [attributesArray mutableCopy]) {
        if ([attribute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [attributesArray removeObject:attribute];
        }
    }
    
    [attributesArray addObject:[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        if (attributes.indexPath.section == 0) {
            if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                CGRect rect = attributes.frame;
                
                if (self.collectionView.contentOffset.y + self.topHeight - rect.size.height > rect.origin.y) {
                    rect.origin.y = self.collectionView.contentOffset.y + self.topHeight -  rect.size.height;
                    attributes.frame = rect;
                }
            }
        }
    }
    
    return [attributesArray mutableCopy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


@end
