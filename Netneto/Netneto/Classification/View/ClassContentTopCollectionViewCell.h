//
//  ClassContentTopCollectionViewCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassContentTopCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ClassNameModel *topModel;
@property (nonatomic, copy) void (^itemBlock) (ClassNameModel *model);

@end

NS_ASSUME_NONNULL_END
