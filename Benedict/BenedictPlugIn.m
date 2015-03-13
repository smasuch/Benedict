//
//  BenedictPlugIn.m
//  Benedict
//
//  Created by Steven Masuch on 2015-03-12.
//  Copyright (c) 2015 Zanopan. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "BenedictPlugIn.h"

#define	kQCPlugIn_Name				@"Benedict"
#define	kQCPlugIn_Description		@"Return a menu description of an Eggs Benedict dish, based on an input of a color."

@implementation BenedictPlugIn

@dynamic inputColor, outputBenedict;

+ (NSDictionary *)attributes
{
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
    if ([key isEqualToString:@"inputColor"]) {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Color", QCPortAttributeNameKey,
                nil];
    } else if ([key isEqualToString:@"outputBenedict"]) {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Benedict", QCPortAttributeNameKey,
                nil];
    }
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode)timeMode
{
	return kQCPlugInTimeModeNone;
}

@end

@implementation BenedictPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	return YES;
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(self.inputColor);
    NSInteger numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpace);
    
    CGFloat alpha = 1.0;
    CGFloat red = 1.0;
    CGFloat blue = 1.0;
    CGFloat green = 1.0;
    
    const CGFloat *components = CGColorGetComponents(self.inputColor);
    
    if (numberOfComponents == 1) {
        red = components[0];
        green = components[0];
        blue = components[0];
        alpha = components[1];
        
    } else if (numberOfComponents == 3) {
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
        
    } else if (numberOfComponents == 4) {
        red = (1.0 - components[0]) * (1.0 - components[3]);
        green = (1.0 - components[1]) * (1.0 - components[3]);
        blue = (1.0 - components[2]) * (1.0 - components[3]);
        alpha = components[4];
    }
    
    NSMutableString *bendictDescription = [NSMutableString string];

    // First up: type of eggs
    if (red < 0.23) {
        [bendictDescription appendString:@"Fried eggs"];
    } else if (red >= 0.23 && red < 0.86) {
        [bendictDescription appendString:@"Poached eggs"];
    } else {
        [bendictDescription appendString:@"Scrambled eggs"];
    }
    
    [bendictDescription appendString:@" over "];
    
    // Next: the meat or meat substitute
    if (blue < 0.43) {
        [bendictDescription appendString:@"bacon"];
    } else if (blue >= 0.43 && blue < 0.76) {
        [bendictDescription appendString:@"ham"];
    } else if (blue >= 0.76 && blue < 0.90) {
        [bendictDescription appendString:@"salmon"];
    } else {
        [bendictDescription appendString:@"smoked tofu"];
    }
    
    [bendictDescription appendString:@" on top of "];
    
    // Then: the bready foundation
    if (green < 0.13) {
        [bendictDescription appendString:@"toast"];
    } else if (green >= 0.13 && green < 0.46) {
        [bendictDescription appendString:@"english muffins"];
    } else if (green >= 0.46 && green < 0.72) {
        [bendictDescription appendString:@"bagel"];
    } else if (green >= 0.72 && green < 0.95) {
        [bendictDescription appendString:@"english muffins"];
    } else {
        [bendictDescription appendString:@"polenta"];
    }
    
    [bendictDescription appendString:@", with Hollandaise sauce"];
    
    // Finally: toppings
    if (alpha < 0.13) {
        [bendictDescription appendString:@" and green onion"];
    } else if (alpha >= 0.13 && alpha < 0.33) {
        [bendictDescription appendString:@" and salsa"];
    }
    
    [bendictDescription appendString:@"."];
    
	self.outputBenedict = bendictDescription;
	
	return YES;
}

@end
