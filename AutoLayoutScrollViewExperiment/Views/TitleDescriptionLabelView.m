//
//  TitleDescriptionLabelView.m
//  AutoLayoutScrollViewExperiment
//
//  Created by Brian Ge on 10/6/13.
//  Copyright (c) 2013 Brian Ge. All rights reserved.
//

#import "TitleDescriptionLabelView.h"
#import "UIView+FLKAutoLayout.h"
#import "Util.h"
@implementation TitleDescriptionLabelView

static const CGFloat paddingSize = 15.0f;

- (id)init {
    self = [super init];
    if (self) {
        LoremIpsum *lorem = [[LoremIpsum alloc] init];
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont randomFont];
            label.text = [lorem words:3];
            label;
        });
        
        self.descriptionLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont randomFont];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                label.text = [lorem sentences:arc4random() % 10 + 100];
            } else {
                label.text = [lorem sentences:arc4random() % 10 + 10];
            }
            label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
            label.numberOfLines = 0;
            label;
        });
        [self addSubview:self.titleLabel];
        [self addSubview:self.descriptionLabel];
        
        NSString *padding = [NSString stringWithFormat:@"%.0f", paddingSize];
        NSString *negativePadding = [NSString stringWithFormat:@"-%.0f", paddingSize];
        [self.titleLabel alignTopEdgeWithView:self.titleLabel.superview predicate:padding];
        [self.titleLabel alignLeadingEdgeWithView:self.titleLabel.superview predicate:padding];
        [self.titleLabel alignTrailingEdgeWithView:self.titleLabel.superview predicate:negativePadding];
        
        [self.descriptionLabel constrainTopSpaceToView:self.titleLabel predicate:padding];
        [self.descriptionLabel alignLeadingEdgeWithView:self.descriptionLabel.superview predicate:padding];
        [self.descriptionLabel alignTrailingEdgeWithView:self.descriptionLabel.superview predicate:negativePadding];
        
        [self alignBottomEdgeWithView:self.descriptionLabel predicate:padding];
    }
    return self;
}

/* We need to override the layoutSubviews method to set preferredMaxLayoutWidth to the UILabels
 * The technique is discussed by the author of FLKAutoLayout Florian Kugler here:
 * http://www.objc.io/issue-3/advanced-auto-layout-toolbox.html#intrinsic_content_size_of_multiline_text
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    // set preferredMaxLayoutWidth after [super layoutSubviews] as this is the first time we have the width of the super view.
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
    // call [super layoutSubviews] again to re-layout the view.
    [super layoutSubviews];
}

@end
