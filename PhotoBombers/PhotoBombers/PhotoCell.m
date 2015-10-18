//
//  PhotoCell.m
//  PhotoBombers
//
//  Created by Raphael Melo on 18/10/15.
//  Copyright © 2015 raphaelgmelo. All rights reserved.
//

#import "PhotoCell.h"

#import <SAMCache.h>

@implementation PhotoCell


-(void)setPhoto:(NSDictionary *)photo{
    _photo = photo;
    
    NSURL *url = [[NSURL alloc] initWithString:_photo[@"images"][@"thumbnail"][@"url"]];
    
    [self downloadPhotoWithURL:url];
    
}


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


-(void)downloadPhotoWithURL: (NSURL *) url{
    
    NSString *key = [[NSString alloc] initWithFormat:@"%@-thumbnail", self.photo[@"id"]];
    UIImage *photo = [[SAMCache sharedCache] imageForKey:key];
    
    if (photo) {
        self.imageView.image = photo;
        return;
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    }];
    
    [task resume];
    
}

@end
