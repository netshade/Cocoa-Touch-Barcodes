// -----------------------------------------------------------------------------------
//  NKDInterleavedTwoOfFiveBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 04 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDBarcode.h"
/*!
@header NKDInterleavedTwoOfFiveBarcode.h

 Interleaved 2 of 5 uses Wide and Narrow bars interleaved (digits 1 and 2 occupy the same
    space, one is bars, the other by the spaces. Therefore, we won't be using _encodeChar - we'll
    override the barcode method to use a class-specific method called _getBarForDigit:forBarNumber

    Because of the interleaving, there must be an even number of characters; With the check-digit, odd
    length values become even and even-length become odd. Odd numbers (even when check-digit used)
    are zero-padded to make an even-length value.
                                                           */

/*!
 @defined NARROW_BAR
 @discussion YES value returned by _getBarForDigit:forBarNumber to identify a narrow bar or gap.
 */
#define	NARROW_BAR YES

/*!
 @defined WIDE_BAR
 @discussion NO value returned by _getBarForDigit:forBarNumber to identify a wide bar or gap.
 */
#define WIDE_BAR NO


/*!
 @class NKDInterleavedTwoOfFiveBarcode
 @abstract Two of Five barcode that uses both bars and gaps to encode numeric data
 @discussion Interleaved 2 of 5 uses Wide and Narrow bars interleaved (digits 1 and 2 occupy the same
            space, one is bars, the other by the spaces. Therefore, we won't be using _encodeChar - we'll
            override the barcode method to use a class-specific method called _getBarForDigit:forBarNumber

            Because of the interleaving, there must be an even number of characters; With the check-digit, odd
            length values become even and even-length become odd. Odd numbers (even when check-digit used)
            are zero-padded to make an even-length value.
 */
@interface NKDInterleavedTwoOfFiveBarcode : NKDBarcode
{

}
/*!
 @method barcode
 @abstract Overridden to implement interleaving of encoding
 @discussion Most other barcodes implemented in this framework use a distinct set of bars and gaps to represent
            a single character. The <I>interleaved</I> 2 of 5 barcode encodes two characters in each distinct
            grouping - one using the bar widths and one using the spaces. Therefore, we have to encode two characters
            at a time when the superclass behavior is to encode individual characters.
 @result String of 0s and 1s that represent the encoded data
 */
 -(NSString *)barcode;

/*!
 @method _getBarForDigit:forBarNumber:
 @abstract Tells if the (bar/gap) in a particular position for a particular character should be wide or narrow.
 @discussion This is a private method used by the overridden barcode method.
 */
-(BOOL)_getBarForDigit:(char)inChar forBarNumber:(int)theBar;

/*!
 @method initiator
 @abstract Overriden method specifies Interleaved Two of Five start character
 @result "1010" representing narrow bar, narrow gap, narrow bar, narrow gap
 */
-(NSString *)initiator;
/*!
 @method terminator
 @abstract Overriden method specifies Interleaved Two of Five stop character
 @result "11101" representing medium bar, narrow gap, narrow bar narrow gap. The two narrow bars allows the code
                to be read in reverse; "1010" could also be used, but would result in a unidirectional barcode
 */
-(NSString *)terminator;

/*!
 @method generateChecksum
 @abstract Generates simple 10-modulus(10) check digit
 @discussion The check digit for interleaved 2 of 5 is a simple modulus 10 calculation - in other words, the check digit is what
            number needs to be added to the sum of the other digits to make a number evenly divisible by 10.
 */
-(void)generateChecksum;

/*!
 @method isContentValid
 @abstract Enforces numeric-only content for this barcode.
 @result YES if the provided string value has only numeric values, NO otherwise
 */
-(BOOL) isContentValid;
@end
