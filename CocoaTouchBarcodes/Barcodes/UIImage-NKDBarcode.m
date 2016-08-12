// -----------------------------------------------------------------------------------
//  NSImage-NKDBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "UIImage-NKDBarcode.h"

@implementation UIImage(NKDBarcode)

+(UIImage *)imageFromBarcode:(NKDBarcode *)barcode
{
    NKDBarcodeOffscreenView 	* view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:barcode];
    CGRect			rect = [view bounds];
    UIImage			* image = [view imageInsideRect:rect];
    return image;
}

+(NSData *)pdfFromBarcode:(NKDBarcode *)barcode {
    NKDBarcodeOffscreenView 	* view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:barcode];
    CGRect			rect = [view bounds];
    NSData			* pdf = [view pdfInsideRect:rect];
    return pdf;
}

+(UIImage *)imageFromBarcode:(NKDBarcode *)barcode inRect:(CGRect) rect
{
    NKDBarcodeOffscreenView 	* view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:barcode];
	[view setFrame:rect];
    UIImage			* image = [view imageInsideRect:rect];
    return image;
}

@end
