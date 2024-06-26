// Implementation file for an image reader that takes in jpg or png images and
// extracts the RGB values, storing it in an array.

#include<stdio.h>
#include<jpeglib.h>
#include <cstdio>
#include"imageReader.h"

int MEDIAN_FILTER::imageReader::loadJpg(const char* Name) {
    unsigned char a, r, g, b;
    int width, height;
    struct jpeg_decompress_struct cinfo;
    struct jpeg_error_mgr jerr;
    FILE * infile;        /* source file */
    JSAMPARRAY pJpegBuffer;       /* Output row buffer */
    int row_stride;       /* physical row width in output buffer */

    struct Pixel {
        unsigned char r, g, b, a;
    };

    if ((infile = fopen(Name, "rb")) == NULL) {
        fprintf(stderr, "can't open %s\\n", Name);
        return 0;
    }

    cinfo.err = jpeg_std_error(&jerr);
    jpeg_create_decompress(&cinfo);
    jpeg_stdio_src(&cinfo, infile);
    (void) jpeg_read_header(&cinfo, TRUE);
    (void) jpeg_start_decompress(&cinfo);
    width = cinfo.output_width;
    height = cinfo.output_height;

    Pixel* pixels = new Pixel[width * height];
    Pixel* pPixel = pixels;

    // unsigned char * pDummy = new unsigned char [width*height*4];
    // unsigned char * pTest = pDummy;
    if (!pixels) {
        printf("NO MEM FOR JPEG CONVERT!\\n");
        return 0;
    }

    row_stride = width * cinfo.output_components;
    pJpegBuffer = (*cinfo.mem->alloc_sarray) ((j_common_ptr) &cinfo, JPOOL_IMAGE, row_stride, 1);

    while (cinfo.output_scanline < cinfo.output_height) {
        (void) jpeg_read_scanlines(&cinfo, pJpegBuffer, 1);
        for (int x = 0; x < width; x++) {
            pPixel->a = 0; // alpha value is not supported on jpg
            pPixel->r = pJpegBuffer[0][cinfo.output_components * x];
            if (cinfo.output_components > 2) {
                pPixel->g = pJpegBuffer[0][cinfo.output_components * x + 1];
                pPixel->b = pJpegBuffer[0][cinfo.output_components * x + 2];
            } else {
                pPixel->g = pPixel->r;
                pPixel->b = pPixel->r;
            }
            pPixel++;
            // should call "delete[] pixels;"
        }
    }

    fclose(infile);
    (void) jpeg_finish_decompress(&cinfo);
    jpeg_destroy_decompress(&cinfo);
}
