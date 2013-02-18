// -----------------------------------------------------------------------------------
//  NKDBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
/*!
@header NKDBarcode.h
 NKDBarcode is a quasi-abstract class that contains state and actions common to generating many
 different types of barcodes. It encapsulates much of the common behavior of the concrete subclasses that
 implement varoius one dimensional (linear) barcodes. Subclasses will respond to a barcode message by
 returning an NSString of 1s and 0s, assuming that a value of '1' represents a bar of the narrowest size needed
 by this encoding scheme, and that '0' represents a gap of the same size.

 If a subclass modifies this behavior, it should be well documented, and NKDBarcodeOffscreenView will possibly
 have to be modified to accommodate the change.

 Although most barcode specifications allow narrow bar widths as small as 7.5 mils, I am using a default
 size of 13 mils for all barcodes that don't have strict bar-width requirements in their specification (e.g. PostNet)
 because this is an acceptable bar width for most barcodes and many inkjet and laser printers have insufficient resolution 
 to produce a readable code on plain paper at bar widths smaller than this size.

 The framework currently contains subclasses for Code 3 of 9, Extended Code 3 of 9, Interleaved Code
 2 of 5, Modified Plessey and Modified Plessey Hex (not compliant with specs, untested), PostNet,
 UPC-A, Code 128, Industrial 2 of 5, and EAN-13, Codabar, EAN-8 and UPC-E. In some cases, I do not have the complete
 or official specifications. I also, unfortunately, do not have equipment to test some types of barcode, so I welcome
 any help debugging, testing, and validating the encoding schemes of the provided subclasses. No guarantee is made concerning
 the creation of readable code for any given hardware - I've done the best job that I could armed only with my PowerBook,
 a Cue Cat and the specifications I could find.

 If you have complete specifications or information about any dimensional linear barcodes or (for that matter) and other feedback,
 please send it to me at <code>jeff_lamarche&#064;mac.com</code> and I will try to respond. Support for 2-dimensional (matrix)
 barcodes is not currently planned as part of this framework, but if there's an interest, I'll consider adding it. 
*/
#import <Foundation/Foundation.h>

/*!
 @defined kScreenResolution
 @discussion This value is used to determine the drawing location of various bars. Though many
             devices have different resolution, drawing in Cocoa seems to based on 72 pixels per inch
 */
#define kScreenResolution	163.00

/*!
 @class NKDBarcode
 @abstract Superclass of concrete barcode classes.
 @discussion  The Naked Barcode Framework is designed to allow rapid creation and easy maintenance of
 a set of classes for generating resolution independent one-dimensional linear barcodes. NKDBarcode is the root class
 of the NKDBarcode framework.
 */
@interface NKDBarcode : NSObject <NSCopying, NSCoding>
{
    NSString	*content;
    float	height;
    float 	width;
    char	checkDigit;
    float	barWidth;	// bar width in mils (thousands of an inch)
    BOOL	printsCaption;
    float	fontSize;
    float	captionHeight;
}

/*!
 @method initWithContent:
 @abstract Initializes new barcode object to encode provided data.
 @param inContent A string containing the data to be encoded; should use only <B>ASCII-8</B> characters
        (those that can be encoded using a single char in UTF-8)
 @result Returns initialized NKDBarcode class
 */
-(id)initWithContent: (NSString *)inContent;

/*!
 @method initWithContent:printsCaption
 @abstract Initializes new barcode object with provided data and specifies whether a caption should be printed
           below the barcode.
 @param inContent A string containing the data to be encoded; should use only <B>ASCII-8</B> characters
        (those that can be encoded using a single char in UTF-8)
 @param inPrints YES if caption should print.
 @result Returns initialized NKDBarcode class
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;

/*!
@method initWithContent:printsCaption:andBarWidth:andHeight:andFontSize:andCheckDigit:
 @abstract Designated initializer for abstract barcode object.
 @param inContent A string containing the data to be encoded; should use only <B>ASCII-8</B> characters
 (those that can be encoded using a single char in UTF-8)
 @param inPrints YES if caption should print.
 @param inBarWidth Width of the smallest bar or gap to be used, in base units (points)
 @param inHeight Height of the bar (excluding caption) in base units
 @param inFontSize Size of the font to use for the caption
 @param inDigit Check Digit either provided or calculated, -1 if not used or not yet calculated
 @result Returns initialized NKDBarcode class
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
         andBarWidth: (float)inBarWidth
           andHeight: (float)inHeight
         andFontSize: (float)inFontSize
       andCheckDigit: (char)inDigit;

/*!
 @method setContent:
 @abstract Sets the content to provided NSString.
 @param inContent A string containing the data to be encoded; should use only <B>ASCII-8</B> characters
 (those that can be encoded using a single char in UTF-8)
*/
-(void)setContent:(NSString *)inContent;

/*!
 @method setHeight:
 @abstract Sets the barcode height to the provided value.
 @param inHeight Value to set the height to.
 */
