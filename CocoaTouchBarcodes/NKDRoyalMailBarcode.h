// -----------------------------------------------------------------------------------
//  NKDRoyalMailBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Trevor Strohman <trevor@ampersandbox.com> on Sun Apr 20 2003.
//  ©2003 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "NKDBarcode.h"

/*!
@header NKDPostnetBarcode.h

 This is a concrete subclass of NKDBarcode that implements a 4 state barcode that uses
 the <i>height</i> of the bars, rather than the width, to encode numeric data according to
 Royal Mail specifications.  This barcode is known as the Royal Mail Four-State Customer
 Code (RM4SCC) in some documentation, and as the Customer Barcode (CBC) in other documentation.

 See documentation for Mailsort 700 for more details on this barcode format.  This barcode
 format is the same as that used in the Netherlands, and similar (possibly the same) as
 the format used on Australian mail.
 */


/*!
 @defined CBC_INCHES_PER_MILLIMETER
 @discussion Number of inches per millimeter (1/25.4).
 */

#define CBC_INCHES_PER_MILLIMETER (1./25.4)

/*!
 @defined CBC_BAR_WIDTH
 @discussion Width, in millimeters, of a CBC bar.  Specifications allow a range: 0.38-0.63mm.
 */

#define CBC_BAR_WIDTH	(0.5)


/*!
@defined CBC_DESCENDER_BOTTOM
@discussion Defines the lowest point of the descender (in millimeters).
 */

#define CBC_DESCENDER_BOTTOM (0.0)

/*!
 @defined CBC_TRACK_BOTTOM
 @discussion Defines the lower boundary of the track (in millimeters).
 */

#define CBC_TRACK_BOTTOM (1.9 + CBC_DESCENDER_BOTTOM)

/*!
@defined CBC_TRACK_TOP
 @dicussion Defines the upper boundary of the track (in millimeters).
 */

#define CBC_TRACK_TOP (1.25 + CBC_TRACK_BOTTOM)

/*!
@defined CBC_ASCENDER_TOP
 @discussion Defines the highest point of the ascender (in millimeters).
 */

#define CBC_ASCENDER_TOP (1.9 + CBC_TRACK_TOP)

/*!
@class NKDRoyalMailBarcode
@abstract Royal Mail routing barcode
@discussion Implementation of the RM4SCC barcode specification.
*/
@interface NKDRoyalMailBarcode : NKDBarcode {
}

/*!
 @method initWithContent:printsCaption
 @abstract Overridden method that sets values for this barcode according to Royal Mail specifications
 @discussion This constructor also calculates the checkdigit.
 @param inContent The content to be encoded (can contain A-Z and 0-9)
 @param inPrints Ignored; RM4SCC never uses a caption.
 @result Initialized barcode encoding <i>content</i> using RM4SCC encoding
 */

-(id)initWithContent:(NSString*)inContent
       printsCaption:(BOOL)inPrints;

/*!
 @method printsCaption
 @abstract Overriden because RM4SCC never uses a caption.
 @result NO
 */

-(BOOL)printsCaption;

/*!
 @method initiator
 @abstract Initiator in RM4SCC is a single ascender plus a gap of the bar width.
 @result "10"
*/

-(NSString *)initiator;

/*!
 @method terminator
 @abstract Terminating character in RM4SCC is a single full bar.
 @result "1"
*/
-(NSString *)terminator;

/*!
 @method _encodeChar:
 @abstract Simple routine to return four bars separated by gaps
 @discussion All RM4SCC characters are 4 bars long.
 @result "10101010"
*/
-(NSString *)_encodeChar:(char)inChar;

/*!
 @method barTop:
 @abstract Returns the location of the top of a specified bar (assuming origin at lower left)
 @discussion Depending on the digit and bar, returns either CBC_TRACK_TOP or CBC_ASCENDER_TOP.
 @result CBC_TRACK_TOP or CBC_ASCENDER_TOP
*/
-(float)barTop:(int)index;

/*!
 @method barBottom:
 @abstract Returns the location of the bottom of a specified bar (assuming origin at lower left)
 @discussion Depending on the digit and bar, returns either CBC_TRACK_BOTTOM or CBC_DESCENDER_BOTTOM.
 @result CBC_TRACK_BOTTOM or CBC_DESCENDER_BOTTOM
*/
-(float)barBottom:(int)index;

/*!
 @method generateChecksum
 @abstract Generates a checksum digit equal to ((ascenders%6)*6)+descenders, where ascenders and descenders are
           the weighted sums of the descenders and ascenders in the bar code digits.
*/
-(void)generateChecksum;

@end
