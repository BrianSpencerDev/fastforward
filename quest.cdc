pub struct Canvas {
    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }
}

pub resource Picture {
    pub let canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
    }
}

pub fun serializeStringArray(_ lines: [String]): String {
    var buffer = ""
    for line in lines {
        buffer = buffer.concat(line)
    }

    return buffer
}

pub fun unserializeStringToArray(_ str: String, height: UInt8, width: UInt8): [String] {
    var stringArr: [String] = []

    var i: UInt8 = 0
    while i < height {
        stringArr.append(str.slice(from: Int(i * width), upTo: Int((i+1) * width)))

        log(stringArr[i])
        i = i + 1
    } 

    
    return stringArr   
}

pub fun display(canvas: Canvas) {
    let pixelArr = unserializeStringToArray(canvas.pixels, height: canvas.height, width: canvas.width)


    for line in pixelArr {
        log(line)
    }
}

pub fun addBorder(to canvas: Canvas): Canvas {
    //revert pixels back to string array
    var pixelArr = unserializeStringToArray(canvas.pixels, height: canvas.height, width: canvas.width)
    
    //add vertical border
    pixelArr = createVerticalBorder(for: pixelArr)
    //add horizontal border
    pixelArr = createHorizontalBorder(for: pixelArr)

    let borderCanvas = Canvas(
        width: canvas.width + 2,
        height: canvas.height + 2,
        pixels: serializeStringArray(pixelArr)
    )

    return borderCanvas
}

pub fun createHorizontalBorder(for pixelArr: [String]): [String] {
    var frameBorder = ""
    let corner = "+"
    let edge = "-"

    frameBorder = frameBorder.concat(corner);

    //add edge characters to frameborder
    var i = 0
    while i < pixelArr[0].length - 2 {
        frameBorder = frameBorder.concat(edge)

        i = i + 1
    }

    frameBorder = frameBorder.concat(corner)

    //add border to top and bottom of canvas

    //top
    pixelArr.insert(at: 0, frameBorder)
    //bottom
    pixelArr.append(frameBorder)

    return pixelArr
}

pub fun createVerticalBorder(for pixelArr: [String]): [String] {
    var borderedStringArr: [String] = []
    let edge = "|"

    

    //add edge to edges of each row in pixel array
    var i = 0;
    while i < pixelArr.length {
        var borderString = ""
        borderString = borderString.concat(edge)            // edge
        borderString = borderString.concat(pixelArr[i])     // pixel row string
        borderString = borderString.concat(edge)            // edge

        borderedStringArr.append(borderString)              
        i = i + 1
    }   

    return borderedStringArr
}

pub fun main() {
    let pixelsX = [
        "*   *",
        " * * ",
        "  *  ",
        " * * ",
        "*   *"
    ]

    let canvasX = Canvas(
        width: 5,
        height: 5,
        pixels: serializeStringArray(pixelsX)
    )

    let letterX <- create Picture(canvas: canvasX)
    log(letterX.canvas)
    destroy letterX


    let framedX = addBorder(to: canvasX)
    display(canvas: framedX)
}