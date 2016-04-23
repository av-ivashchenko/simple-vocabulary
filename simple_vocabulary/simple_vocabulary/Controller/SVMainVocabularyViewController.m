//
//  SVMainVocabularyViewController.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVMainVocabularyViewController.h"

#import "SVWordCell.h"

#import "SVDataManager.h"

@interface SVMainVocabularyViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SVDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SVDataManager *dataManager;

@property (strong, nonatomic) NSArray *words;

@end

@implementation SVMainVocabularyViewController

#pragma mark - init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataManager = [[SVDataManager alloc] init];
        _words = @[@"что", @"why", @"word"];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    self.searchBar.tintColor = self.navigationController.navigationBar.tintColor;
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
 
    self.dataManager.delegate = self;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.words.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordCell" forIndexPath:indexPath];
    
    [cell configureCellForWord:self.words[indexPath.row]];
    
    return cell;
}

#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.dataManager translateWord:searchBar.text];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Data manager delegate

- (void)translateEndedWithError:(NSString *)error {
    
}

@end
