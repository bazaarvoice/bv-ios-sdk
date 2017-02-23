//
//  BVQuestionsCollectionView.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionsCollectionView.h"

#import "BVMessageInterceptor.h"
#import "BVQuestion.h"
#import "BVQuestionCollectionViewCell.h"
#import "BVCore.h"
#import "BVViewsHelper.h"

@interface BVQuestionsCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>
{
    BVMessageInterceptor* delegate_interceptor;
    BVMessageInterceptor* datasource_interceptor;
    bool hasSentScrollEvent;
    bool hasSentInViewEvent;
    bool hasEnteredView;
    NSMutableDictionary* cellToProductMap;
    NSString *productId;
}
@end

@implementation BVQuestionsCollectionView

-(id)init {
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}


-(void)setup {
    cellToProductMap = [NSMutableDictionary dictionary];
    delegate_interceptor = [[BVMessageInterceptor alloc] initWithMiddleman:self];
    [super setDelegate:(id)delegate_interceptor];
    datasource_interceptor = [[BVMessageInterceptor alloc] initWithMiddleman:self];
    [super setDataSource:(id)datasource_interceptor];
}

-(void)tryToSendInViewEvent {
    
    if (hasEnteredView && productId != nil) {
        if (!hasSentInViewEvent){
            hasSentInViewEvent = true;
            BVInViewEvent *inView = [[BVInViewEvent alloc] initWithProductId:productId withBrand:nil
                                                      withProductType:BVPixelProductTypeConversationsQuestionAnswer
                                                             withContainerId:@"QuestionsCollectionView"
                                                        withAdditionalParams:nil];
            
            [BVPixel trackEvent:inView];

        }
    }
    
}

-(void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    hasEnteredView = true;
    
    [self tryToSendInViewEvent];
}

- (void)load:(nonnull BVQuestionsAndAnswersRequest*)request
     success:(nonnull QuestionsAndAnswersSuccessHandler)success
     failure:(nonnull ConversationsFailureHandler)failure {
    
    productId = request.productId;
    [self tryToSendInViewEvent];
    [request load:success failure:failure];
    
}

-(void)setDataSource:(id<UICollectionViewDataSource>)newDataSource {
    [super setDataSource:nil];
    [datasource_interceptor setReceiver:newDataSource];
    [super setDataSource:(id)datasource_interceptor];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)newDelegate {
    [super setDelegate:nil];
    [delegate_interceptor setReceiver:newDelegate];
    [super setDelegate:(id)delegate_interceptor];
}

- (void)dealloc {
    delegate_interceptor = nil;
    datasource_interceptor = nil;
}


#pragma mark UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        [delegate_interceptor.receiver scrollViewWillBeginDragging:scrollView];
    }
    
    if(!hasSentScrollEvent) {
        hasSentScrollEvent = true;
        
        BVFeatureUsedEvent *scrollEvent = [[BVFeatureUsedEvent alloc] initWithProductId:productId
                                                                              withBrand:nil
                                                                 withProductType:BVPixelProductTypeConversationsQuestionAnswer
                                                                    withEventName:BVPixelFeatureUsedEventNameScrolled
                                                                   withAdditionalParams:nil];
        
        [BVPixel trackEvent:scrollEvent];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [delegate_interceptor.receiver scrollViewDidEndDecelerating:scrollView];
    }
    
    BVFeatureUsedEvent *scrollEvent = [[BVFeatureUsedEvent alloc] initWithProductId:productId
                                                                          withBrand:nil
                                                             withProductType:BVPixelProductTypeConversationsQuestionAnswer
                                                                withEventName:BVPixelFeatureUsedEventNameScrolled
                                                               withAdditionalParams:nil];
    
    [BVPixel trackEvent:scrollEvent];
    
}

#pragma mark UICollectionViewDelegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [delegate_interceptor.receiver collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    BVQuestion *questiontem = [cellToProductMap objectForKey:[BVViewsHelper formatIndex:indexPath]];
    if (questiontem != nil){
        [questiontem recordTap];
    }
    
}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [datasource_interceptor.receiver collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if([cell isKindOfClass:[BVQuestionCollectionViewCell class]]) {
        
        BVQuestionCollectionViewCell* bvCell = (BVQuestionCollectionViewCell*)cell;
        BVQuestion *question = bvCell.question;
        if(question != nil){
            [cellToProductMap setObject:question forKey:[BVViewsHelper formatIndex:indexPath]];
        }
        else {
            // error, cell must have question set
            NSString* message = @"BVQuestionCollectionViewCell has nil `question` property. This must be set in `cellForItemAtIndexPath`.";
            [[BVLogger sharedLogger] error:message];
            NSAssert(false, message);
        }
        
    }
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [datasource_interceptor.receiver collectionView:collectionView numberOfItemsInSection:section];
}


@end

