//
//  LanguageTool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "LanguageTool.h"
static LanguageTool *tool = nil;
@interface LanguageTool()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *languageStr;
@property(nonatomic,copy)NSString *languageType;


@end
@implementation LanguageTool
+(id)shareInstance {
    @synchronized (self) {
        if (tool == nil) {
            tool = [[LanguageTool alloc]init];
        }
    }
    return tool;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    if (tool == nil) {
        tool = [super allocWithZone:zone];
    }
    return tool;
}

-(NSString *)getLangStringForKey:(NSString *)key withList:(NSString *)list {
         self.languageStr = @"ja";
        NSString *path = [[NSBundle mainBundle]pathForResource:self.languageStr ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
   
    
    NSString *str = @"";
        if (self.bundle) {
            str = NSLocalizedStringFromTableInBundle(key, list, self.bundle, @"");
            
            return str;
    }
  
    str =  NSLocalizedStringFromTable(key, list, @"");
    
    return str;
}




@end
