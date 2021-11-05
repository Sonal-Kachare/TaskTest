//
//  AdjustTaskTests.m
//  AdjustTaskTests
//
//  Created by Sonal Kachare on 04/11/21.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "TimeHandlerViewModel.h"

@interface AdjustTaskTests : XCTestCase
@property (nonatomic) TimeHandlerViewModel *timeHandlerVM;

@end

@implementation AdjustTaskTests

- (void)setUp {
    [super setUp];
    self.timeHandlerVM = [[TimeHandlerViewModel alloc] init];
}

- (void)testgetSecondsString {
    NSString *expectedSecondsString = [self.timeHandlerVM getSecondsString];
    XCTAssertNotNil(expectedSecondsString, @"Unable to get seconds string");
}

- (void)testhandleSecondsAPIData {
    NSDictionary *dicData = [[NSDictionary alloc] initWithObjectsAndKeys:@"seconds", @"55", @"101", @"ID", nil];
    NSArray *expectedArray = [self.timeHandlerVM handleSecondsAPIData: dicData];
    NSArray *resultArray = [[NSArray alloc] initWithObjects: @"55", @"ID", nil];
    XCTAssertEqual(expectedArray.firstObject, resultArray.firstObject);
}

- (void)testfetchAPIDataWithSecondsSuccess {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"API Call fetchAPIDataWithSeconds"];
    [self.timeHandlerVM _fetchAPIDataWithSeconds:@"55" completion:^(NSString * _Nonnull result) {
        XCTAssertTrue([result containsString:@"API response::"], @"Success response testcase");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testfetchAPIDataWithSecondsFailure {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"API Call fetchAPIDataWithSeconds"];
    [self.timeHandlerVM _fetchAPIDataWithSeconds:@"sometest" completion:^(NSString * _Nonnull result) {
        XCTAssertTrue([result containsString:@"API failed with error::"], @"Failure response testcase");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)tearDown {
    self.timeHandlerVM = nil;
}

@end
