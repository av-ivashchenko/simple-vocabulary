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

#import "TranslationInfo.h"

#import "NSString+Characters.h"

#import "SVWordDetailsSceneViewController.h"

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
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
 
    self.dataManager.delegate = self;
    
    [self fetchWords];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        SVWordDetailsSceneViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TranslationInfo *translationInfo = self.words[indexPath.row];
        controller.word = translationInfo.word;
        controller.translationWord = translationInfo.translation;
    }
}

#pragma mark - Data handling

- (void)fetchWords {
    NSString *searchText = self.searchBar.text;
    if ([searchText length] == 0) {
        self.words = [TranslationInfo MR_findAllSortedBy:@"date" ascending:NO];
    } else {
        [self searchWordsForSubstring:searchText];
    }
    [self.tableView reloadData];
}

- (BOOL)searchWordsForSubstring:(NSString *)substring {
    self.words = [TranslationInfo MR_findAllSortedBy:@"date" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"word contains[c] %@", substring]];
    return self.words.count != 0;
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
    
    TranslationInfo *translationInfo = self.words[indexPath.row];
    
    [cell configureCellForWord:translationInfo.word];
    
    return cell;
}

#pragma mark - Search bar delegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isAlphabeticalStringOnly]) {
        BOOL isLatinSearch = [searchBar.text canBeConvertedToEncoding:NSISOLatin1StringEncoding] && [text canBeConvertedToEncoding:NSISOLatin1StringEncoding];
        BOOL isCyrillicSearch = [text hasRussianCharacters] && ([searchBar.text hasRussianCharacters] || searchBar.text.length == 0);
        
        return isLatinSearch || isCyrillicSearch;
        //user tapped backspace
    } else if (text.length == 0)
        return YES;
    else {
        return NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.searchBar.text length] > 0) {
        //do search in local database
        BOOL isExist = [self searchWordsForSubstring:self.searchBar.text];
        [self.tableView reloadData];
        //if doesn't exist - find translation in web service
        if (!isExist) {
            NSLog(@"*** Search for translation of '%@'", searchText);
            [self.dataManager translateWord:searchText];
        }
    } else {
        [self fetchWords];
        [self.tableView reloadData];
    }
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
    if (!error) {
        [self fetchWords];
    }
}

@end
