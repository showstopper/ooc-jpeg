import jpeg.Jpeg;

Octet *rawImage;
Int width; 
Int height;
Int bytes_per_pixel = 3;   
Int color_space = JCS_RGB;


func readJpegFile(String fileName) -> Bool{
    
    JpegReader reader = new();
    JpegErrorMgr jerr; 
    JSAMPROW rowPointer[1];
	Long location = 0;
    reader.setErrorMgr(&jerr);
    reader.setStdioSrc(fileName);
    reader.readHeader(true);
    reader.start();
    width = reader.imageWidth;
    height = reader.imageHeight;
    rawImage = (Octet *)malloc(reader.outputWidth*reader.outputHeight*reader.numComponents);
	rowPointer[0] = (Octet *)malloc(reader.outputWidth*reader.numComponents);
	while(reader.outputScanline < reader.imageHeight ) {
		reader.readScanlines(rowPointer, 1);
        for(Int i: 0..(reader.imageWidth*reader.numComponents)) { 
		    rawImage[location++] = rowPointer[0][i];
        }
    }
	reader.finish();
	reader.destroy();
	return true;
}

func writeJpegFile(String fileName) -> Bool {
    
    JpegWriter writer = new(width, height, bytes_per_pixel, color_space);
    JpegErrorMgr jerr;
    JSAMPROW rowPointer[1];
    writer.setErrorMgr(&jerr);
    writer.setStdioDest(fileName);    
    writer.setDefaults();
    writer.start(true);
    while (writer.nextScanline < writer.height) {
        rowPointer[0] = &rawImage[writer.nextScanline*writer.width*writer.inputComponents];
        writer.writeScanlines(rowPointer, 1);
    }
    writer.finish();
    writer.destroy();
    
    return true;
}
      

  

func main()  {
    
    readJpegFile("image_in.jpg");
    writeJpegFile("image_out.jpg");
}
