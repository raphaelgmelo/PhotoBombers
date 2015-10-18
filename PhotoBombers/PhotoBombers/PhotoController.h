//
//  PhotoController.h
//  PhotoBombers
//
//  Created by Raphael Melo on 18/10/15.
//  Copyright © 2015 raphaelgmelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PhotoController : NSObject

+ (void) imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
