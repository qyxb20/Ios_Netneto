//
//  addressCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface addressCell : UITableViewCell
@property(nonatomic, strong)addressModel *model;
@property (nonatomic, copy) void (^choseClickBlock) (NSString *addId,addressModel *addmodel);
@property (nonatomic, copy) void (^editClickBlock) (void);
@property (nonatomic, copy) void (^delClickBlock) (NSString *addId,addressModel *addmodel);
@end

NS_ASSUME_NONNULL_END
