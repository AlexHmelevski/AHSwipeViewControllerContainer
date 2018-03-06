//
//  ViewController.swift
//  AHSwipeViewControllerContainer
//
//  Created by AlexHmelevskiAG on 01/19/2018.
//  Copyright (c) 2018 AlexHmelevskiAG. All rights reserved.
//

import UIKit
import AHSwipeViewControllerContainer

class SWViewController: UIViewController, AnimatedViewController {
    var backgroundView: UIView? = UIView()
    
    var navigationView: UIView?  {
        return btn
    }
    var didTapClosure: ( ()->Void )?
    var btn = UIButton(type: .infoDark)
    var alonsideAppearingAnimation: AnimationBlock? {
        return {
            self.navigationView?.alpha = 1
            self.backgroundView?.alpha = 1
        }
    }
    
    var alonsideDisappearingAnimation: AnimationBlock? {
        return {
            self.navigationView?.alpha = 0
            self.backgroundView?.alpha = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView?.backgroundColor = .yellow
        backgroundView?.backgroundColor = .yellow
        navigationView?.alpha = 0
        backgroundView?.alpha = 0
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc func didTap() {
        didTapClosure?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


class RootViewController: UIViewController, AnimatedViewController {
    var backgroundView: UIView? = UIView()
    
    var navigationView: UIView? = UIButton(type: .infoDark)
    
    var alonsideAppearingAnimation: AnimationBlock? {
        return {
            self.navigationView?.alpha = 1
            self.backgroundView?.alpha = 1
        }
    }
    
    var alonsideDisappearingAnimation: AnimationBlock? {
        return {
            self.navigationView?.alpha = 0
            self.backgroundView?.alpha = 0
        }
    }
    
    var didTapClosure: ( ()->Void )?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView?.backgroundColor = .yellow
        backgroundView?.backgroundColor = .yellow
        navigationView?.alpha = 0
        backgroundView?.alpha = 0
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
    }
    

}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = RootViewController()
        vc.view.backgroundColor = .red
        let container = AHSwipeViewControllerContainer(rootVC: vc)
        vc.didTapClosure = {
            container.chande(to: .root)
        }
        let upVC = SWViewController()
        
        upVC.didTapClosure = {
           container.chande(to: .root)
        }
        
        container.upperVC = upVC
        
        
        let btVC = SWViewController()
        
        btVC.didTapClosure = {
            container.chande(to: .root)
        }
        
        container.bottomVC = btVC
        
        let lVC = SWViewController()
        
        lVC.didTapClosure = {
            container.chande(to: .root)
        }
        
        container.leftVC = lVC
        
        let rVC = SWViewController()
        
        rVC.didTapClosure = {
            container.chande(to: .root)
        }
       
        container.rightVC = rVC
        self.present(container, animated: true, completion: nil)
    }
}
