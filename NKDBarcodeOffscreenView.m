// -----------------------------------------------------------------------------------
//  NKDBarcodeOffscreenView.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Mon May 06 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDBarcodeOffscreenView.h"


@implementation NKDBarcodeOffscreenView

- (id)initWithBarcode:(NKDBarcode *)inBarcode
{
    CGRect	frame = CGRectMake(0,0,[inBarcode width], [inBarcode height]);
    // Calculate frame and then...

    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBarcode:inBarcode];
    }
    return self;
}

// A more elegant solution offered by Sato Akira (arigoto!)
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, false);
	CGContextSetInterpolationQuality(context, kCGInterpolationNone);
	int				i, barCount=0;
    float			curPos = [barcode firstBar];
    NSString 			*codeString = [barcode completeBarcode];

    BOOL			started = NO;
    int				lastBarIndex = -1;

    for (i = 0; i < [codeString length]; i++)
    {
        if ([codeString characterAtIndex:i] == '1')
        {
            if (!started)
                started = YES;

            barCount++;
            lastBarIndex = i;

            // If last character is a bar, it needs to be printed here.
            if (i == [codeString length]-1)
            {
				CGContextSetLineWidth(context, 0.0);
				CGMutablePathRef path = CGPathCreateMutable();
				CGPathAddRect(path, NULL,  CGRectMake(curPos,
													  [barcode barBottom:lastBarIndex],
													  [barcode barWidth] * barCount,
													  [barcode barTop:lastBarIndex] - [barcode barBottom:lastBarIndex]));
/*				CGContextFillRect(context, CGRectMake(curPos,
													  [barcode barBottom:lastBarIndex],
													  [barcode barWidth] * barCount,
													   [barcode barTop:lastBarIndex] - [barcode barBottom:lastBarIndex])); */
				CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
				CGContextAddPath(context, path);
				CGContextDrawPath(context, kCGPathFill);
				CGPathRelease(path);
				CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            }
        }
        else
        {
            if (started)
            {
				CGContextSetLineWidth(context, 0.0);
				CGMutablePathRef path = CGPathCreateMutable();
				/*
				CGContextFillRect(context, CGRectMake(curPos,
													  [barcode barBottom:lastBarIndex],
													  [barcode barWidth] * barCount,
													  [barcode barTop:lastBarIndex] - [barcode barBottom:lastBarIndex] ));
				 */
				CGPathAddRect(path, NULL, CGRectMake(curPos,
													 [barcode barBottom:lastBarIndex],
													 [barcode barWidth] * barCount,
													 [barcode barTop:lastBarIndex] - [barcode barBottom:lastBarIndex] ));
				CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);	
				CGContextAddPath(context, path);
				CGContextDrawPath(context, kCGPathFill);
				CGPathRelease(path);
				CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor); 

            }
            curPos += [barcode barWidth] * (barCount + 1);
            barCount = 0;
            started = NO;
        }
    }
    if ([barcode printsCaption])
    {
		NSLog(@":::::::NOTE:::::: DOES NOT CURRENTLY PRINT CAPTION");
		NSLog(@":::::::NOTE:::::: FIX PROGRAMMER");		
		NSMutableAttributedString *sAttr;
		float kerning;
		CGSize captionSize;
		CGRect bBounds = [self bounds];
		float heightSpace = 0.0;
		float widthSpace = 0.0;
		float barWidth = [barcode barWidth];
		NSString *leftCaption = [barcode leftCaption];
		NSString *caption = [barcode caption];
		NSString *rightCaption = [barcode rightCaption];
		float yPos = bBounds.origin.y + heightSpace;

        UIFont *font = [UIFont systemFontOfSize:[barcode fontSize]];
        
		NSMutableParagraphStyle	*leftAligmentStyle = [[NSMutableParagraphStyle alloc] init];

        // Left caption for UPC / EAN
		if ((nil != leftCaption) && (NO == [leftCaption isEqualToString:@""])) {
			kerning = 0.0;
            sAttr = [[NSMutableAttributedString alloc] initWithString:leftCaption
                                                           attributes:@{NSFontAttributeName : font,
                                                                        NSParagraphStyleAttributeName : leftAligmentStyle,
                                                                        NSKernAttributeName: [NSNumber numberWithFloat:kerning]}];
			captionSize = [sAttr size];
			[sAttr drawAtPoint:CGPointMake(bBounds.origin.x + widthSpace + 0.25 * [barcode firstBar], yPos + 3.0)];
		}

        // Draw the main caption under the barcode
		if ((nil != caption) && (NO == [caption isEqualToString:@""])) {
			NSUInteger cCount,captionLength;
			NSRange range;
			float container;
			NSArray *captions = [caption componentsSeparatedByString:@"\t"];

			if (((nil != leftCaption) && (NO == [leftCaption isEqualToString:@""])) || (1 < [captions count])) {
				if (1 == [captions count]) // for UPCE //
					container = [barcode width] / (float)[captions count] - 2.0 * [[barcode initiator] length] * barWidth - 2.0 * [barcode firstBar];
				else // for UPCA,EAN8,EAN13 //
					container = [barcode width] / (float)[captions count] - 1.0 * [[barcode initiator] length] * barWidth - [barcode firstBar]; // [[barcode initiator] length] == [[barcode terminator] length]; && [barcode firstBar] == [barcode width] - [barcode lastBar]; //
				for (cCount = 0; cCount < [captions count]; cCount++) {
					kerning = 0.0;
                    sAttr = [[NSMutableAttributedString alloc] initWithString:[captions objectAtIndex:cCount]
                                                                   attributes:@{NSFontAttributeName : font,
                                                                                NSParagraphStyleAttributeName : leftAligmentStyle,
                                                                                NSKernAttributeName : [NSNumber numberWithFloat:kerning]}];
					captionSize = [sAttr size];
					captionLength = [(NSString *)[captions objectAtIndex:cCount] length];
					kerning = (container - captionSize.width) / (float)(2 * captionLength);
					range = NSMakeRange(0,captionLength);
                    [sAttr setAttributes:@{NSFontAttributeName : font,
                                           NSParagraphStyleAttributeName : leftAligmentStyle,
                                           NSKernAttributeName : [NSNumber numberWithFloat:1.3 * kerning]}
                                   range:range];
					[sAttr drawAtPoint:CGPointMake(bBounds.origin.x + widthSpace + kerning * 3 + [barcode firstBar] + (float)(cCount + 1) * [[barcode  initiator] length] * barWidth + (float)cCount * container,yPos)];
				}
			}
			else {
                // hier
				cCount = 0;
				kerning = 0.0;
				sAttr = [[NSMutableAttributedString alloc] initWithString:[captions objectAtIndex:cCount]
                                                               attributes:@{NSFontAttributeName : font,
                                                                            NSParagraphStyleAttributeName : leftAligmentStyle,
                                                                            NSKernAttributeName : [NSNumber numberWithFloat:kerning]}];
				captionSize = [sAttr size];
				captionLength = [(NSString *)[captions objectAtIndex:cCount] length];
				container = [barcode width];
				kerning = (container - captionSize.width) / (float)(2 * captionLength);
				range = NSMakeRange(0,captionLength);
                [sAttr setAttributes:@{NSFontAttributeName : font,
                                       NSParagraphStyleAttributeName : leftAligmentStyle,
                                       NSKernAttributeName : [NSNumber numberWithFloat:2.0 * kerning]}
                               range:range];
                CGPoint drawPoint = CGPointMake(round(bBounds.origin.x + widthSpace + kerning), yPos);
				[sAttr drawAtPoint:drawPoint];
			}
		}

        // Right caption for UPC / EAN
		if ((nil != rightCaption) && (NO == [rightCaption isEqualToString:@""])) {
			kerning = 0.0;
			sAttr = [[NSMutableAttributedString alloc] initWithString:rightCaption
                                                           attributes:@{NSFontAttributeName : font,
                                                                        NSParagraphStyleAttributeName : leftAligmentStyle,
                                                                        NSKernAttributeName : [NSNumber numberWithFloat:kerning]}];
			[sAttr drawAtPoint:CGPointMake(bBounds.origin.x + widthSpace + [barcode lastBar] + ([barcode width] * 0.07),yPos + 3.0)];
		}
    }
}
// -----------------------------------------------------------------------------------
-(NKDBarcode *)barcode
// -----------------------------------------------------------------------------------
{
    return barcode;
}
// -----------------------------------------------------------------------------------
-(void)setBarcode:(NKDBarcode *)inBarcode
// -----------------------------------------------------------------------------------
{
    barcode = inBarcode;
}
// -----------------------------------------------------------------------------------
-(BOOL)knowsPageRange:(NSRange *)rptr
// -----------------------------------------------------------------------------------
{
    rptr->location = 1;
    rptr->length = 1;
    return YES;
}
// -----------------------------------------------------------------------------------
-(CGRect)rectForPage:(int)pageNum
// -----------------------------------------------------------------------------------
{
    return  CGRectMake(0,0,[[self barcode] width], [[self barcode] height]);
}
- (UIImage *)_renderViewAsImage:(CGRect) rect
    /* this method is not intended to be called directly */
/* used by dataWithPDFInsideRect: when multithreading is required */
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.f);
	[self drawRect:rect];
	UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

- (UIImage *)imageInsideRect:(CGRect)rect
    /* This method overrides the default NSView version to allow the view 
    to be rendered to PDF within another print operation. If there is 
    already a print operation running on the current thread, this method 
    spawns a new thread to render the PDF, otherwise the default NSView 
 version of dataWithPDFInsideRect: is called... */
{
	UIImage * result = [self _renderViewAsImage:rect];
	return result;
}

- (NSData *)pdfInsideRect:(CGRect)rect {
	NSMutableData * data = [NSMutableData data];
	CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)data);
	CGRect media = CGRectMake(0.0, 0.0, rect.size.width, rect.size.height);
	CGContextRef context = CGPDFContextCreate(consumer, &media, (CFDictionaryRef)[NSDictionary dictionary]);
	UIGraphicsPushContext(context);
	CGPDFContextBeginPage(context, (CFDictionaryRef)[NSDictionary dictionary]);
	[self drawRect:rect];
	UIGraphicsPopContext();
	CGPDFContextEndPage(context);
	CGPDFContextClose(context);
	CGDataConsumerRelease(consumer);
	CGContextRelease(context);
	return data;
}



@end
