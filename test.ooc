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
    
    JpegWriter writer = new(width, height, bytes_per_pixel, color_space);
    JpegErrorMgr jerr;
    JSAMPROW rowPointer[1];
    writer.setErrorMgr(&jerr);
    writer.setStdioDest(fileName);    
    writer.setDefaults();
    writer.startCompress(true);
    while (writer.nextScanline < writer.height) {
        rowPointer[0] = &raw_image[writer.nextScanline*writer.width*writer.inputComponents];
        writer.writeScanlines(rowPointer, 1);
    }
    writer.finishCompress();
    writer.destroyCompress();
    
    return true;
}
      

  

func main()  {
    
    readJpegFile("image_in.jpg");
    writeJpegFile("image_out.jpg");
}
