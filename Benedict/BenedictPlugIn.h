//
//  BenedictPlugIn.h
//  Benedict
//
//  Created by Steven Masuch on 2015-03-12.
//  Copyright (c) 2015 Zanopan. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface BenedictPlugIn : QCPlugIn

@property CGColorRef inputColor;
@property (copy) NSString* outputBenedict;

@end
