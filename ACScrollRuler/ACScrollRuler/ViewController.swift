//
//  ViewController.swift
//  ACScrollRuler
//
//  Created by Евгений Полянский on 23.06.2020.
//  Copyright © 2020 Евгений Полянский. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {

    lazy var lazyTimeRullerView:ACScrollRulerView = { [unowned self] in
        let unitStr = "°C"
        let rulersHeight = ACScrollRulerView.rulerViewHeight
        var timerView = ACScrollRulerView.init(frame: CGRect.init(x: 0, y: Int(ScreenHeight/5*2), width: Int(ScreenWidth), height: rulersHeight()), tminValue: 26, tmaxValue: 42, tstep: 0.1, tunit: unitStr, tNum: 10, viewcontroller:self)
        timerView.setDefaultValueAndAnimated(defaultValue: 36.6, animated: true)
        timerView.bgColor       = UIColor.white
        timerView.delegate      = self
        return timerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(lazyTimeRullerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
extension ViewController:ACScrollRulerDelegate {
    func acScrollRulerViewValueChange(rulerView: ACScrollRulerView, value: Float) {
        print("-------》"+"\(value)")
    }
}

