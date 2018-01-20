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
    
    var navigationView: UIView? = UIView()
    
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
        let vc = SWViewController()
        vc.view.backgroundColor = .red
        let container = AHSwipeViewControllerContainer(rootVC: vc)
        container.rightVC = SWViewController()
        self.present(container, animated: true, completion: nil)
    }
}
