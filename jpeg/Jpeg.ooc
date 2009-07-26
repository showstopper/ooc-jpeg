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
        
        JpegCreateCompress(&cinfo);
        cinfo.image_width = width;
        cinfo.image_height = height;
        cinfo.input_components = inputComponents;
        cinfo.in_color_space = colorSpace;
    }
     
    func setStdioDest(String fileName) {
        FILE *f = openWrapper(fileName, "wb");
        jpeg_stdio_dest(&cinfo, f);
    }

    func setDefaults() {
        jpeg_set_defaults(&cinfo);
    }

    func setErrorMgr(JpegErrorMgr* mgr) {
        cinfo.err = JpegStdError(mgr);
    }
    
    func start(Bool writeAllTables) {
        jpeg_start_compress(&cinfo, writeAllTables);
    }
    
    func writeScanlines(JSAMPARRAY scanLines, Int maxLines) {
        jpeg_write_scanlines(&cinfo, scanLines, maxLines);
    }

    func finish() {
        jpeg_finish_compress(&cinfo);
    }

    func destroy() {
        jpeg_destroy_compress(&cinfo);
    }

             
    /* Getter-functions  ----------------------------------------------- */
    func nextScanline -> JDIMENSION {cinfo.next_scanline;}
    func height -> Int {cinfo.image_height;}
    func width -> Int {cinfo.image_width;}
    func inputComponents -> Int {cinfo.input_components;}
    func inColorSpace -> Int {cinfo.in_color_space;}


}
   
class JpegReader {

    JpegDecompressStruct cinfo;
   
    func new() {
        JpegCreateDecompress(&cinfo);
    }

    func start() {
        jpeg_start_decompress(&cinfo);
    }

    func finish() {
        jpeg_finish_decompress(&cinfo);
    }

    func destroy() {
        jpeg_destroy_decompress(&cinfo);
    }     
    
    func readHeader(Bool reqImage) {
        jpeg_read_header(&cinfo, reqImage);
    }

    func setStdioSrc(String fileName) {
        FILE *f = openWrapper(fileName, "rb");
        jpeg_stdio_src(&cinfo, f);
    }

    func readScanlines(JSAMPARRAY scanLines, Int maxLines) {
        jpeg_read_scanlines(&cinfo, scanLines, maxLines);
    }

    func setErrorMgr(JpegErrorMgr* mgr) {
        cinfo.err = JpegStdError(mgr);
    }
    
    /* Getter-functions  ----------------------------------------------- */
    func imageHeight -> Int {cinfo.image_height;}
    func imageWidth -> Int {cinfo.image_width;}
    func outputWidth -> Int {cinfo.output_width;}
    func outputHeight -> Int {cinfo.output_height;}
    func outputScanline -> JDIMENSION {cinfo.output_scanline;}
    func numComponents -> Int {cinfo.num_components;}
    
}    

static func openWrapper(String fileName, String mode) -> FILE *{
    // TODO: Use Exceptions when we have them ;)
    FILE *f = fopen(fileName, mode);
    if (!f) {
        fprintf(stderr, "[jpeg.Jpeg] Couldn't open %s\n", fileName ); 
        exit(-1);
    }
    return f;
}


static  func JpegCreateDecompress(JDecompressPtr cinfo) {
    jpeg_create_decompress(cinfo);
}

static func JpegCreateCompress(JCompressPtr cinfo) {
    jpeg_create_compress(cinfo);
}


static func JpegStdError(JpegErrorMgr *error) -> struct jpeg_error_mgr *{
    return jpeg_std_error(error);
}

