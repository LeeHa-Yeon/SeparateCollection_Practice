//
//  LodingViewController.swift
//  SeparateCollection-Practice
//
//  Created by 이하연 on 2021/12/14.
//

import UIKit
import Lottie
import Then



class LodingViewController: UIViewController {

    lazy var animationView = AnimationView(name:"trash1").then {
        $0.frame = CGRect(x:0, y:0, width: 200, height: 200)
        $0.center = self.view.center
        $0.contentMode = .scaleAspectFit
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimationView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAnimationView()
    }
    
    //MARK: - Functions
    
    func setAnimationView(){
        self.view.addSubview(animationView)
    }
    
    func playAnimationView(){
        self.animationView.play()
        self.animationView.loopMode = .loop
        let time = DispatchTime.now() + .seconds(4)
        DispatchQueue.main.asyncAfter(deadline: time) {
            let cameraVC = CameraViewController()
            cameraVC.modalPresentationStyle = .fullScreen
            self.present(cameraVC,animated: true,completion: nil)
        }
    }


}

