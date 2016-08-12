// -----------------------------------------------------------------------------------
//  NSImage-NKDBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NKDBarcode.h"
#import "NKDBarcodeOffscreenView.h"
/*!
 @header NSImage-NKDBarcode.h

This category adds a single class method to NSImage that generates a resolution-independent NSImage from an NKDBarcode object.
 */

/*!
@category NSImage(NKDBarcode)
@discussion This category adds a single class method to NSImage that allows you to generate a resolution-independent NSImage from an NKDBarcode object.
 */
@interface UIImage(NKDBarcode)

/*!
@method imageFromBarcode:
@abstract Creates resolution independent image from barcode.
@param barcode An NKDBarcode object that needs to be drawn.
@result Initialized NSImage with PDF representation that represents the barcode pass in.
 */
+(UIImage *)imageFromBarcode:(NKDBarcode *)barcode;
+(NSData *)pdfFromBarcode:(NKDBarcode *)barcode;
+(UIImage *)imageFromBarcode:(NKDBarcode *)barcode inRect:(CGRect) rect;
@end
