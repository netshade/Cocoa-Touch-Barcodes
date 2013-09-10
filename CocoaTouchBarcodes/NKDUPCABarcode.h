// -----------------------------------------------------------------------------------
//  NKDUPCABarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 04 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDAbstractUPCEANBarcode.h"
/*!
 @header NKDUPCABarcode.h
 This is a barcode object to create the "A" variant of UPC, a 10 digit number with a content digit to the left
 and a check digit to the right. The caption intrudes, and there there are two types ("parities") of
 encoding for digits.
 */

/*!
 @class NKDUPCABarcode
 @discussion This is an encoder for the "A" variant of UPC, a 10 digit number with a content digit to the left
            and a check digit to the right. The caption intrudes, and there there are two types ("parities") of
            encoding for digits.
*/
@interface NKDUPCABarcode : NKDAbstractUPCEANBarcode
{

}
/*!
@method initWithContent:printsCaption
 @abstract Overrides constructor to set barwidth, calculate check digit (if not provided), and set height
 @param inContent A string containing the data to be encoded; should use only <B>ASCII-8</B> characters
    (those that can be encoded using a single char in UTF-8)
 @param inPrints YES if caption should print.
 @result Initialized UPC-A barcode object
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;


/*!
 @method barcode
 @abstract Overridden to reverse character parity for second half of content and to place the center guard bars
 @result String of 0s and 1s that represent the encoded content, excluding initiator and terminator
 */
-(NSString *)barcode;

/*!
 @method caption
 @abstract Overridden to shift characters around the center guard bars
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
 @abstract Overridden to generate UPC-A check digit
 @discussion The algorithm is as follows, which is a slightly more complex modulus 10 algorithm:

     Designate the rightmost character odd.
     Sum all of the characters in the odd positions and multiply the result by three.
     Sum all of the characters in the even positions
     Add the odd and even totals from steps two and three.
     Determine the smallest number that when added to the result from step four, will
     result in a multiple of 10. This is the check character.
     */
-(void)generateChecksum;
@end
