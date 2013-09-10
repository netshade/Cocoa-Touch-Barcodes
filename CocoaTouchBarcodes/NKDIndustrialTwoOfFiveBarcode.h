// -----------------------------------------------------------------------------------
//  NKDIndustrialTwoOfFiveBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Fri May 10 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDInterleavedTwoOfFiveBarcode.h"
/*!
 @header NKDIdustrialTwoOfFiveBarcode.h

 The Industrial variant of the two of five barcode is nearly identical to the interleaved two of five, except
 that the gaps are not used to encode data, only the bar widths are read. The industrial two of five is less
 compact (and less common) than its interleaved cousin.

 I do not have "official" specification for this barcode, and was not able to find out the correct width for the
 inter-bar gap. I originally used one narrow-bar-width, which seemed to be too small, so I bumped it up to two narrow-bar-widths
 which is exactly half-way between a narrow-bar (1*barWidth) and a wide-bar (3*barWidth)
 */

/*!
 @class NKDIndustrialTwoOfF/iveBarcode
 */
@interface NKDIndustrialTwoOfFiveBarcode : NKDInterleavedTwoOfFiveBarcode
{

}
/*!
 @method barcode
 @abstract Overridden to prevent the interleaving behavior of the superclass
 @result String of 0s and 1s representing content
 */
-(NSString *)barcode;
@end
