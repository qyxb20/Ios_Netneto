//
//  searchTagView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/22.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface searchTagView : BaseView
@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property (assign, nonatomic) CGFloat regularWidth; //!< 固定宽度
@property (nonatomic,assign ) CGFloat regularHeight; //!< 固定高度
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^didTapTagAtIndex)(NSUInteger index);

- (void)addTag: (nonnull searchTag *)tag;
- (void)insertTag: (nonnull searchTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag: (nonnull searchTag *)tag;
- (void)removeTagAtIndex: (NSUInteger)index;
- (void)removeAllTags;
@end

NS_ASSUME_NONNULL_END
