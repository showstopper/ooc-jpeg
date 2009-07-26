include stdlib;
include stdio;
include jpeglib;

use jpeg;

ctype JSAMPROW;
ctype jpeg_decompress_struct;
ctype jpeg_compress_struct;
ctype jpeg_create_compress;
ctype jpeg_create_decompress;
ctype jpeg_error_mgr;
ctype JCS_RGB;
ctype JSAMPARRAY;
ctype JDIMENSION;
ctype FILE;

typedef struct jpeg_compress_struct JpegCompressStruct;
typedef struct jpeg_decompress_struct JpegDecompressStruct;
typedef struct jpeg_error_mgr JpegErrorMgr;
 
typedef j_compress_ptr JCompressPtr;
typedef j_decompress_ptr JDecompressPtr;


class JpegWriter {

    JpegCompressStruct cinfo;
    
    func new (Int width, Int height, Int inputComponents, Int colorSpace) {
        
        JpegCreateCompress(&this.cinfo);
        this.cinfo.image_width = width;
        this.cinfo.image_height = height;
        this.cinfo.input_components = inputComponents;
        this.cinfo.in_color_space = colorSpace;
    }
    func createCompress() {
        JpegCreateCompress(&this.cinfo);
    }
  
    func setStdioDest(String fileName) {
        JpegStdioDest(&this.cinfo, fileName);
    }

    func setDefaults() {
        JpegSetDefaults(&this.cinfo);
    }

    func setErrorMgr(JpegErrorMgr *mgr) {
        this.cinfo.err = JpegStdError(mgr);
    }
    
    func startCompress(bool writeAllTables) {
        JpegStartCompress(&this.cinfo, writeAllTables);
    }
    
    func writeScanlines(JSAMPARRAY scanLines, Int maxLines) {
        JpegWriteScanlines(&this.cinfo, scanLines, maxLines);
    }

    func finishCompress() {
        JpegFinishCompress(&this.cinfo);
    }

    func destroyCompress() {
        JpegDestroyCompress(&this.cinfo);
    }

         
    /* Getter-functions  ----------------------------------------------- */
    func nextScanline -> JDIMENSION {this.cinfo.next_scanline;}
    func height -> Int {return this.cinfo.image_height;}
    func width -> Int {return this.cinfo.image_width;}
    func inputComponents -> Int {return this.cinfo.input_components;}
    func inColorSpace -> Int {return this.cinfo.in_color_space;}


}
   
     
    
static func openWrapper(String fileName, String mode) -> FILE *{
    FILE *f = fopen(fileName, mode);
    if (!f) {
         printf("File not found!\n");
         printf("Abort");
         exit(-1);
    }
    return f;
}

unmangled func JpegStdioSrc(JDecompressPtr cinfo, String fileName)  {
    
    FILE *f = openWrapper(fileName, "rb");    
    jpeg_stdio_src(cinfo, f);
} 

unmangled func JpegStdioDest(JCompressPtr cinfo, String fileName) {
    
    FILE *f = openWrapper(fileName, "wb");
    jpeg_stdio_dest(cinfo, f);
}

unmangled func JpegCreateCompress(JCompressPtr cinfo) {
    jpeg_create_compress(cinfo);
}

unmangled func JpegCreateDecompress(JDecompressPtr cinfo) {
    jpeg_create_decompress(cinfo);
}

unmangled func JpegStdError(JpegErrorMgr *error) -> struct jpeg_error_mgr *{
    return jpeg_std_error(error);
}

unmangled func JpegReadHeader(JDecompressPtr cinfo, Bool reqImage) {
    jpeg_read_header(cinfo, reqImage);
}

unmangled func JpegReadScanlines(JDecompressPtr cinfo, 
                                 JSAMPARRAY scanLines, 
                                 JDIMENSION maxLines) 
{
    jpeg_read_scanlines(cinfo, scanLines, maxLines);
}

unmangled func JpegWriteScanlines(JCompressPtr cinfo, 
                                  JSAMPARRAY scanLines, 
                                  JDIMENSION maxLines) 
{
    jpeg_write_scanlines(cinfo, scanLines, maxLines);
}

unmangled func JpegStartDecompress(JDecompressPtr cinfo) {
    jpeg_start_decompress(cinfo);
}

unmangled func JpegFinishDecompress(JDecompressPtr cinfo) {
    jpeg_finish_decompress(cinfo);
}

unmangled func JpegDestroyDecompress(JDecompressPtr cinfo) {
    jpeg_destroy_decompress(cinfo);
}

unmangled func JpegStartCompress(JCompressPtr cinfo, Bool writeAllTables) {
    jpeg_start_compress(cinfo, writeAllTables);
}

unmangled func JpegFinishCompress(JCompressPtr cinfo) {
    jpeg_finish_compress(cinfo);
}

unmangled func JpegDestroyCompress(JCompressPtr cinfo) {
    jpeg_destroy_compress(cinfo);
}

unmangled func JpegSetDefaults(JCompressPtr cinfo) {
    jpeg_set_defaults(cinfo);
}
