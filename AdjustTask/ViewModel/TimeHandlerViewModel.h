//
//  TimeHandlerViewModel.h
//  AdjustTask
//
//  Created by Sonal Kachare on 04/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeHandlerViewModel : NSObject
- (void)fetchAPIDataWithSeconds:(NSString*)seconds;
- (void)_fetchAPIDataWithSeconds:(NSString*)seconds completion:(void (^)(NSString *result))completion;
- (NSString *)getSecondsString;
- (NSArray *)handleSecondsAPIData:(NSDictionary *)response;
@end

NS_ASSUME_NONNULL_END
