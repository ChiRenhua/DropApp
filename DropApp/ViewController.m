//
//  ViewController.m
//  DropApp
//
//  Created by 迟人华 on 2017/6/17.
//  Copyright © 2017年 迟人华. All rights reserved.
//

#import "ViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface ViewController () <UIDropInteractionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2 - 150) / 2 , (self.view.bounds.size.height - 150) / 2, 150, 150)];
    imageView.backgroundColor = [UIColor grayColor];
    
    UIDropInteraction *imageDropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    [imageView addInteraction:imageDropInteraction];
    imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:imageView];
    
    // uilabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2 - self.view.bounds.size.width / 3) / 2, self.view.bounds.size.height / 4, self.view.bounds.size.width / 3, 30)];
    label.backgroundColor = [UIColor grayColor];
    
    UIDropInteraction *labelDropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    [label addInteraction:labelDropInteraction];
    label.userInteractionEnabled = YES;
    
    [self.view addSubview:label];
}

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    NSLog(@"canHandleSession");
    BOOL canHandle = [session hasItemsConformingToTypeIdentifiers:@[(__bridge NSString *)kUTTypeImage, (__bridge NSString *)kUTTypeText]] && session.items.count > 0;
    return canHandle;
}

- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidEnter:(id<UIDropSession>)session {
    NSLog(@"sessionDidEnter");
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    NSLog(@"sessionDidUpdate");
    
    UIDropOperation dropOperation = UIDropOperationForbidden;
    
    if ([interaction.view isKindOfClass:[UIImageView class]]) {
        if ([session canLoadObjectsOfClass:[UIImage class]]) {
            dropOperation = UIDropOperationCopy;
        }else {
            dropOperation = UIDropOperationForbidden;
        }
    }
    
    if ([interaction.view isKindOfClass:[UILabel class]]) {
        if ([session canLoadObjectsOfClass:[NSString class]]) {
            dropOperation = UIDropOperationCopy;
        }else {
            dropOperation = UIDropOperationForbidden;
        }
    }
    
    return [[UIDropProposal alloc] initWithDropOperation:dropOperation];
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    NSLog(@"performDrop");
    
    if ([interaction.view isKindOfClass:[UIImageView class]]) {
        [session loadObjectsOfClass:[UIImage class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
            UIImage *image = (UIImage *)[objects firstObject];
            
            if (image) {
                UIImageView *imageView = (UIImageView *)interaction.view;
                imageView.image = image;
            }
        }];
    } else if ([interaction.view isKindOfClass:[UILabel class]]) {
        [session loadObjectsOfClass:[NSString class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
            NSString *str = (NSString *)[objects firstObject];
            
            if (str) {
                UILabel *label = (UILabel *)interaction.view;
                label.text = str;
            }
        }];
    } 
}

- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidExit:(id<UIDropSession>)session {
    NSLog(@"sessionDidExit");
}

- (void)dropInteraction:(UIDropInteraction *)interaction concludeDrop:(id<UIDropSession>)session {
    NSLog(@"concludeDrop");
}

- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidEnd:(id<UIDropSession>)session {
    NSLog(@"sessionDidEnd");
}

- (nullable UITargetedDragPreview *)dropInteraction:(UIDropInteraction *)interaction previewForDroppingItem:(UIDragItem *)item withDefault:(UITargetedDragPreview *)defaultPreview {
    NSLog(@"previewForDroppingItem");
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, interaction.view.bounds.size.width, interaction.view.bounds.size.height)];
    imageView.backgroundColor = [UIColor redColor];
    
    UIDragPreviewTarget *previewTarget = [[UIDragPreviewTarget alloc] initWithContainer:interaction.view center:CGPointMake(interaction.view.bounds.size.width / 2, interaction.view.bounds.size.height / 2)];
    
    UITargetedDragPreview *dragPreview = [[UITargetedDragPreview alloc] initWithView:imageView parameters:[[UIDragPreviewParameters alloc] init] target:previewTarget];
    return dragPreview;
}

- (void)dropInteraction:(UIDropInteraction *)interaction item:(UIDragItem *)item willAnimateDropWithAnimator:(id<UIDragAnimating>)animator {
    NSLog(@"willAnimateDropWithAnimator");
}

@end
