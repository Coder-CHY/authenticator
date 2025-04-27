//
//  ScanQRCodeView.swift
//  Google Authenticator
//
//

import SwiftUI
import VisionKit
import AVFoundation

struct ScanQRCodeView: View {
    @State var scanResult = "No QR code detected"
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                QRScanner()
                
                Text(scanResult)
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color("side_menu_background"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        //dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .tint(.white)
                    })
                }
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        //dismiss()
                    }, label: {
                        Text("Scan code")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //dismiss()
                    }, label: {
                        Image(systemName: "bolt.slash.circle.fill")
                            .font(.system(size: 20))
                            .tint(.white)
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.primary.opacity(0.93))
        }
    }
}

#Preview {
    ScanQRCodeView()
}

struct QRScanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> QRScannerController {
        let controller = QRScannerController()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {
    }
}

class QRScannerController: UIViewController {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var delegate: AVCaptureMetadataOutputObjectsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Set the input device on the capture session.
        captureSession.addInput(videoInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [ .qr ]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
    }
    
}
