//
//  SVWordCell.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVWordCell.h"

@interface SVWordCell ()

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@end

@implementation SVWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor blackColor];
    self.wordLabel.textColor = [UIColor whiteColor];
}

- (void)configureCellForWord:(NSString *)word {
    self.wordLabel.text = word;
}

@end
