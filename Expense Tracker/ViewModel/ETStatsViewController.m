//
//  ETStatsViewController.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETStatsViewController.h"

@interface ETStatsViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property NSArray *contentArray;
@property float totalExpenseAmount;

@end

@implementation ETStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configureData];
    [self configureTableView:self.statsTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureData];
    [self.statsTableView reloadData];
}

- (void)configureData {
    self.contentArray = [[ETDatabaseHandler sharedInstance] getAllCategories];
    NSArray *allExpenses = [[ETDatabaseHandler sharedInstance] getAllExpenses];
    self.totalExpenseAmount = [self totalAmountOfExpenses:allExpenses];
}


- (void)configureTableView:(UITableView *)tableView {
    [tableView setDataSource:self];
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExpenseCategory *category = [self.contentArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellIdentifier"];
    }
    NSString *categoryExpensePercent = [NSString stringWithFormat:@"%@",category.expenseCategoryName];
    [cell.textLabel setText:categoryExpensePercent];

    [cell.detailTextLabel setText:[self percentOfCategory:category inTotal:self.totalExpenseAmount]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentArray count];
}

#pragma mark - Get Percent

- (NSString *)percentOfCategory:(ExpenseCategory *)category inTotal:(float)totalExpense {
    float categoryExpense = [self totalAmountOfExpenses:category.expenses.allObjects];
    float percent = categoryExpense/totalExpense * 100;
    
    return [NSString stringWithFormat:@"%.2f %%",percent];
}

- (float)totalAmountOfExpenses:(NSArray<Expense *> *)expenses {
    float totalExpenseAmount = 0;
    for (Expense *expense in expenses) {
        totalExpenseAmount += expense.amount;
    }
    
    return totalExpenseAmount;
}
@end
