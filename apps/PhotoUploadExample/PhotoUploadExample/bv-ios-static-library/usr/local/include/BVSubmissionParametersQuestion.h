//
//  BVSubmissionParametersQuestion.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionQuestion requests.
 */

@interface BVSubmissionParametersQuestion : BVSubmissionParametersBase

/*!
 Contains the text of the question summary. Only a single line of text is allowed.
 */
@property (nonatomic, copy) NSString* questionSummary;
/*!
 The id of the category that this content is being submitted on. One of ProductId or CategoryId must be provided.
 */
@property (nonatomic, copy) NSString* categoryId;
/*!
 Contains the text of the question details. Multiple lines of text are allowed.
 */
@property (nonatomic, copy) NSString* questionDetails;

@end