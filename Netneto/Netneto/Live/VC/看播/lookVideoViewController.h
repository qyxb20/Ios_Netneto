//
//  lookVideoViewController.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/9.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface lookVideoViewController : BaseViewController
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *showtype;
@property (nonatomic, strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
