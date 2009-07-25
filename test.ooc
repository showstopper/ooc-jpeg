import jpeg.Jpeg;

Octet *raw_image;
Int width; 
Int height;
Int bytes_per_pixel = 3;   
Int color_space = JCS_RGB;


func readJpegFile(String fileName) -> Bool{
    JpegDecompressStruct cinfo;
	JpegErrorMgr jerr;
	JSAMPROW rowPointer[1];
	Long location = 0;
	cinfo.err = JpegStdError(&jerr);
	JpegCreateDecompress(&cinfo);
	JpegStdioSrc(&cinfo, fileName);
	JpegReadHeader(&cinfo, true);
    JpegStartDecompress(&cinfo);
    width = cinfo.image_width; 
    height = cinfo.image_height;
    raw_image = (Octet *)malloc( cinfo.output_width*cinfo.output_height*cinfo.num_components );
	rowPointer[0] = (Octet *)malloc( cinfo.output_width*cinfo.num_components);
	while(cinfo.output_scanline < cinfo.image_height ) {
		JpegReadScanlines(&cinfo, rowPointer, 1);
		for(Int i: 0..(cinfo.image_width*cinfo.num_components)) { 
		    raw_image[location++] = rowPointer[0][i];
        }
    }
	JpegFinishDecompress(&cinfo);
	JpegDestroyDecompress(&cinfo);
	return true;
}

func writeJpegFile(String fileName) -> Bool {
    JpegCompressStruct cinfo;
    JpegErrorMgr jerr;
    JSAMPROW rowPointer[1];
    cinfo.err = JpegStdError(&jerr);
    
    JpegCreateCompress(&cinfo);
    JpegStdioDest(&cinfo, fileName);
    cinfo.image_width = width;
    cinfo.image_height = height;
    cinfo.input_components = bytes_per_pixel;
    cinfo.in_color_space = color_space;
    
    JpegSetDefaults(&cinfo);
    JpegStartCompress(&cinfo, true);
    
    while (cinfo.next_scanline < cinfo.image_height) {
        rowPointer[0] = &raw_image[cinfo.next_scanline*cinfo.image_width*cinfo.input_components];
        JpegWriteScanlines(&cinfo, rowPointer, 1);
    }
    
    JpegFinishCompress(&cinfo);
    JpegDestroyCompress(&cinfo);
    
    return true;
}
      

  

func main()  {
    
    readJpegFile("image_in.jpg");
    writeJpegFile("image_out.jpg");
}
