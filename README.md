This is a fork of [Jeff Lamarche's Cocoa Barcodes project](http://code.google.com/p/cocoabarcodes/), with the code modified to work on the iPhone and iPad.  In my testing, a CCD and laser scanner can read UPC and Code 128 barcodes directly from the screen w/ no issue.  I haven't tested other barcodes yet.

Usage:
You can add the project as a dependency to your existing project and add a target dependency on the static library target.  Alternatively you can add the source code bulk to your own project.

If you use the static library dependency, you'll want to ensure that you are compiling your own project with the `-ObjC` "Other Linker Flag" in your project settings.

To use the library, you'll want to include the relevant header file for the barcode you want to generate, as well as the UIImage category for generating the image.

```objectivec
#import "NKDUPCEBarcode.h"
#import "UIImage-NKDBarcode.h"

// etc...

NKDUPCEBarcode * code = [[NKDUPCEBarcode alloc] initWithContent:@"Your Barcode Contents"];
NSData * generatedPdf = [UIImage pdfFromBarcode:code]; // Generate the barcode as a PDF
UIImage * generatedImage = [UIImage imageFromBarcode:code]; // ..or as a less accurate UIImage
```

TODO:
 * Add tests. (!!!!!!!!!!!)
 * Better documentation
 * Really, the entire API pretty much needs a refactor. The UIImage category as entry point into generating images as a start, NKDBarcodeOffscreenView doesn't really need to subclass UIView, etc.. 
 * Leak checks
 * ARC compatibility? I guess?

Things that are missing:

 * Rendering the actual numbers of a code below the barcode
 * rectForPage, knowsPageRange don't have any affect on the barcode rendering now

Things that have changed:

 * the UIImage for the barcode is generated on the calling thread, as opposed to the library's old behavior of generating the image on a separate thread
 * the library provides UIImage and PDF generation of barcodes - PDF is more accurate

Things that misbehave:

 * The Code128 generation works for many common cases, but we need a test suite to verify behavior

Things that have been fixed:

 * The Code128 checksum generation has had some issues fixed
 * Generation of EAN-13 barcodes that start with 2. See http://code.google.com/p/cocoabarcodes/issues/detail?id=3

Current status:

 * I'm very inactive with maintenance.  I'm not currently maintaining the code, nor do I have a plan to get to any of the major checklist items anytime soon.  If you're interested in taking a more active role in development, contact me and I'll do what I can to help you out.

Other contributors:
 * [dalewking](https://github.com/dalewking)
 * [mdestagnol](https://github.com/mdestagnol)
 * [teh1ghool](https://github.com/teh1ghool)
 * [jasonkhonm](https://github.com/jasonkhonm)


