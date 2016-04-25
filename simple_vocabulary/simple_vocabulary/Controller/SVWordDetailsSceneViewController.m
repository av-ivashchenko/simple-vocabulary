//
//  SVWordDetailsSceneViewController.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVWordDetailsSceneViewController.h"

#import "NSString+Characters.h"

@interface SVWordDetailsSceneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ruWordTranslationLabel;
@property (weak, nonatomic) IBOutlet UILabel *engWordTranslationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rusWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *engWordLabel;

@end

@implementation SVWordDetailsSceneViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isWordRus = [self.word hasRussianCharacters];
    self.ruWordTranslationLabel.text = isWordRus ? self.word : self.translationWord;
    self.engWordTranslationLabel.text = isWordRus ? self.translationWord : self.word;
    
    UIColor *barTintColor = self.navigationController.navigationBar.barTintColor;
    UIColor *tintColor = [UIColor globalTintColor];
    
    self.view.backgroundColor = barTintColor;
    
    self.ruWordTranslationLabel.textColor = [tintColor colorWithAlphaComponent:0.5];
    self.engWordTranslationLabel.textColor = [tintColor colorWithAlphaComponent:0.5];
    self.rusWordLabel.textColor = tintColor;
    self.engWordLabel.textColor = tintColor;
    
}

@end
