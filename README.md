# ImageToPointwise
Glyph script imports images into Pointwise and renders the RGB data using either points or coons patches.

![ScriptImage](https://raw.github.com/traviscarrigan/ImageToPointwise/master/results/sample-result.png)

## Obtaining RGB Data
Before running the script, RGB data must be obtained from an image. Using the PNM, Netpbm superformat, RGB data can be recovered from an image. The following command was used to generate the sample.rgb data in the rgb/ directory. The original image can be found in the images/ directory. 

    pngtopnm -plain sample.png > sample.rgb

## Usage
To run the script, simply specify the path of the image in the script, as well as whether points or cells should be used to render each pixel. Cells take much longer to generate than points because of the way they are constructed. 
