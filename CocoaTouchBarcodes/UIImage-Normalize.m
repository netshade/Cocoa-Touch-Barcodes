// -----------------------------------------------------------------------------------
// UIImage-Normalize.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sun May 12 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "UIImage-Normalize.h"


@implementation UIImage (normalize)
// -----------------------------------------------------------------------------------
- (UIImage *) normalizeSize
// -----------------------------------------------------------------------------------
{
	/*
    NSArray *reps = [self representations];
    int i;

    for (i = 0 ; i < [reps count] ; i++ )
    {
        NSImageRep *theRep = [reps objectAtIndex:i];
        if ([theRep isKindOfClass:[NSBitmapImageRep class]])
        {
            theBitmap = (NSBitmapImageRep *)theRep;
            break;
        }
    }
    if (theBitmap != nil)
    {
        newSize.width = [theBitmap pixelsWide];
        newSize.height = [theBitmap pixelsHigh];
        [theBitmap setSize:newSize];
        [self setSize:newSize];
    }
	 */
    return self;
}
// -----------------------------------------------------------------------------------
- (UIImage *) setDPI:(int)dpi
// -----------------------------------------------------------------------------------
{
	/*
    NSBitmapImageRep *theBitmap = nil;
    NSSize newSize;
    NSArray *reps = [self representations];
    int i;

    for (i = 0 ; i < [reps count] ; i++ )
    {
        NSImageRep *theRep = [reps objectAtIndex:i];
        if ([theRep isKindOfClass:[NSBitmapImageRep class]])
        {
            theBitmap = (NSBitmapImageRep *)theRep;
            break;
        }
    }
    if (theBitmap != nil)
    {
        newSize.width = (float)([theBitmap pixelsWide])/dpi*72;
        newSize.height = (float)([theBitmap pixelsHigh])/dpi*72;
        [theBitmap setSize:newSize];
        [self setSize:newSize];
    }
	 */
    return self;
}
@end
