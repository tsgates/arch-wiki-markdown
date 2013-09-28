Djvu
====

  
 From Wikipedia's DjVu Page:

DjVu is a computer file format designed primarily to store scanned
documents, especially those containing a combination of text, line
drawings, indexed color images, and photographs. It uses technologies
such as image layer separation of text and background/images,
progressive loading, arithmetic coding, and lossy compression for
bitonal (monochrome) images. This allows for high-quality, readable
images to be stored in a minimum of space, so that they can be made
available on the web.

DjVu has been promoted as an alternative to PDF, promising smaller files
than PDF for most scanned documents. The DjVu developers report that
color magazine pages compress to 40–70 kB, black and white technical
papers compress to 15–40 kB, and ancient manuscripts compress to around
100 kB; a satisfactory JPEG image typically requires 500 kB. Like PDF,
DjVu can contain an OCR text layer, making it easy to perform copy and
paste and text search operations.

Free browser plug-ins and desktop viewers from different developers are
available from the djvu.org website. DjVu is supported by a number of
multi-format document viewers and e-book reader software on Linux
(Okular, Evince), Android (VuDroid), Windows (SumatraPDF), iPhone/iPad
(Stanza), and BlackBerry OS (DjVuBB).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 How It Works                                                       |
| -   2 Installation                                                       |
| -   3 DjVu Manipulations                                                 |
|     -   3.1 Convert DjVu to images                                       |
|     -   3.2 Processing Images                                            |
|     -   3.3 Make DjVu from Images                                        |
+--------------------------------------------------------------------------+

How It Works
------------

From MobileRead Wiki's DjVU Page

DjVu starts by segmenting a page into layers.

       Foreground layer includes text, line art and other thin, low-color elements.
       Background layer includes photos, graphics, tint, and paper texture. Areas of the background that are covered by the foreground are smoothly interpolated to minimize coding costs. Lower resolution is used on this layer. 

Then the foreground layer is further divided into black and white mask
layer and a color mask layer.

Once everything is separated different compression techniques are used
on the different layers. For example the black and white stuff that
looks like text or repeated graphics is compressed using pattern
matching. Repeats are stored once as individual elements in another
layer and then placed on the page by just referencing the location.
Using this "dictionary" of shapes permits high compression, typically
100 to 1, with precise reproduction.

The foreground color layer is compressed using a similar technique to
JPEG 2000. The background layer is compressed using a technique that
typically 3 times better than classic JPEG.

These techniques permit a visually better image than JPEG with much less
storage.

DjVu supports an OCR hidden XML text layer that permits text searching,
indexing etc and works even with color text. The OCR is superior to
traditional approaches on colored background.

When separate layers are not needed the format is called IW44.

Installation
------------

There are several packages that can be installed to enable use of the
DjVu format.

-   djvulibre a suite to create, manipulate and view DjVu documents.

-   pdf2djvu a tool used to create DjVu files from PDF files.

-   djview4 a portable DjVu viewer and browser plugin.

Read each tool's man to find additional information.

DjVu Manipulations
------------------

> Convert DjVu to images

Break Djvu into separate pages:

     djvmcvt -i input.djvu /path/to/out/dir output-index.djvu

Convert Djvu pages into images:

     ddjvu --format=tiff page.djvu page.tiff

Convert Djvu pages into PDF:

     ddjvu --format=pdf inputfile.djvu ouputfile.pdf

You can also use --page to export specific pages:

     ddjvu --format=tiff --page=1-10 input.djvu output.tiff

this will convert pages from 1 to 10 into one tiff file.

> Processing Images

You can use scantailor to:

-   fix orientation
-   split pages
-   deskew
-   crop
-   adjust margins

> Make DjVu from Images

There is a useful script img2djvu-git.

     img2djvu -d600 -v1 ./out

it will create 600dpi out.djvu from all files in ./out directory.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Djvu&oldid=253184"

Category:

-   Office
