//
//  ViewController.m
//  AutoLayoutScrollViewExperiment
//
//  Created by Brian Ge on 10/4/13.
//  Copyright (c) 2013 Brian Ge. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+FLKAutoLayout.h"
#import "Util.h"
#import "TitleDescriptionLabelView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *contentViewSectionOne;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *contentViewSectionTwo;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *lastNameLabel;
@property (nonatomic, strong) TitleDescriptionLabelView *titleDescrptionLabelView;

@property (nonatomic, strong) LoremIpsum *lorem;

@end

@implementation ViewController

static const CGFloat paddingSize = 15.0f;
static const CGFloat avatarSize = 60.0f;

- (id)init {
    self = [super init];
    if (self) {
        self.lorem = [[LoremIpsum alloc] init];
    }
    return self;
}

-(void)loadView {
    [super loadView];

    self.scrollView = ({
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectZero];
        sv.alwaysBounceVertical = YES;
        sv;
    });
    self.contentContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont randomFont];
        label.text = [self.lorem words:arc4random() % 4 + 1];
        label.numberOfLines = 0;
        label;
    });
    self.subtitleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont randomFont];
        label.text = [self.lorem words:arc4random() % 10 + 10];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label;
    });
    self.contentViewSectionOne = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentViewSectionTwo = [[UIView alloc] initWithFrame:CGRectZero];
    self.avatarImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.image = [UIImage imageNamed:@"avatar"];
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = YES;
        imageView;
    });
    self.descriptionLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont randomFont];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            label.text = [self.lorem sentences:arc4random() % 10 + 100];
        } else {
            label.text = [self.lorem sentences:arc4random() % 10 + 10];
        }
        label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        label.numberOfLines = arc4random() % 20 + 40;
        label;
    });
    self.firstNameLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont randomFont];
        label.text = [self.lorem words:1];
        label;
    });
    self.lastNameLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont randomFont];
        label.text = [self.lorem words:1];
        label;
    });
    self.titleDescrptionLabelView = [[TitleDescriptionLabelView alloc] init];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentContainerView];
    [self.contentContainerView addSubview:self.titleLabel];
    [self.contentContainerView addSubview:self.subtitleLabel];
    [self.contentContainerView addSubview:self.contentViewSectionOne];
    [self.contentContainerView addSubview:self.contentViewSectionTwo];
    [self.contentContainerView addSubview:self.titleDescrptionLabelView];
    [self.contentViewSectionOne addSubview:self.descriptionLabel];
    [self.contentViewSectionTwo addSubview:self.avatarImageView];
    [self.contentViewSectionTwo addSubview:self.firstNameLabel];
    [self.contentViewSectionTwo addSubview:self.lastNameLabel];
    
    [self addConstrains];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIView colorViewsRandomly:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView logViewRect:self.view level:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView logViewRect:self.view level:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // update content view width 
    for (NSLayoutConstraint *constrain in self.contentContainerView.constraints) {
        if (constrain.firstItem == self.contentContainerView && constrain.firstAttribute == NSLayoutAttributeWidth) {
            constrain.constant = CGRectGetWidth(self.contentContainerView.superview.bounds) - 2 * paddingSize;
        }
    }
    // the prefferedMaxLayoutWidth attribute is depending on the superview width, set it after we update the container width contrain
    self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.superview.bounds) - 2 * paddingSize;
    self.subtitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.superview.bounds) - 2 * paddingSize;

    // don't forget to force layout the subviews or else we'll crash
    [self.view layoutIfNeeded];
    
    NSLog(@"viewDidLayoutSubView");
    [UIView logViewRect:self.view level:0];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)addConstrains {
    NSString *padding = [NSString stringWithFormat:@"%.0f", paddingSize];
    NSString *nagetivePadding = [NSString stringWithFormat:@"-%.0f", paddingSize];
    NSString *avatarSizeString = [NSString stringWithFormat:@"%.0f",avatarSize];
    
    [self.titleLabel alignTopEdgeWithView:self.titleLabel.superview predicate:padding];
    [self.titleLabel alignLeadingEdgeWithView:self.titleLabel.superview predicate:padding];
    [self.titleLabel alignTrailingEdgeWithView:self.titleLabel.superview predicate:nagetivePadding];
    [self.subtitleLabel constrainTopSpaceToView:self.titleLabel predicate:padding];
    [self.subtitleLabel alignLeadingEdgeWithView:self.subtitleLabel.superview predicate:padding];
    [self.subtitleLabel alignTrailingEdgeWithView:self.subtitleLabel.superview predicate:nagetivePadding];

    [self.contentViewSectionOne constrainTopSpaceToView:self.subtitleLabel predicate:padding];
    [self.contentViewSectionOne alignLeadingEdgeWithView:self.contentViewSectionOne.superview predicate:padding];
    [self.contentViewSectionOne alignTrailingEdgeWithView:self.contentViewSectionOne.superview predicate:nagetivePadding];
    [self.descriptionLabel alignTopEdgeWithView:self.descriptionLabel.superview predicate:padding];
    [self.descriptionLabel alignLeadingEdgeWithView:self.descriptionLabel.superview predicate:padding];
    [self.descriptionLabel alignTrailingEdgeWithView:self.descriptionLabel.superview predicate:nagetivePadding];
    [self.contentViewSectionOne alignBottomEdgeWithView:self.descriptionLabel predicate:padding];
    
    [self.contentViewSectionTwo constrainTopSpaceToView:self.contentViewSectionOne predicate:padding];
    [self.contentViewSectionTwo alignLeadingEdgeWithView:self.contentViewSectionTwo.superview predicate:padding];
    [self.contentViewSectionTwo alignTrailingEdgeWithView:self.contentViewSectionTwo.superview predicate:nagetivePadding];
    [self.avatarImageView alignTop:padding leading:padding toView:self.avatarImageView.superview];
    [self.avatarImageView constrainWidth:avatarSizeString height:avatarSizeString];
    [self.firstNameLabel constrainLeadingSpaceToView:self.avatarImageView predicate:padding];
    [self.firstNameLabel alignCenterYWithView:self.firstNameLabel.superview predicate:nil];
    [self.lastNameLabel alignTrailingEdgeWithView:self.lastNameLabel.superview predicate:nagetivePadding];
    [self.lastNameLabel alignCenterYWithView:self.lastNameLabel.superview predicate:nil];
    [self.contentViewSectionTwo alignBottomEdgeWithView:self.avatarImageView predicate:padding];
    
    [self.titleDescrptionLabelView constrainTopSpaceToView:self.contentViewSectionTwo predicate:padding];
    [self.titleDescrptionLabelView alignLeadingEdgeWithView:self.titleDescrptionLabelView.superview predicate:padding];
    [self.titleDescrptionLabelView alignTrailingEdgeWithView:self.titleDescrptionLabelView.superview predicate:nagetivePadding];
    
    [self.contentContainerView alignTopEdgeWithView:self.contentContainerView.superview predicate:padding];
    [self.contentContainerView alignLeadingEdgeWithView:self.contentContainerView.superview predicate:padding];
    [self.contentContainerView constrainWidth:nil]; // this one will be updated in view did layout subviews
    [self.contentContainerView alignBottomEdgeWithView:self.titleDescrptionLabelView predicate:padding];
    
    [self.scrollView alignTop:padding leading:padding bottom:nagetivePadding trailing:nagetivePadding toView:self.scrollView.superview];
    [self.scrollView alignBottomEdgeWithView:self.contentContainerView predicate:padding];
    
}

@end
