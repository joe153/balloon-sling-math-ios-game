//
//  SlingMathTest.m
//  SlingMathTest
//
//  Created by joe on 8/19/12.
//
//

#import "SlingMathTest.h"

#import "ServiceManager.h"

@implementation SlingMathTest

- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}


- (void)testAddition {
    [self testCategory:ADDITION :1];
}

- (void)testSubtraction {
    [self testCategory:SUBTRACTION :1];
}

- (void)testMultiplication {
    [self testCategory:MULTIPLICATION :9];
}

- (void)testDivision {
    [self testCategory:DIVISION :9];
}

- (void)testCategory:(GameCategory)c:(int)level {
    ServiceManager *serviceManager = [[ServiceManager alloc] init];

    for (int i = 1; i < 10; i++) {
        Question *q = [serviceManager getQuestion:level :c];
        NSLog(@"%@", q);
    }
}
@end
