//
//  PhotoCell.m
//  PhotoBombers
//
//  Created by Raphael Melo on 18/10/15.
//  Copyright © 2015 raphaelgmelo. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotosViewController.h"

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
        
        
        // Gesture recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        
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


- (void) like{
    
    // Like photo on instagram (NOT SUPPORTED ANYMORE)
    /*
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken ];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Response: %@", response);
        
    }];
    [task resume];
     */
    
    
    // Show simple alert
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Liked!" message:nil preferredStyle:UIAlertControllerStyleAlert];

    id rootViewController=[UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController=[((UINavigationController *)rootViewController).viewControllers objectAtIndex:0];
    }
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    
    
    // Dismiss alert after timer
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    });
    
    
}

@end
