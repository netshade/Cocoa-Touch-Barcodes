// -----------------------------------------------------------------------------------
// NKDUPCEBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Fri May 24 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDUPCABarcode.h"
/*!
 @header NKDUPCEBarcode.h

 This subclass implements the abbreviated form of the UPC symbol, the UPC-E which reduces the 12 characters
 of the UPC-A down to 8 (six characters, check digit encoded in parity of other digits). It is a subclass of
 NKDUPCABarcode beccause UPC-E does not have it's own check digit algorithm, rather the UPC-A check digit
 (calculated on all 12 digits of the original value) and number system are encoded in the parity order of
 the other six digits.
 */

/*!
 @class NKDUPCEBarcode
 @abstract UPC-E abbreviated UPC symbology
 @discussion This subclass can take one of three possible values - the actual UPC-E barcode (8 digits) value or the
                UPC-A barcode, either with or without the check digit. Either way, the code will print out as a UPC-E
                barcode. If the content value provided at time of instantiation is an actual UPC-E value, the check-
                digit MUST be encoded because UPC-E values do not contain enough information to accurately calculate the
                check-digit.
 */
@interface NKDUPCEBarcode : NKDUPCABarcode
{

}
/*!
 @method initWithContent:printsCaption
 @abstract Overrides super. If UPC-A information passed, super is called and then the value is truncated according to the
           specs. If UPC-E data is provided, content is just stored and we trust the the data is correct.
 @param inPrints YES if caption should print.
 @result Initialized UPC-E barcode object
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;

/*!
 @method barcode
 @abstract Overridden [TO COME]
 @result String of 0s and 1s that represent the encoded content, excluding initiator and terminator
*/
-(NSString *)barcode;

/*!
 @method barBottom:
 @abstract [TO COME]
 @param index The index of the bar that you want to find the bottom for (assuming origin at lower left) as an index of
 completeBarcode
 @result Bottom of the bar specified in inches * kScreenResolution
*/
-(float)barBottom:(int)index;

/*!
 @method isContentValid
 @abstract Validates that this barcode supports the data it is encoding.
 @discussion Enforces numerics only and length of content; does not validate check digit.
*/
-(BOOL) isContentValid;

/*!
 @method terminator
 @abstract Overrides to combine center guard bars and right guard bar into a single value
 @result "010101" 
*/
-(NSString *)terminator;

/*!
 @method caption
 @abstract Overridden to center characters
 @result String representing the encoded characters, formatted to appear correctly when drawn
*/
-(NSString *)caption;

/*!
 @method UPCAToUPCE
 @abstract Takes an NSString with a valid 12-digit UPC-A value and abbreviates it (if possible) to UPC-E's 8 digit encoding
 @param UPCA NSString with valid UPC-A content
 @result NSString with calculated UPC-E value, or empty string if not possible to truncate.
 */
+(NSString *)UPCAToUPCE:(NSString *)UPCA;

/*!
 @method parityForDigit:
 @abstract returns ODD_PARITY or EVEN_PARITY signalling the correct parity in light of the check digit and number system
 @param index Which digit (2-7) we're asking about
 @result Parity value of ODD_PARITY or EVEN_PARITY
 */
-(Parity)parityForDigit:(int)index;
@end
