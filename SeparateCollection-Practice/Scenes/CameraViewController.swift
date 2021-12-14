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
        let image = #imageLiteral(resourceName: "ic_photo_camera")
        $0.setImage(image, for: .normal)
        $0.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        $0.layer.borderWidth = 1
    }
    let previewView =  PreviewView().then {
        $0.backgroundColor = .gray
    }
    private lazy var captureButton = UIButton().then {
        let image = #imageLiteral(resourceName: "cameraBtn")
        $0.setImage(image, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        $0.layer.cornerRadius = 33
        $0.layer.masksToBounds = true
    }
//    private var blurBGView: UIVisualEffectView!
    private lazy var switchButton = UIButton().then {
        let image = #imageLiteral(resourceName: "cameraSwitch_front")
        $0.setImage(image, for: .normal)
        $0.layer.cornerRadius = $0.bounds.height / 2
        $0.layer.masksToBounds = true
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setInit()
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
        view.addSubview(previewView)
//        view.addSubview(blurBGView)
        view.addSubview(captureButton)
        view.addSubview(switchButton)
        view.addSubview(photoLibraryButton)
        
        previewView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        switchButton.snp.makeConstraints{
            $0.width.height.equalTo(45)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
//        blurBGView.snp.makeConstraints{
//            $0.width.height.equalTo(captureButton.snp.width).offset(20.0)
//        }
        captureButton.snp.makeConstraints{
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.width.height.equalTo(65)
        }
        photoLibraryButton.snp.makeConstraints{
            $0.centerY.equalTo(captureButton)
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(captureButton.snp.leading).offset(-50)
        }
    
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
        print("추후에 작성")
    }
}
