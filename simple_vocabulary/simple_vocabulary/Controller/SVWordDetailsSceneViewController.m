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

@end

@implementation SVWordDetailsSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isWordRus = [self.word hasRussianCharacters];
    self.ruWordTranslationLabel.text = isWordRus ? self.word : self.translationWord;
    self.engWordTranslationLabel.text = isWordRus ? self.translationWord : self.word;
}

@end
