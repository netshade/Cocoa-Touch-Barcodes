// -----------------------------------------------------------------------------------
// NKDEAN8Barcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 29 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDEAN13Barcode.h"
/*!
 @header NKDEAN8Barcode.h

 This subclass of NKDEAN13Barcode implements the abbreviated version of EAN.
 */

/*!
 @class NKDEAN8Barcode
 */
@interface NKDEAN8Barcode : NKDEAN13Barcode
{

}
/*!
 @method initWithContent: printsCaption:
 @param inContent A string containing the data to be encoded; should use only <B>ASCII-8</B> characters
 (those that can be encoded using a single char in UTF-8)
 @param inPrints YES if caption should print.
 @result Returns initialized NKDBarcode class
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;

/*!
 @method barcode
 @abstract Overridden to deal with various character parity options.
 @result String of 0s and 1s that represent the encoded content, excluding initiator and terminator
*/
-(NSString *)barcode;

/*!
 @method caption
 @result String representing the encoded characters, formatted to appear correctly when drawn
*/
-(NSString *)caption;

/*!
 @method isContentValid
 @abstract Validates that this barcode supports the data it is encoding.
 @discussion Enforces numerics only and length of content; does not validate check digit.
*/
-(BOOL) isContentValid;

/*!
 @method generateChecksum
 @abstract Overridden to generate EAN check digit
 @discussion The algorithm is exactly the same as the UPC-A, except that we must take into
            account the additional system digit.
*/
-(void)generateChecksum;

/*!
 @method barBottom:
 @abstract Overridden to specify that guard bars, terminator and initiator should extend down into the caption area
 @param index The index of the bar that you want to find the bottom for (assuming origin at lower left) as an index of
            completeBarcode
 @result Bottom of the bar specified in inches * kScreenResolution
*/
-(float)barBottom:(int)index;

/*!
 @method digitsToRight
 @abstract Overridden to specify that no characters of the caption prints to the right of the barcode
 @result 0
*/
-(int)digitsToRight;


/*!
 @method digitsToLeft
 @abstract Overridden to specify that no characters of the caption prints to the left of the barcode
 @result 0
*/
-(int)digitsToLeft;
@end
