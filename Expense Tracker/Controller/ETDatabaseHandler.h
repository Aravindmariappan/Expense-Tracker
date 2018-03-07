//
//  ETDatabaseHandler.h
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Expense+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "ExpenseCategory+CoreDataClass.h"

@interface ETDatabaseHandler : NSObject

+(ETDatabaseHandler *)sharedInstance;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) User *defaultUser;

- (void)saveContext;

#pragma mark - Expense

- (Expense *)insertNewExpense;
- (NSArray *)getAllExpenses;
- (void)deleteExpense:(Expense *)expense;

#pragma mark - Category

- (NSArray *)getAllCategories;

@end
