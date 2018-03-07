//
//  ETDatabaseHandler.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETDatabaseHandler.h"

#define kDefaultUserID 1111.0f

#define kDefaultCategories @[@"Bills", @"Food", @"Loan", @"Entertainment", @"Rent", @"Shopping"]

@implementation ETDatabaseHandler

static ETDatabaseHandler *sharedInstance = nil;

#pragma mark - Initailization

+ (ETDatabaseHandler *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSManagedObjectContext *)mainContext {
    return self.persistentContainer.viewContext;
}

#pragma mark -

- (User *)defaultUser {
    if (_defaultUser == nil) {
        _defaultUser = [self fetchUserWithId:kDefaultUserID];
        if (_defaultUser == nil) {
            _defaultUser = [self insertDefaultUser];
            [self insertDefaultCategories];
        }
    }
    
    return _defaultUser;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Expense_Tracker"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - User

- (User *)fetchUserWithId:(NSUInteger)userID {
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"userID = %f",userID];
    NSFetchRequest *fetchRequest = [User fetchRequest];
    [fetchRequest setPredicate:idPredicate];
    NSArray *userPresent = [self.mainContext executeFetchRequest:fetchRequest error:nil];
    User *fetchedUser = [userPresent firstObject];
    
    return fetchedUser;
}

- (User *)insertDefaultUser {
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.persistentContainer.viewContext];
    [user setName:@"Default"];
    [user setUserID:kDefaultUserID];
    [self saveContext];
    
    return user;
}

#pragma mark - Expense

- (Expense *)insertNewExpense {
    Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:self.persistentContainer.viewContext];
    newExpense.expenseID = [self generateUuidString];
    newExpense.amount = 0;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    newExpense.date = date;
    [self.defaultUser addExpensesObject:newExpense];
    
    return newExpense;
}

- (NSArray *)getAllExpenses {
    NSFetchRequest *fetchRequest = [Expense fetchRequest];
    NSArray *allExpenses = [self.mainContext executeFetchRequest:fetchRequest error:nil];
    
    return allExpenses;
}

- (void)deleteExpense:(Expense *)expense {
    [self.mainContext deleteObject:expense];
    [self saveContext];
}

#pragma mark - ExpenseCategory

- (NSArray *)getAllCategories {
    NSFetchRequest *fetchRequest = [ExpenseCategory fetchRequest];
    NSArray *allCategories = [self.mainContext executeFetchRequest:fetchRequest error:nil];
    
    return allCategories;
}

- (void)insertDefaultCategories {
    for (NSString *categoryName in kDefaultCategories) {
        ExpenseCategory *category = [self fetchExpenseCategoryWithName:categoryName];
        if (category == nil) {
            category = [self insertExpenseCategoryWithName:categoryName];
            [self saveContext];
        }
    }
}

- (ExpenseCategory *)fetchExpenseCategoryWithName:(NSString *)categoryName {
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"expenseCategoryName = %@",categoryName];
    NSFetchRequest *fetchRequest = [ExpenseCategory fetchRequest];
    [fetchRequest setPredicate:idPredicate];
    NSArray *categoryPresent = [self.mainContext executeFetchRequest:fetchRequest error:nil];
    ExpenseCategory *category = [categoryPresent firstObject];

    return category;
}

- (ExpenseCategory *)insertExpenseCategoryWithName:(NSString *)expenseCategoryName {
    ExpenseCategory *newExpenseCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseCategory" inManagedObjectContext:self.persistentContainer.viewContext];
    newExpenseCategory.expenseCategoryName = expenseCategoryName;
    newExpenseCategory.expenseCategoryID = [self generateUuidString];

    return newExpenseCategory;
}

#pragma mark - GUUID

- (NSString *)generateUuidString
{
    // returns a new autoreleased UUID string
    
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

@end
