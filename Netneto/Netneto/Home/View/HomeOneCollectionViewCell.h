//
//  HomeOneCollectionViewCell.h
//  Netneto
//
//  Created by apple on 2024/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeOneCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)NSArray *dataArr;
@property (nonatomic, copy) void (^cellItemClickBlock) (NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
