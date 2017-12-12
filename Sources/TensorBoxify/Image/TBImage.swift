//
//  TBImage.swift
//  TensorBoxify/Image
//
//  Created by Dan Hushon on 12/7/17.
//
import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

class TBImage {
    
    init?(url: URL) {
        var gdata: Data = String("abcd").data(using: String.Encoding.utf8)!
        let data = NSData(bytes: &gdata, length: gdata.count) as CFData
        debugPrint(data)

        //let data: CFData = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, <#T##bytes: UnsafePointer<UInt8>!##UnsafePointer<UInt8>!#>, <#T##length: CFIndex##CFIndex#>, <#T##bytesDeallocator: CFAllocator!##CFAllocator!#>)
    }
    
}

extension CGImage {
    
}

/*extension UIImage {
    func pixelData() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
}*/
