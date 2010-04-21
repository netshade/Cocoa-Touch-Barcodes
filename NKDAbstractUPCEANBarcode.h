// -----------------------------------------------------------------------------------
//  NKDAbstractUPCEANBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 11 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDBarcode.h"
#import "NSString-UPCEAN.h"
/*!
@header NKDAbstractUPCEANBarcode.h
 This is an abstract object to encapsulate the functionality that the various UPC and EAN barcodes have in common,
 including parity-swapping and digit encoding.
 */

/*!
@typedef Parity
 @discussion Defines a type of "Parity" (as a BOOL) to make methods that take one of the precompiler defined parity values
 more readable.
 */
typedef BOOL Parity;

/*!
@typedef Handedness
 @discussion Defiens a type of Handedness (as a BOOL) to deal with the difference between left and right handed encoding schemes
 */
typedef BOOL Handedness;

/*!
@defined EVEN_PARITY
 @discussion UPC / EAN codes use parity swapping to increase the number of values that can be encoded. This
 defines EVEN_PARITY as YES to make the code more readable.
 */
#define EVEN_PARITY YES

/*!
@defined ODD_PARITY
 @discussion UPC / EAN codes use parity swapping to increase the number of values that can be encoded. This
 defines ODD_PARITY as NO to make the code more readable.
 */
#define ODD_PARITY NO

/*!
 @defined LEFT_HANDEDNESS
 */
#define LEFT_HANDEDNESS

/*!
 @defined RIGHT_HANDEDNESS
 */
#define RIGHT_HANDEDNESS

/*!
 @class NKDAbstractUPCEANBarcode
 @discussion This abstract class holds all the functionality shared by UPC-A, UPC-E, EAN-13 and EAN-8
 */
@interface NKDAbstractUPCEANBarcode : NKDBarcode
{

}
/*!
 @method calculateWidth
 @abstract Overridden to provide extra space to the left and right needed for printing first and last characters
 */
-(void)calculateWidth;

/*!
 @method firstBar
 @abstract Overridden to set a first bar position indented in from the left to provide room for the first digit
 @result A value that is 10% of the total width. The total width is calculated at 120% needed to hold the barcode.
*/
-(float)firstBar;

/*!
 @method lastBar
 @abstract Overridden to set a last bar position indented from the right to provide room for the check digit.
 @result A value that is 90% of the total width. The total width is calculated at 120% needed to hold the barcode.
*/
-(float)lastBar;

/*!
 @method _encodeChar
 @abstract Simple encoding scheme that returns a 7 character string
 @discussion This routine returns the left-hand odd encoding. Either the handedness or parity can be converted using
                the routines _swapParity: and _swapHandedness
 @result String of 0s and 1s representing this character
*/
-(NSString *)_encodeChar:(char)inChar;

/*!
 @method initiator
 @abstract Returns start character for UPC-A
 @result "101" The start and end character for UPC / EAN
*/
-(NSString *)initiator;

/*!
 @method terminator
 @abstract Returns end character for UPC or EAN barcode
 @result "101" The start and end character for UPC / EAN
*/
-(NSString *)terminator;

/*!
 @method digitsToRight
 @abstract Overridden to specify that one character of the caption prints to the right of the barcode
 @result 1
*/
-(int)digitsToRight;

/*!
 @method barBottom:
 @abstract Overridden to specify that guard bars, terminator and initiator should extend down into the caption area
 @param index The index of the bar that you want to find the bottom for (assuming origin at lower left) as an index of
        completeBarcode
 @result Bottom of the bar specified in inches * kScreenResolution
*/
-(float)barBottom:(int)index;

/*!
 @method digitsToLeft
 @abstract Overridden to specify that one character of the caption prints to the left of the barcode
 @result 1
*/
-(int)digitsToLeft;

/*!
 @method rightCaption
 @abstract Overridden to specify that the check digit prints to the right of the caption
 @result The check digit wrapped in an NSString *
*/
-(NSString *)rightCaption;

@end
