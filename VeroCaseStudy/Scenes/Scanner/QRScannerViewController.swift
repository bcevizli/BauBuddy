//
//  QRScannerViewController.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 1.04.2023.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // AVCapture variables
    private var captureSession: AVCaptureSession?
    private var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    
    private var qrString: String = "" {
        didSet {
            showToast(message: qrString, font: UIFont.systemFont(ofSize: 16))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
        setupPreviewLayer()
        setupQRCodeFrameView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop capturing data when view disappears
        captureSession?.stopRunning()
    }

    private func setupCaptureSession() {
        // Create capture session
        captureSession = AVCaptureSession()

        // Set up default capture device
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No video device found")
        }

        // Create capture input from default device
        guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            fatalError("Unable to create input from capture device")
        }

        // Add capture input to session
        if captureSession?.canAddInput(captureInput) == true {
            captureSession?.addInput(captureInput)
        }

        // Create metadata output and add to session
        let captureOutput = AVCaptureMetadataOutput()
        if captureSession?.canAddOutput(captureOutput) == true {
            captureSession?.addOutput(captureOutput)
        }

        // Set metadata output delegate and types
        captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureOutput.metadataObjectTypes = [.qr]
    }

    private func setupPreviewLayer() {
        // Create preview layer and add to view
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(capturePreviewLayer!)

        // Start capturing data
        captureSession?.startRunning()
    }

    private func setupQRCodeFrameView() {
        // Create bounding box view for detected QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }

    // AVCaptureMetadataOutputObjectsDelegate method
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadata object is a QR code
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, metadataObject.type == .qr, let stringValue = metadataObject.stringValue else {
                qrCodeFrameView?.frame = .zero
                return
            }

            // Draw bounding box around detected QR code
            let transformedRect = capturePreviewLayer?.transformedMetadataObject(for: metadataObject)?.bounds ?? .zero
            let convertedRect = capturePreviewLayer?.layerRectConverted(fromMetadataOutputRect: transformedRect) ?? .zero
            qrCodeFrameView?.frame = convertedRect

            // Do something with the scanned string value
            print("Scanned QR code with value: \(stringValue)")
        self.qrString = stringValue
        }

}