-(void)setHeight:(float)inHeight;

/*!
 @method setWidth:
 @abstract Sets the barcode width to the provided value.
 @param inWidth Value to set the width to.
 */
-(void)setWidth:(float)inWidth;

/*!
 @method setFontSize:
 @abstract Sets the size of the font to use
 @param inSize The size (as a float) of the font to use
 */
-(void)setFontSize:(float)inSize;

/*!
 @method setCaptionHeight:
 @abstract: Set amount of space to leave under barcode for the caption
 @param inHeight: Floating point amount of space to set (in inches)
 */
-(void)setCaptionHeight:(float)inHeight;

/*!
 @method captionHeight
 @abstract Returns the amount of space to leave under the barcode for the caption
 @result Floating point value representing the amount of space to leave (in inches)
 */
-(float)captionHeight;

/*!
@method calculateWidth
 @abstract Calculates the correct width for the barcode based on the encoding scheme and the specified bar width.
 */
-(void)calculateWidth;

/*!
 @method setCheckDigit:
 @abstract Sets the check digit to the provided character.
 @param inCheckDigit Character (char, not unichar) to set the check digit to.
 */
-(void)setCheckDigit:(char)inCheckDigit;

/*!
 @method setPrintsCaption:
 @abstract Sets whether this barcode should print the content below the code.
 @param inPrints Boolean value to specify whether the caption should print.
 */
-(void)setPrintsCaption:(BOOL)inPrints;

/*!
 @method setBarWidth:
 @abstract Sets the width of a single bar (represented by a single 1 in the barcode string).
 @param inBarWidth The value to use for the width of a single bar.
 */
-(void)setBarWidth:(float)inBarWidth;

/*!
@method content
 @abstract Accessor method for the data being encoded by this barcode.
 @result Pointer to the NSString that stores the barcode's data.
 */
-(NSString *)content;

/*!
@method height
 @abstract Accessor method for the height of this barcode.
 @result The current height of the barcode in inches.
 */
-(float)height;

/*!
@method width
 @abstract Accessor method for the width of this barcode.
 @result The current width of this barcode in inches.
 */
-(float)width;

/*!
 @method checkDigit
 @abstract Accessor method for the checkDigit for this barcode.
 @discussion Many barcodes offer and some require a check digit that is calculated based on the rest of the content. This
             value shouldn't print as part of the caption and will need to be recalculated if the content changes, so
             it makes sense to store it separately
 @result The check digit character (ASCII-8 char, not unichar)
 */
-(char)checkDigit;

/*!
 @method printsCaption
 @abstract Accessor method for printsCaption.
 @result YES if the content should be printed below the barcode.
 */
-(BOOL)printsCaption;

/*!
 @method barWidth
 @abstract Accessor method for the current width of a single bar in inches
 @result The current width in inches of a single bar or gap.
 */
-(float)barWidth;

/*!
 @method fontSize
 @abstract returns the size of the font to use for the caption
 @result Floating point value representing the size of the font (in points) to use for the caption
 */
-(float) fontSize;

/*!
 @method isSizeValid
 @abstract (Deprecated) Returns true if the supplied image size provides sufficient
           space to create a valid (open) barcode using this encoding scheme.
 @discussion The first version of this barcode framework allowed the user to specify
             the size of the barcode when it was instantiated. This method was
             implemented as a check to make sure that the barcode that was created
             didn't result in a barWidth less than the barcode's specification allowed
             (usually 7.5 mils)
 @result YES if the bar width at these settings is okay according to the specifications.
 */
-(BOOL)isSizeValid;

/*!
 @method generateChecksum
 @abstract Generates the check digit or checksum for this barcode encoding scheme.
 @discussion This can be overridden by objects implementing encoding schemes that
             have a checksum algorithm. You can either require the entire, correct
             number be passed in the constructor including the check digit (parsing
             it out as appropriate, or you can accept the  number without the checksum
             and modify the content accordingly here.
*/
-(void)generateChecksum;

/*!
 @method isContentValid
 @abstract Validates that this barcode supports the data it is encoding.
 @discussion This method checks the actual content string to make sure that this encoding
             scheme can encode the data it contains. For example, numeric-only schemes
             should return false if a string with one or more letters is passed. If there
             is a checksum used for the content. that can also be checked here.  Don't
             override if validation isn't desired or required.
 */
-(BOOL) isContentValid;

/*!
 @method initiator
 @abstract Returns the encoded initiator or alignment bar(s)
 @discussion Returns encoded string representing the left most character. While some barcodes
             do not use this, many do have a required character of sequence of bars or gaps
             that are used for calibration. Sublasses only need to override if such a character
             is needed.
 @result String of 0s and 1s representing the first (non-content) character or alignment bar(s).
 */
-(NSString *)initiator;

