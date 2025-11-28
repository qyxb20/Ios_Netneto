//
//  HomeSectionViewController.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeSectionViewController : BaseViewController
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, assign) BOOL isClass;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, assign) BOOL isTag;
@property (nonatomic, strong) NSString *tagId;
@end

NS_ASSUME_NONNULL_END
