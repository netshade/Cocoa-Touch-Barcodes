// -----------------------------------------------------------------------------------
//  NKDBarcodeOffscreenView.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Mon May 06 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import <UIKit/UIGeometry.h>
#import "NKDBarcode.h"

/*!
 @class NKDBarcodeOffscreenView
 @abstract View subclass for rendering the barcode. This view does all of the drawing work for the framework. Barcodes
            are drawn here so that we can create a resolution-independent NSImage. Were we to draw directly into an NSImage,
            it would use a bitmap at screen resolution and not utilize full resolution when printed on other devices.

            This view should not be placed on a view. Although it <i>should</i> work correctly (albeit, dictating its display size),
            it is really designed to be used as an offscreen drawing area.
 */
@interface NKDBarcodeOffscreenView : UIView
{
    NKDBarcode	*barcode;
    
    volatile BOOL doneRendering;

}
/*!
 @method initWithBarcode:
 @abstract Intialize the view with an NKDBarcode object.
 @param inBarcode The NKDBarcode to draw inside the view. The view will size itself to the bounds rectangle of
                  the barcode.
 @result Initialized view that draws the barcode.
 */
-(id)initWithBarcode:(NKDBarcode *)inBarcode;

/*!
 @method barcode
 @abstract Accessor method for contained NKDBarcode object.
 @result The barcode object.
 */
-(NKDBarcode *)barcode;

/*!
 @method setBarcode
 @abstract Specifies an NKDBarcode that should be drawn
 */
-(void)setBarcode:(NKDBarcode *)inBarcode;

/*!
 @method knowsPageRange:
 @abstract Override view behavior so that we can print barcodes in a resolution-dependent manner without creating a separate object.
 @param rptr An NSRange that we will populate with the page range to be printed.
 @result YES to signify that we know our page range (a barcode will almost always fit on one page).
 */
-(BOOL)knowsPageRange:(NSRange *)rptr;

/*!
 @method rectForPage:
 @abstract Override NSView behavior to specify the part of the view to print for this page.
 @discussion We are making the (possibly erroneous) assumption that the barcode will print on a single page, so this
             will always return the view's bounds rect.
 @result The view's bounds rect, which will be equal to a rectangle of the barcode's size at the origin.
 */
-(CGRect)rectForPage:(int)pageNum;

- (UIImage *)imageInsideRect:(CGRect)rect;
- (NSData *)pdfInsideRect:(CGRect)rect;
@end
