# ACScrollRuler

- Easy-to-use temperature slider, written with swift
- The basis was taken from: https://github.com/DanielYK/SwiftRulerView

 ![image](https://github.com/Alphacentaura/ACScrollRuler/blob/master/tempLow.png)
  
 ![image](https://github.com/Alphacentaura/ACScrollRuler/blob/master/tempNormal.png)
    
 ![image](https://github.com/Alphacentaura/ACScrollRuler/blob/master/tempHigh.png)

* Instructions

<pre><code>

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
        self.view.addSubview(lazyTimeRullerView)
    }
    
</code></pre>

* Callback generates while sliding

<pre><code>
extension ViewController:ACScrollRulerDelegate {
    func acScrollRulerViewValueChange(rulerView: ACScrollRulerView, value: Float) {
        print("-------》"+"\(value)")
    }
}
</code></pre>
