//
//  searchTagButton.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class searchTag;
@interface searchTagButton : UIButton
+ (nonnull instancetype)buttonWithTag: (nonnull searchTag *)tag;

@end

NS_ASSUME_NONNULL_END
