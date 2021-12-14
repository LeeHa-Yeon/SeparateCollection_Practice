//
//  CameraViewController.swift
//  SeparateCollection-Practice
//
//  Created by 이하연 on 2021/12/14.
//

import UIKit
import AVFoundation
import Photos
import SnapKit
import Then

class CameraViewController: UIViewController {
    
    // MARK: - Declaration & Definitions
    
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    // 비디오 프로세싱이 일어날 별도의 큐를 생성
    let sessionQueue = DispatchQueue(label: "session Queue")
    // 디바이스를 찾는 것을 도와줄 객체 생성
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInDualWideCamera, .builtInTrueDepthCamera], mediaType: .video, position: .back)
    
    // MARK: - Components
    
    private lazy var photoLibraryButton = UIButton().then {
        $0.setTitle("사진첩", for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        $0.layer.borderWidth = 1
    }
    private var previewView: PreviewView!
    private lazy var captureButton = UIButton().then {
        $0.setTitle("캡쳐", for: .normal)
        $0.layer.cornerRadius = $0.bounds.height / 2
        $0.layer.masksToBounds = true
    }
    private var blurBGView: UIVisualEffectView!
    private lazy var switchButton = UIButton().then {
        $0.setTitle("전환", for: .normal)
        $0.layer.cornerRadius = $0.bounds.height / 2
        $0.layer.masksToBounds = true
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
        setUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Functions
    
    func setInit(){
        previewView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
    }
    
    func setUI(){
        //TODO: - 레이아웃 잡기
    }
}

extension CameraViewController {
    func setupSession(){
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        // 구성하는 코드 부분
        
        // - ADD Video Input
        guard let camera = videoDeviceDiscoverySession.devices.first else {
            captureSession.commitConfiguration()
            return
        }
        do{
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            // 넣기 전에 DeviceInput을 session에 넣을 수 있는지 물어봐야한다.
            if captureSession.canAddInput(videoDeviceInput){
                // 넣을 수 있다면 그제서야 addInput을 진행
                captureSession.addInput(videoDeviceInput)
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch let error {
            print("ADD Video Input error->\(error)")
            captureSession.commitConfiguration()
            return
        }
        
        // - ADD photo Output : 사진을 찍어서 저장할테니까
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
    }
    
    func startSession(){
        // 메인 스레드가 아닌 특정 스레드에서 이 작업을 수행할 거임
        sessionQueue.async {
            // captureSession이 실행중이 아닐 때 실행시키라고 하기
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
        
    }
    
    func stopSession(){
        sessionQueue.async {
            // captureSession이 멈춰있지 않을 때 ( 즉, 실행중일 때 ) 멈추게 하기
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
}


extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        <#code#>
    }
}