/*!
 @method terminator
 @abstract Returns the encoded terminator or alignment bar(s)
 @discussion Returns encoded string representing the right-most characte. While some barcodes
             do not use this, many do have a required character of sequence of bars or gaps
             that are used for calibration. Sublasses only need to override if such a character
             is needed.
 @result String of 0s and 1s representing the last (non-content) character or alignment bar(s).
 */
-(NSString *)terminator;

/*!
 @method _encodeChar
 @abstract Private method to turn a single character into a string of 1s and 0s.
 @discussion This routine returns an NSString representing a single character. This private method
             is used by the default getBarcode function, which is responsible for ordering the
             characters (if necessary and returning the entire encoded string, excluding the
             terminator and initiator.
 @result String of 0s and 1s representing inChar encoded for this barcode.
 */
-(NSString *)_encodeChar:(char)inChar;

/*!
 @method barcode:
 @abstract Returns string of 0s and 1s representing the content for this type of barcode.
 @discussion This method returns a string representing the entire barcode, excluding the initiator
             and terminator.
 @result String of 0s and 1s representing the content.
 */
-(NSString *)barcode;

/*!
 @method completeBarcode
 @abstract Method to get the entire barcode as a string of 0s and 1s
 @discussion Returns a string representing the entire barcode, including terminator and initiator.
 @result String of 0s and 1s representing the entire barcode
 */
-(NSString *)completeBarcode;

/*!
 @method digitsToLeft
 @abstract Returns number of digits to print to the left of the first bar.
 @discussion For encoders with intruding captions such as UPC and EAN barcodes, this method
             tells how many of the digits of the content should be printed to the left of the barcode,
             rather than intruding on the barcode or printing below the barcode. This only needs to be
             overridden if you need a value other than 0
 @result The number of characters to print to the left.
 */
-(int)digitsToLeft;

/*!
 @method digitsToRight
 @abstract Returns number of digits to print to the right of the last bar.
 @discussion For encoders with intruding captions such as UPC and EAN barcodes, this method
             tells how many of the digits of the content should be printed to the right of the barcode,
             rather than intruding on the barcode or printing below the barcode. This only needs to be
             overridden if you need a value other than 0
 @result The number of characters to print to the right.
*/
-(int)digitsToRight;

/*!
 @method leftCaption
 @abstract Returns string representing the characters to print to the left of the first bar
 @discussion Returns string representing the portion of the caption that goes to the left of the barcode.
 @result A string with the data to print to the left.
*/
-(NSString *)leftCaption;

/*!
 @method rightCaption
 @abstract Returns string representing the characters to print to the right of the last bar
 @discussion Returns string representing the portion of the caption that goes to the right of the barcode.
 @result A string with the data to print to the right.
 */
-(NSString *)rightCaption;

/*!
 @method caption
 @abstract Returns content to print below the barcode.
 @result String representing the portion of the caption that goes under (or intrudes upon) the barcode.
*/
-(NSString *)caption;

/*!
 @method barBottom:
 @abstract Designates the bottom of the bar within the barcode for the bar at a given index.
 @discussion Given an index which corresponds to the bar / gap number (counting from left), where should
             the bottom of the bar be. For most barcodes this value will always be the bottom of the barcode
             excluding the caption, but some, like UPC and EAN have different bar bottoms for some bars.
             Assumes that origin (0,0) is in lower left.
 @param index The bar (from the left, 0-indexed) to specify the bottom position for.
 @result The bottom of the bar in inches from the bottom of the barcode.
*/
-(float)barBottom:(int)index;

/*!
 @method barTop:
 @abstract Designates the top of the bar within the barcode for the bar at a given index.
 @discussion Given an index which corresponds to the bar/gap number (counting from left, 0-indexed),
             this method will tell where the top of the bar should be. For most barcodes this value will
             always be the top of the barcode excluding the caption, since most barcodes have a uniform top, but
             some, like PostNet use different bar tops as part of the encoding scheme.
 @param index The bar (from the left, 0 indexed) to specify the top position for.
 @result The top of the bar in inches from the bottom of the barcode.
 */
-(float)barTop:(int)index;

/*!
 @method firstBar
 @abstract Returns the position, from the left, specified in inches where the first bar prints
 @discussion Returns the the horizontal position of the left edge of the first bar or gap. Typically, this is 0,
             but some code, like EAN/UPC require some digits to print to the left and/or right of the code, meaning
             that we need allocate some white space by skipping some pixels before drawing the first bar
 @result The x-position in inches where the first bar prints
 */
-(float)firstBar;

/*!
 @method lastBar
 @abstract Returns the position, from the left, specified in inches where the last bar ends
 @discussion Returns the the horizontal position of the right edge of the last bar or gap. Typically, this is the
             same as [barcode width] but some codes, like EAN/UPC require some digits to print to the left and/or
             right of the code, meaning that we need allocate some white space by ending the codes before the end
             of the barcode. This is generally the right edge of the last barcode less one barwidth
 @result The x-position in inches where the last bar ends
 */
-(float)lastBar;

@end
