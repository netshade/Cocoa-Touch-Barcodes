// -----------------------------------------------------------------------------------
//  NKDEAN13Barcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Fri May 10 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDAbstractUPCEANBarcode.h"

/*!
 @header NKDEAN13Barcode

 EAN-13 is a superset of UPC-A that is more globally friendly. To add support for more countries, an additional digit
 had to be added (13 as opposed to UPC's 12), but to make it backward compatible with UPC-A, this extra digit is encoded
 not in the bars directly but in the parity of the other encoded letters. For UPC-A values, a zero is prepended to the
 content, and the character parity is the same as specified in the UPC-A specs.

 We need to override content, digitsToRight, and rightCaption because EAN display the characters slightly differently
 than UPC-A (1 to the left, 6 digits on each side of the center guard bars, none to the right). We also need to override the
 method barcode to deal with the increased parity options of EAN.
 */

/*!
 @class NKDEAN13Barcode
 */
@interface NKDEAN13Barcode : NKDAbstractUPCEANBarcode
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
 @method digitsToRight
 @abstract Overridden to specify that one character of the caption prints to the right of the barcode
 @result 0
 */
-(int)digitsToRight;

/*!
 @method rightCaption
 @abstract Overridden to specify that the no digits print to the right of the caption
 @result Empty string
 */
-(NSString *)rightCaption;

/*!
    @method _parityForSystemDigit:forIndex:
    @abstract Lookup method used to encode the system digit in the parity of the next five digits
    @param systemDigit Character representing the first character in content
    @param index The index of the character being encoded
    @result EVEN_PARITY or ODD_PARITY
 */
-(BOOL)_parityForSystemDigit: (char) systemDigit
                    forIndex: (int) index;

/*!
 @method caption
 @abstract Overridden to display 12 characters below, rather than the 10 that UPC shows below
 @result String representing the encoded characters, formatted to appear correctly when drawn
*/
-(NSString *)caption;

/*!
 @method generateChecksum
 @abstract Overridden to generate EAN check digit
 @discussion The algorithm is exactly the same as the UPC-A, except that we must take into
            account the additional system digit.
*/
-(void)generateChecksum;

/*!
 @method isContentValid
 @abstract Validates that this barcode supports the data it is encoding.
 @discussion Enforces numerics only and length of content; does not validate check digit.
*/
-(BOOL) isContentValid;
@end
