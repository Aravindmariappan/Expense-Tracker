//
//  ETCategoryListViewController.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETCategoryListViewController.h"

@interface ETCategoryListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property NSArray *contentArray;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation ETCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDataSource];
    [self configureCategoryTableView:self.categoryTableView];
}

- (void)configureDataSource {
    self.contentArray = [[ETDatabaseHandler sharedInstance] getAllCategories];
}

- (void)configureCategoryTableView:(UITableView *)categoryTableView {
    [categoryTableView setDelegate:self];
    [categoryTableView setDataSource:self];
    [categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
}

#pragma mark -

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExpenseCategory *category = [self.contentArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    [cell.textLabel setText:category.expenseCategoryName];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpenseCategory *category = [self.contentArray objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCategory:)]) {
        [self.delegate didSelectCategory:category];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
