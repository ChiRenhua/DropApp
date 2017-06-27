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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // imageView
    UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2 - 150) / 2 , (self.view.bounds.size.height - 150) / 2, 150, 150)];
    self.imageView.backgroundColor = [UIColor grayColor];
    [self.imageView addInteraction:dropInteraction];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
}

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    NSLog(@"%@",session);
    BOOL canHandle = [session hasItemsConformingToTypeIdentifiers:@[(__bridge NSString *)kUTTypeImage]] && session.items.count > 0;
    return canHandle;
}

- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidEnter:(id<UIDropSession>)session {
    
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    CGPoint point = [session locationInView:self.view];
    
    UIDropOperation dropOperation;
    
    if (point.x > self.imageView.frame.origin.x && point.x < self.imageView.frame.origin.x + self.imageView.frame.size.width && point.y > self.imageView.frame.origin.y && point.y < self.imageView.frame.origin.y + self.imageView.frame.size.height) {
        
        // 其他app传过来的数据localDragSession为nil
        dropOperation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationMove;
    }else {
        dropOperation = UIDropOperationCancel;
    }
    
    return [[UIDropProposal alloc] initWithDropOperation:dropOperation];
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    [session loadObjectsOfClass:[UIImage class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        UIImage *image = (UIImage *)[objects firstObject];
        self.imageView.image = image;
    }];
}

@end
