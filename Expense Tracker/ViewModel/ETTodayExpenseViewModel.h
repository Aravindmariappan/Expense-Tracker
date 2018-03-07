//
//  ETTodayExpenseViewModel.h
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETExpenseCellViewModel.h"

@interface ETTodayExpenseViewModel : NSObject

- (instancetype)initWithTodayExpenses;
- (instancetype)initWithAllExpenses;

- (NSUInteger)getDisplayedItemsCount;

- (ETExpenseCellViewModel *)viewModelForCellATIndex:(NSUInteger)index;

- (void)refresh;

@end
