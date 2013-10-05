//
//  Util.h
//  AutoLayoutScrollViewExperiment
//
//  Created by Brian Ge on 10/4/13.
//  Copyright (c) 2013 Brian Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (experiment)

+ (UIColor*)randomColor;

@end

@interface UIFont (experiment)

+ (UIFont*) randomFont;

@end

@interface LoremIpsum : NSObject

- (NSString*) words:(NSUInteger)count;
- (NSString*) sentences:(NSUInteger)count;
- (NSString*) randomWord;

@end

@interface UIView (experiment)

+ (void) colorViewsRandomly:(UIView*)view;
+ (void) logViewRect:(UIView*)view level:(NSInteger)level;

@end
