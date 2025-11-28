//
//  GoodsSureOrderTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsSureOrderTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *couponDic;
@property (nonatomic, strong) UITextView *tx;
@property (nonatomic, strong) UIButton *quanBtn;
@property (nonatomic, copy) void (^couponClickBlock) (NSArray *arr,NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
