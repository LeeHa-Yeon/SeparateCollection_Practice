//
//  CameraViewController.swift
//  SeparateCollection-Practice
//
//  Created by 이하연 on 2021/12/14.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    // MARK: - Declaration & Definitions
    
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    // 비디오 프로세싱이 일어날 별도의 큐를 생성
    let sessionQueue = DispatchQueue(label: "session Queue")
    // 디바이스를 찾는 것을 도와줄 객체 생성
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInDualWideCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
}
