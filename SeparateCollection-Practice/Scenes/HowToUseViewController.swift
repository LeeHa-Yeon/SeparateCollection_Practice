//
//  HowToUseViewController.swift
//  SeparateCollection-Practice
//
//  Created by 이하연 on 2021/12/15.
//

// 나중에 paging으로 처리하기
import UIKit
import SnapKit
import Then

class HowToUseViewController: UIViewController {
    
    private lazy var backBtn = UIButton().then {
//        let image = #imageLiteral(resourceName: "xBtn")
//        $0.setImage(image, for: .normal)
        $0.setTitle("미구현", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(xBtnPressed(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI(){
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.width.equalTo(50)
        }
    }

    // xBtnPressed
    @objc func xBtnPressed(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
