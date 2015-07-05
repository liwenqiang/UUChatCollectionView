//
//  UUChatCollectionViewFlowLayoutInvalidationContext.h
//  UUChatCollectionView
//
//  Created by zhangyu on 15/7/5.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUChatCollectionViewFlowLayoutInvalidationContext : UICollectionViewFlowLayoutInvalidationContext

@property (nonatomic, assign) BOOL invalidateFlowLayoutMessagesCache;

+ (instancetype)context;

@end
