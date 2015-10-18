//
//  PhotoCell.m
//  PhotoBombers
//
//  Created by Raphael Melo on 18/10/15.
//  Copyright © 2015 raphaelgmelo. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage imageNamed:@"Treehouse"];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;

}

@end
