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

typedef NS_ENUM(NSInteger, SVVocabularySceneState) {
    SVNoResultsState,
    SVSearchingState,
    SVWebServiceError,
    SVResultsState,
};

@interface SVMainVocabularyViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SVDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SVDataManager *dataManager;
@property (assign, nonatomic) SVVocabularySceneState state;
@property (copy, nonatomic) NSString *webServiceErrorString;

@property (strong, nonatomic) NSArray *words;

@end

@implementation SVMainVocabularyViewController

#pragma mark - init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataManager = [[SVDataManager alloc] init];
        _state = SVNoResultsState;
        _webServiceErrorString = nil;
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
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.dataManager.delegate = self;
    
    [self fetchWords];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowDetail]) {
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
        self.words = [TranslationInfo MR_findAllSortedBy:kDate ascending:NO];
        
        if (self.words.count > 0) {
            self.state = SVResultsState;
        } else {
            self.state = SVNoResultsState;
        }
        
    } else {
        [self searchWordsForSubstring:searchText];
    }
    [self.tableView reloadData];
}

- (void)translateString:(NSString *)string {
    [self.dataManager translateWord:string];
    self.state = SVSearchingState;
}

/** search for substrings */
- (BOOL)searchWordsForSubstring:(NSString *)substring {
    self.words = [TranslationInfo MR_findAllSortedBy:kDate ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"word contains[c] %@", substring]];
    return self.words.count != 0;
}

/** search for whole word */
- (BOOL)searchWord:(NSString *)word {
    self.words = [TranslationInfo MR_findAllSortedBy:kDate ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"word matches[c] %@", word]];
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
    NSUInteger rowsCount = self.words.count;
    if (rowsCount == 0 && self.state != SVResultsState) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:tableView.bounds];
        
        CGFloat originYOffset = 50.0f;
        CGFloat offsetX = 10.0f;
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.frame = CGRectMake(offsetX, 0, backgroundView.bounds.size.width - 2*offsetX, 0);
        infoLabel.numberOfLines = 0;
        infoLabel.textColor = tableView.tintColor;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        
        CGPoint center = backgroundView.center;
        
        switch (self.state) {
            case SVNoResultsState: {
                infoLabel.text = @"Vocabulary is empty. Type the word to find the translation.";
                break;
            }
            case SVSearchingState: {
                infoLabel.text = @"Searching...";
                
                UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
                indicatorView.center = CGPointMake(center.x, originYOffset*2);
                indicatorView.color = tableView.tintColor;
                [indicatorView startAnimating];
                
                [backgroundView addSubview:indicatorView];
                break;
            }
            case SVWebServiceError: {
                infoLabel.text = self.webServiceErrorString;
                break;
            }
            default: {
                break;
            }
        }
        
        [infoLabel sizeToFit];

        infoLabel.center = CGPointMake(center.x, originYOffset - (infoLabel.frame.size.height / 2));
        
        [backgroundView addSubview:infoLabel];
        tableView.backgroundView = backgroundView;
    } else {
        self.tableView.backgroundView = nil;

    }
    
    return rowsCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVWordCell *cell = [tableView dequeueReusableCellWithIdentifier:kWordCell forIndexPath:indexPath];
    
    TranslationInfo *translationInfo = self.words[indexPath.row];
    
    [cell configureCellForWord:translationInfo.word];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [self.tableView.tintColor colorWithAlphaComponent:0.2];
    cell.selectedBackgroundView = view;
    
    return cell;
}

#pragma mark - Search bar delegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isAlphabeticalStringOnly]) {
        BOOL isLatinSearch = [searchBar.text canBeConvertedToEncoding:NSISOLatin1StringEncoding] && [text canBeConvertedToEncoding:NSISOLatin1StringEncoding];
        BOOL isCyrillicSearch = [text hasRussianCharacters] && ([searchBar.text hasRussianCharacters] || searchBar.text.length == 0);
        
        return isLatinSearch || isCyrillicSearch;
        //user tapped backspace
    } else if (text.length == 0 || [text isEqualToString:@"\n"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.searchBar.text length] > 0) {
        //do search in local database
        BOOL isExist = [self searchWordsForSubstring:self.searchBar.text];
        //if doesn't exist - find translation in web service
        if (!isExist) {
            [self translateString:searchText];
        }
    } else {
        [self fetchWords];
    }
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    BOOL isExist = [self searchWord:searchBar.text];
    if (!isExist) {
        [self translateString:searchBar.text];
    }
}

#pragma mark - Data manager delegate

- (void)translateEndedWithError:(NSString *)error {
    if (!error) {
        self.state = SVResultsState;
        self.webServiceErrorString = nil;
        [self fetchWords];
    } else {
        self.state = SVWebServiceError;
        self.webServiceErrorString = error;
        [self.tableView reloadData];
    }
}

@end
