//
//  TimeHandlerViewModel.m
//  AdjustTask
//
//  Created by Sonal Kachare on 04/11/21.
//

#import "TimeHandlerViewModel.h"

@implementation TimeHandlerViewModel
NSOperationQueue *apiOperationQueue;

- (id)init {
    self = [super init];
    if(self) {
        apiOperationQueue = [[NSOperationQueue alloc] init];
        apiOperationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)dealloc {
    [apiOperationQueue cancelAllOperations];
}

- (NSString *)getSecondsString {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
    return [timeString substringFromIndex:6];
}

- (void)fetchAPIDataWithSeconds:(NSString*)seconds {
    [apiOperationQueue addOperationWithBlock:^{
        [self _fetchAPIDataWithSeconds:seconds completion:^(NSString *result) {
            NSLog(@"%@", result);
        }];
    }];
}

- (void)_fetchAPIDataWithSeconds:(NSString*)seconds completion:(void (^)(NSString *result))completion {
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"seconds", seconds, nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *dicData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (dicData != nil) {
                NSArray *sortedArray = [self handleSecondsAPIData: dicData];
                NSLog(@"API response:: Seconds: %@, ID: %@", sortedArray.firstObject, dicData[@"id"]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSString *successString = [NSString stringWithFormat:@"API response:: Seconds: %@, ID: %@", sortedArray.firstObject, dicData[@"id"]];
                    completion(successString);
                });
            }
        } else {
            NSString *failureString = [NSString stringWithFormat:@"API failed with error:: %@", error];
            completion(failureString);
        }
    }];

    [postDataTask resume];
}

- (NSArray *)handleSecondsAPIData:(NSDictionary *)response {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [response.allKeys sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

@end
