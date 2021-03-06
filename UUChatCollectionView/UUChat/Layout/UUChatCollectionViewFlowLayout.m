//
//  UUChatCollectionViewFlowLayout.m
//  UUChatCollectionView
//
//  Created by zhangyu on 15/7/5.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUChatCollectionViewFlowLayout.h"
#import "Chat-Import.h"
#import "Chat-Macros.h"

@interface UUChatCollectionViewFlowLayout()

@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, assign) CGFloat messageBubbleMaxWidth;

@end

@implementation UUChatCollectionViewFlowLayout

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self configUI];
    }
    
    return self;
}

+ (Class)layoutAttributesClass
{
    return [UUChatCollectionViewLayoutAttributes class];
}

+ (Class)invalidationContextClass
{
    return [UUChatCollectionViewFlowLayoutInvalidationContext class];
}


#pragma mark - life cycle

- (void)configUI{
    
    self.scrollDirection    = UICollectionViewScrollDirectionVertical;
    self.sectionInset       = UIEdgeInsetsMake(0, 4.0f, 10.0f, 4.0f);
    self.minimumLineSpacing = 4.0f;
//    self.estimatedItemSize  = CGSizeMake(ScreenWidth, 100);
    
    //    _outgoingAvatarSize     = _incomingAvatarSize = kUserAvatarSize;
    //    _timestampInsets        = UIEdgeInsetsMake(15, 0, 0, 0);
    //    _usernameInsets         = UIEdgeInsetsMake(10, 0, 0, 0);
    //    _messageBubbleInsets    = UIEdgeInsetsMake(5, 0, 0, 0);
    //    _messageInsets          = UIEdgeInsetsMake(10, 20, 10, 15);
    
    _messageFont = [UIFont systemFontOfSize:17];
    _messageBubbleMaxWidth = ScreenWidth -140;
}

//- (void)invalidateLayoutWithContext:(UICollectionViewFlowLayoutInvalidationContext *)context
//{
//    if (context.invalidateDataSourceCounts) {
//        context.invalidateFlowLayoutAttributes = YES;
//        context.invalidateFlowLayoutDelegateMetrics = YES;
//    }
//    
////    if (context.invalidateFlowLayoutAttributes
////        || context.invalidateFlowLayoutDelegateMetrics) {
////        [self jsq_resetDynamicAnimator];
////    }
////    
////    if (context.invalidateFlowLayoutMessagesCache) {
////        [self jsq_resetLayout];
////    }
//    
//    [super invalidateLayoutWithContext:context];
//}


- (void)prepareLayout{
    
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *attributesInRect = [super layoutAttributesForElementsInRect:rect];
    
    [attributesInRect enumerateObjectsUsingBlock:^(UUChatCollectionViewLayoutAttributes *attributesItem, NSUInteger idx, BOOL *stop) {
        if (attributesItem.representedElementCategory == UICollectionElementCategoryCell) {
            
            [self configureMessageCellLayoutAttributes:attributesItem];
            
        }else attributesItem.zIndex = -1;
    }];
    
    return attributesInRect;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UUChatCollectionViewLayoutAttributes *customAttributes = (UUChatCollectionViewLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    
    if (customAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        
        [self configureMessageCellLayoutAttributes:customAttributes];
    }
    
    return customAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger index, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            
            
            CGFloat collectionViewHeight = CGRectGetHeight(self.collectionView.bounds);
            
            UUChatCollectionViewLayoutAttributes *attributes = [UUChatCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];
            
            if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                [self configureMessageCellLayoutAttributes:attributes];
            }
            
            attributes.frame = CGRectMake(0.0f,
                                          collectionViewHeight + CGRectGetHeight(attributes.frame),
                                          CGRectGetWidth(attributes.frame),
                                          CGRectGetHeight(attributes.frame));
            
        }
    }];
}

- (CGSize )messageBubbleSizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    UUChatMessage *messageItem = [self.collectionView.dataSource collectionView:self.collectionView messageDataForItemAtIndexPath:indexPath];
    
    CGSize finalSize = CGSizeZero;
    
    CGRect stringRect = [messageItem.message boundingRectWithSize:CGSizeMake(_messageBubbleMaxWidth, CGFLOAT_MAX)
                                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                      attributes:@{ NSFontAttributeName : _messageFont }
                                                         context:nil];
    finalSize.height += 20;
    finalSize.height += 20;
    finalSize.height += stringRect.size.height;
    
    return finalSize;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize messageBubbleSize = [self messageBubbleSizeForItemAtIndexPath:indexPath];
    
    UUChatCollectionViewLayoutAttributes *attributes = (UUChatCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
    
    CGFloat finalHeight = messageBubbleSize.height;
    finalHeight += attributes.cellTimeStampHeight;
    finalHeight += attributes.cellUserNameHeight;
    finalHeight += attributes.messageBubbleInsets.top;
    finalHeight += attributes.messageFrameInsets.top + attributes.messageFrameInsets.bottom;
    
    CGFloat itemWidth = ScreenWidth -self.sectionInset.left - self.sectionInset.right;
    return CGSizeMake(itemWidth, ceilf(finalHeight));
}

- (void)configureMessageCellLayoutAttributes:(UUChatCollectionViewLayoutAttributes *)layoutAttributes{

//    NSIndexPath *indexPath = layoutAttributes.indexPath;
    
//    CGSize messageBubbleSize = [self messageBubbleSizeForItemAtIndexPath:indexPath];
    
    layoutAttributes.messageBubbleMaxWidth = _messageBubbleMaxWidth;
    
    layoutAttributes.messageBubbleInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layoutAttributes.messageFrameInsets = UIEdgeInsetsMake(10, 20, 10, 15);
    
    layoutAttributes.messageFont = _messageFont;
    
    layoutAttributes.incomingAvatarSize = kUserAvatarSize;
    
    layoutAttributes.outgoingAvatarSize = kUserAvatarSize;
    
    layoutAttributes.cellUserNameHeight = 10;
    
    layoutAttributes.cellTimeStampHeight = 15;
    
}
@end
