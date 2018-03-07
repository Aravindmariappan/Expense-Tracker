//
//  ETTodayExpenseViewModel.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETTodayExpenseViewModel.h"

@interface ETTodayExpenseViewModel()

@property NSMutableArray *contentArray;
@property BOOL isTodayExpense;

@end

@implementation ETTodayExpenseViewModel

#pragma mark - Initialization

- (instancetype)initWithTodayExpenses {
    self = [super init];
    if (self) {
        NSArray *totalExpenses = [[[ETDatabaseHandler sharedInstance] getAllExpenses] mutableCopy];
        self.contentArray = [[self filteredArrayForToday:totalExpenses] mutableCopy];
        _isTodayExpense = YES;
    }
    
    return self;
}

- (instancetype)initWithAllExpenses {
    self = [super init];
    if (self) {
        self.contentArray = [[[ETDatabaseHandler sharedInstance] getAllExpenses] mutableCopy];
        _isTodayExpense = NO;
    }
    
    return self;
}

#pragma mark -

- (NSUInteger)getDisplayedItemsCount {
    return self.contentArray.count;
}

- (ETExpenseCellViewModel *)viewModelForCellATIndex:(NSUInteger)index {
    Expense *expense = [self.contentArray objectAtIndex:index];
    ETExpenseCellViewModel *cellVM = [[ETExpenseCellViewModel alloc] initWithExpense:expense];
    
    return cellVM;
}

- (void)refresh {
    NSArray *totalExpenses = [[[ETDatabaseHandler sharedInstance] getAllExpenses] mutableCopy];
    if (self.isTodayExpense) {
        self.contentArray = [[self filteredArrayForToday:totalExpenses] mutableCopy];
    }
    else {
        self.contentArray = [totalExpenses mutableCopy];
    }
}

#pragma mark - Filter

- (NSArray *)filteredArrayForToday:(NSArray *)array {
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *today = [dateFormatter stringFromDate:todayDate];
    return [self filterArray:array byDate:today];
}

- (NSArray *)filterArray:(NSArray *)array byDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *roundOffDate = [dateFormatter dateFromString:dateString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@",roundOffDate];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    
    return filteredArray;
}

@end
