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

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // imageView
    UIDropInteraction *imageDropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2 - 150) / 2 , (self.view.bounds.size.height - 150) / 2, 150, 150)];
    self.imageView.backgroundColor = [UIColor grayColor];
    [self.imageView addInteraction:imageDropInteraction];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    // uilabel
    UIDropInteraction *labelDropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2 - self.view.bounds.size.width / 3) / 2, self.view.bounds.size.height / 4, self.view.bounds.size.width / 3, 30)];
    self.label.userInteractionEnabled = YES;
    self.label.backgroundColor = [UIColor grayColor];
    [self.label addInteraction:labelDropInteraction];
    [self.view addSubview:self.label];
}

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    NSLog(@"%@",session);
    BOOL canHandle = [session hasItemsConformingToTypeIdentifiers:@[(__bridge NSString *)kUTTypeImage, (__bridge NSString *)kUTTypeText]] && session.items.count > 0;
    return canHandle;
}

- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidEnter:(id<UIDropSession>)session {
    
}

// 会被频繁调用，所以负值操作不在这里进行，而在 dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session 里进行
- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    CGPoint point = [session locationInView:self.view];
    
    __block UIDropOperation dropOperation;
    
    if ([self pointInView:point view:self.imageView]) {
//        [session loadObjectsOfClass:[UIImage class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
//            if (objects.count == 0) {
//                dropOperation = UIDropOperationForbidden;
//            }else {
//                // 如果是其他app传过来的数据   localDragSession为nil，同一个app则不为空
//                dropOperation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationMove;
//            }
//        }];
        dropOperation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationMove;
        
    }else if ([self pointInView:point view:self.label]){
//        [session loadObjectsOfClass:[NSString class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
//            if (objects.count == 0) {
//                dropOperation = UIDropOperationForbidden;
//            }else {
//                // 如果是其他app传过来的数据   localDragSession为nil，同一个app则不为空
//                dropOperation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationMove;
//            }
//        }];
        dropOperation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationMove;
    }else {
        dropOperation = UIDropOperationCancel;
    }
    
    return [[UIDropProposal alloc] initWithDropOperation:dropOperation];
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    [session loadObjectsOfClass:[UIImage class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        UIImage *image = (UIImage *)[objects firstObject];
        
        if (image) {
            self.imageView.image = image;
        }
    }];
    
    [session loadObjectsOfClass:[NSString class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        NSString *str = (NSString *)[objects firstObject];
        
        if (str) {
            self.label.text = str;
        }
    }];
}

#pragma mark - helper method
- (BOOL)pointInView:(CGPoint)point view:(UIView *)view {
    if (point.x > view.frame.origin.x && point.x < view.frame.origin.x + view.frame.size.width && point.y > view.frame.origin.y && point.y < view.frame.origin.y + view.frame.size.height) {
        return YES;
    }
    return NO;
}

@end
