/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Top testbenches' auxiliary submodule.
 * It creates a .tiff image file.
 * The image directory is specified in the FILE_DIR parameter.
 */

`timescale 1 ns / 1 ps

module tiff_writer #(
    parameter XDIM = 16'd1056,
    parameter YDIM = 16'd628,
    parameter FILE_DIR = "../../results"
) (
    input logic       clk,
    input logic [7:0] r,
    input logic [7:0] g,
    input logic [7:0] b,
    input logic       go
);


/**
 * Local variables and signals
 */

logic [15:0] xdim = XDIM;
logic [15:0] ydim = YDIM;

integer file_ptr;
integer file_open;
integer frame_number = 0;

logic go_delayed = 0;


/**
 * Tasks and functions
 */

task open_file;
    input integer number;
    string file_name;

    file_name = $sformatf("%s/frame%03d.tif", FILE_DIR, number);
    file_ptr  = $fopen(file_name, "wb");
    file_open = 1;
endtask

task close_file;
    $fclose(file_ptr);
    file_open = 0;
endtask

task write_byte;
    input [7:0] data;

    $fwriteb(file_ptr, "%c", data);
endtask

task write_header;
    input [15:0] whxdim;
    input [15:0] whydim;
    integer numbytes;

    // calculate some additional info, the
    // number of bytes in the image is going
    // to be the number of pixels times 3
    // for 24-bit pixel data.

    numbytes = whxdim * whydim * 3;

    // write the byte order in the header
    // this indicates big endian, which
    // means multi-byte fields are written
    // with the highest order bytes first
    // starting offset: 0x0000

    write_byte(8'h4d);
    write_byte(8'h4d);

    // write the tiff file identifier
    // starting offset: 0x0002

    write_byte(8'h00);
    write_byte(8'h2a);

    // write a pointer to the first and only
    // image file directory at 0x00000010,
    // which must begin on a word boundary
    // starting offset: 0x0004

    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h10);

    // write out zeroes for padding up to the
    // start of the image file directory
    // starting offset: 0x0008

    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);

    // start of the image file directory
    // contains number of directory entries
    // which are only the 12 required entries
    // starting offset: 0x0010

    write_byte(8'h00);
    write_byte(8'h0c);

    // entry one, image width
    // starting offset: 0x0012

    write_byte(8'h01); // id
    write_byte(8'h00); // id
    write_byte(8'h00); // type is 32-bit
    write_byte(8'h04); // type is 32-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // value for number of x-pixels
    write_byte(8'h00); // value for number of x-pixels
    write_byte(xdim[15:8]); // value for number of x-pixels
    write_byte(xdim[ 7:0]); // value for number of x-pixels

    // entry two, image length
    // starting offset: 0x001e

    write_byte(8'h01); // id
    write_byte(8'h01); // id
    write_byte(8'h00); // type is 32-bit
    write_byte(8'h04); // type is 32-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // value for number of y-pixels
    write_byte(8'h00); // value for number of y-pixels
    write_byte(ydim[15:8]); // value for number of y-pixels
    write_byte(ydim[ 7:0]); // value for number of y-pixels

    // entry three, bits per sample
    // starting offset: 0x002a

    write_byte(8'h01); // id
    write_byte(8'h02); // id
    write_byte(8'h00); // type is 16-bit
    write_byte(8'h03); // type is 16-bit
    write_byte(8'h00); // three values exist
    write_byte(8'h00); // three values exist
    write_byte(8'h00); // three values exist
    write_byte(8'h03); // three values exist
    write_byte(8'h00); // pointer to bps triple
    write_byte(8'h00); // pointer to bps triple
    write_byte(8'h00); // pointer to bps triple
    write_byte(8'hb8); // pointer to bps triple

    // entry four, compression
    // starting offset: 0x0036

    write_byte(8'h01); // id
    write_byte(8'h03); // id
    write_byte(8'h00); // type is 16-bit
    write_byte(8'h03); // type is 16-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // value for non-compressed
    write_byte(8'h01); // value for non-compressed
    write_byte(8'h00); // zero padding
    write_byte(8'h00); // zero padding

    // entry five, photometric interpretation
    // starting offset: 0x0042

    write_byte(8'h01); // id
    write_byte(8'h06); // id
    write_byte(8'h00); // type is 16-bit
    write_byte(8'h03); // type is 16-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // value for rgb
    write_byte(8'h02); // value for rgb
    write_byte(8'h00); // zero padding
    write_byte(8'h00); // zero padding

    // entry six, strip offsets
    // starting offset: 0x004e

    write_byte(8'h01); // id
    write_byte(8'h11); // id
    write_byte(8'h00); // type is 32-bit
    write_byte(8'h04); // type is 32-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // pointer to image data
    write_byte(8'h00); // pointer to image data
    write_byte(8'h00); // pointer to image data
    write_byte(8'hc0); // pointer to image data

    // entry seven, samples per pixel
    // starting offset: 0x005a

    write_byte(8'h01); // id
    write_byte(8'h15); // id
    write_byte(8'h00); // type is 16-bit
    write_byte(8'h03); // type is 16-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // value for three samples
    write_byte(8'h03); // value for three samples
    write_byte(8'h00); // zero padding
    write_byte(8'h00); // zero padding

    // entry eight, rows per strip
    // starting offset: 0x0066

    write_byte(8'h01); // id
    write_byte(8'h16); // id
    write_byte(8'h00); // type is 32-bit
    write_byte(8'h04); // type is 32-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // value for rows per strip
    write_byte(8'h00); // value for rows per strip
    write_byte(ydim[15:8]); // value for rows per strip
    write_byte(ydim[ 7:0]); // value for rows per strip

    // entry nine, strip byte counts
    // starting offset: 0x0072

    write_byte(8'h01); // id
    write_byte(8'h17); // id
    write_byte(8'h00); // type is 32-bit
    write_byte(8'h04); // type is 32-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(numbytes[31:24]); // value for byte count
    write_byte(numbytes[23:16]); // value for byte count
    write_byte(numbytes[15: 8]); // value for byte count
    write_byte(numbytes[ 7: 0]); // value for byte count

    // entry ten, x-resolution
    // starting offset: 0x007e

    write_byte(8'h01); // id
    write_byte(8'h1a); // id
    write_byte(8'h00); // type is rational
    write_byte(8'h05); // type is rational
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // pointer to x-res rational
    write_byte(8'h00); // pointer to x-res rational
    write_byte(8'h00); // pointer to x-res rational
    write_byte(8'ha8); // pointer to x-res rational

    // entry eleven, y-resolution
    // starting offset: 0x008a

    write_byte(8'h01); // id
    write_byte(8'h1b); // id
    write_byte(8'h00); // type is rational
    write_byte(8'h05); // type is rational
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // pointer to y-res rational
    write_byte(8'h00); // pointer to y-res rational
    write_byte(8'h00); // pointer to y-res rational
    write_byte(8'hb0); // pointer to y-res rational

    // entry twelve, resolution unit
    // starting offset: 0x0096

    write_byte(8'h01); // id
    write_byte(8'h28); // id
    write_byte(8'h00); // type is 16-bit
    write_byte(8'h03); // type is 16-bit
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h00); // one value exists
    write_byte(8'h01); // one value exists
    write_byte(8'h00); // value for inches
    write_byte(8'h02); // value for inches
    write_byte(8'h00); // zero padding
    write_byte(8'h00); // zero padding

    // write a pointer to the next image file
    // directory, which is zero, since there
    // is no other image file directory...
    // starting offset: 0x00a2

    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);
    write_byte(8'h00);

    // write out zeroes for padding to restore
    // alignment for 32-bit values coming up...
    // starting offset: 0x00a6

    write_byte(8'h00);
    write_byte(8'h00);

    // x-resolution data in rational format
    // entry ten of the first ifd points to
    // this value since it won't fit in ifd
    // starting offset: 0x00a8

    write_byte(8'h00); // numerator 75 pixels
    write_byte(8'h00); // numerator 75 pixels
    write_byte(8'h00); // numerator 75 pixels
    write_byte(8'h4b); // numerator 75 pixels
    write_byte(8'h00); // denominator 1 resunit
    write_byte(8'h00); // denominator 1 resunit
    write_byte(8'h00); // denominator 1 resunit
    write_byte(8'h01); // denominator 1 resunit

    // y-resolution data in rational format
    // entry eleven of the first ifd points to
    // this value since it won't fit in ifd
    // starting offset: 0x00b0

    write_byte(8'h00); // numerator 75 pixels
    write_byte(8'h00); // numerator 75 pixels
    write_byte(8'h00); // numerator 75 pixels
    write_byte(8'h4b); // numerator 75 pixels
    write_byte(8'h00); // denominator 1 resunit
    write_byte(8'h00); // denominator 1 resunit
    write_byte(8'h00); // denominator 1 resunit
    write_byte(8'h01); // denominator 1 resunit

    // bits per sample information stored as
    // a triple of 16-bit values (padded with
    // an extra value to restore alignment)
    // starting offset: 0x00b8

    write_byte(8'h00); // eight bits per sample
    write_byte(8'h08); // eight bits per sample
    write_byte(8'h00); // eight bits per sample
    write_byte(8'h08); // eight bits per sample
    write_byte(8'h00); // eight bits per sample
    write_byte(8'h08); // eight bits per sample
    write_byte(8'h00); // eight bits per sample
    write_byte(8'h08); // eight bits per sample
endtask


/**
 * Internal logic
 */

always @(go) go_delayed = #1 go;

always_ff @(negedge clk) begin
    if (file_open == 1) begin
        write_byte(r); // eight bits per sample
        write_byte(g); // eight bits per sample
        write_byte(b); // eight bits per sample
    end
end

always @(posedge go_delayed) begin
    open_file(frame_number);
    write_header(xdim, ydim);
    $display("Info: tiff_writer started frame %d",frame_number);
    @(posedge go) close_file;
    $display("Info: tiff writer finished frame %d",frame_number);
    frame_number = frame_number + 1;
end

endmodule
