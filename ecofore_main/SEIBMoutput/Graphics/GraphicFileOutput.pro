;The following lines create an image in an IDL graphics window, read it from the window and write it 
;as a TrueColor .jpg file in the temporary directory, then read the .jpg file and display it in the same graphics window:

; Save device settings and tell IDL to use a color table
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
LOADCT, 14

; Create an image and display it
IMAGE1 = DIST(300)
WINDOW, 1, XSIZE=300, YSIZE=300
TV, IMAGE1

; Write a bitmap file to the temporary directory
; Note the use of the TRUE keywords to TVRD and WRITE_JPEG
filename = FILEPATH('test.jpg', /TMP)
WRITE_JPEG, filename, TVRD(/TRUE), /TRUE
PRINT, 'File written to ', filename

; Read in the file
; Note the use of the TRUE keyword to READ_JPEG
READ_JPEG, filename, IMAGE2, /TRUE

; Display the IMAGE1 and IMAGE2 side by side
; Note the use of the TRUE keyword to TV
WINDOW, 1, XSIZE=600, YSIZE=300, $
TITLE='Original (left) and Image read from file (right)'
TV, IMAGE1, 0
TV, IMAGE2, 1, /TRUE

; Restore device settings.
DEVICE, DECOMPOSED=old_decomposed

END