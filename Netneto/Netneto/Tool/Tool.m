//
//  Tool.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "Tool.h"

@implementation Tool
#pragma mark - 根据图片url获取图片尺寸

+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
     
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
     
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
#pragma mark -  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
#pragma mark -  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

#pragma mark -  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
   
   
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
     
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
        
}
#pragma mark -根据宽度求高度
/**
 @param text 计算的内容
 @param width 计算的宽度
 @param font font字体大小
 @return 放回label的高度
 */
 
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
 
{
 
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
 
                                     options:NSStringDrawingUsesLineFragmentOrigin
 
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
 
    
  
    return rect.size.height;
 
}
#pragma mark -根据高度求宽度
/**
 @param text 计算的内容
 @param height 计算的高度
 @param font font字体大小
 @return 放回label的宽度
 */
+ (CGFloat)getLabelWidthWithText:(NSString *)text height:(CGFloat)height font: (CGFloat)font
 
{
 
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
 
                                     options:NSStringDrawingUsesLineFragmentOrigin
 
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
 
    
 
    return rect.size.width;
 
}
#pragma mark - 计算html字符串高度
+(CGFloat)getAttHtmHeight:(NSString *)str width:(CGFloat)wid font:(CGFloat)font{
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
     
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} range:NSMakeRange(0, htmlString.length)];
     
    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){wid, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
     
    return textSize.height;
   }
#pragma mark - 获取时间戳
+ (NSNumber *)getCurrentTimeNumber {
    return [NSNumber numberWithLong:(long)[[NSDate date] timeIntervalSince1970] * 1000];
}
#pragma mark - 字典转json字符串
+ (NSString *)DictionaryToJsonStr:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = @"";
    if (!error) {
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return jsonStr;
}
#pragma mark - 压缩图片
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

#pragma mark -view转成image
+ (UIImage*) imageWithUIView:(UIView*) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}
#pragma mark - 获取时间戳
+(NSInteger)getTimeStrWithString:(NSString*)str{
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
   
    NSDate*tempDate = [dateFormatter dateFromString:str];
     

    return  (long)[tempDate timeIntervalSince1970];
}
#pragma mark - 获取当前时间
+(NSString *)getCurtenTimeStrWithString{
    
    NSDate *currentDate = [NSDate date];
           // 将时间转换为字符串
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
          [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
         
           NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        
    return currentDateString;
}
#pragma mark -时间字符串转格式
+(NSString *)getCurtenTimeStrWithStringYYYYMMDD{
    
    NSDate *currentDate = [NSDate date];
           // 将时间转换为字符串
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"YYYYMMDD"];
          [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
         
           NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        
    return currentDateString;
}
#pragma mark -获取字符串（时分秒）
+(NSString *)getCurtenSecondStrWithString{
    
    NSDate *currentDate = [NSDate date];
           // 将时间转换为字符串
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"HHmmss"];
          [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
         
           NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        
    return currentDateString;
}
#pragma mark - 比较时间
+(NSInteger)getCompareTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];

        [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//根据自己的需求定义格式

        NSDate* startDate = [formater dateFromString:startTime];

        NSDate* endDate = [formater dateFromString:endTime];

        NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];

        NSString *timeStr = [NSString stringWithFormat:@"%f",time];

        NSLog(@"time=%f",time);


    return [timeStr intValue];
}
#pragma mark - 获取季节
+(NSString *)getCurrentSeason{
    NSDate *currentDate = [NSDate date];
      NSCalendar *calendar = [NSCalendar currentCalendar];
      NSInteger components = [calendar component:NSCalendarUnitMonth fromDate:currentDate];
      
      NSString *season = @"";
   
      switch (components) {
          case 12:
          case 1:
          case 2:
              season = @"Winter";

              break;
          case 3:
          case 4:
          case 5:
              season = @"Spring";
//              season = @"Autumn";
              break;
          case 6:
          case 7:
          case 8:
              season = @"Summer";
              break;
          case 9:
          case 10:
          case 11:
              season = @"Autumn";
              break;
          default:
              break;
      }
      return season;
}
#pragma mark - 获取图片大小（MB）
+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
     NSString *bytes;
     if (dataLength >= 0.1 * (1024 * 1024)) {
     bytes = [NSString stringWithFormat:@"%.1fM",dataLength/1024/1024.0];
       }
     else if (dataLength >= 1024) {
    bytes = [NSString stringWithFormat:@"%0.1fK",dataLength/1024.0];

     }
     else {
      bytes = [NSString stringWithFormat:@"%zdB",dataLength];
      }
    
      return bytes;
}
@end
