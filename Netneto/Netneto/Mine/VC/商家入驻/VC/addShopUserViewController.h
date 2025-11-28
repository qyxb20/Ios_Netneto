//
//  addShopUserViewController.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/10.
//

#import "BaseViewController.h"
#import "PdfCollectionViewCell.h"
#import "addShopAddCustomLineView.h"
NS_ASSUME_NONNULL_BEGIN

@interface addShopUserViewController : BaseViewController
@property(nonatomic, strong)NSString *rejectId;
@property(nonatomic, strong)NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
