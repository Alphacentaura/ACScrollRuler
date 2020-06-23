//
//  ACScrollRulerView.swift
//  ACScrollRuler
//
//  Created by Евгений Полянский on 23.06.2020.
//  Copyright © 2020 Евгений Полянский. All rights reserved.
//

import UIKit

fileprivate let TextRulerFont    = UIFont.systemFont(ofSize: 14)
fileprivate let RulerLineColor   = UIColor(red: 141, green: 152, blue: 165, alpha: 1)
fileprivate let RulerGap         = 12
fileprivate let RulerLong        = 7
fileprivate let RulerShort       = 1
fileprivate let TriangleWidth    = 6.86
fileprivate let TriangleHeight   = 5.87
fileprivate let CollectionHeight = 50
fileprivate let TextColorWhiteAlpha:CGFloat = 1.0

fileprivate let temperatureNormal : Float = 35.0
fileprivate let temperatureHigh : Float = 37.0

fileprivate let temperatureViewWidth = 60.0
fileprivate let temperatureViewHeight = 20.0

private let positionXInset:CGFloat = 10.0

/**************************************************************/

class ACTemperatureView: UIView {
    
    var valueDisplayViewColor:UIColor?
    var cornerRadius: CGFloat = 7.0
    override var backgroundColor: UIColor?{
        didSet {
            valueDisplayViewColor = backgroundColor!
            super.backgroundColor = UIColor.clear
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(valueDisplayViewColor!.cgColor)
        context.setStrokeColor(valueDisplayViewColor!.cgColor)
        
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        
        let background = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        background.lineWidth = 1
        background.fill()
        background.stroke()
        
    }
    
}

/**************************************************************/

class ACTriangleView: UIView {
    
    var valueDisplayViewColor:UIColor?
    override var backgroundColor: UIColor?{
        didSet {
            valueDisplayViewColor = backgroundColor!
            super.backgroundColor = UIColor.clear
        }
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.set()
        UIRectFill(self.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.beginPath()
        context!.move(to: CGPoint.init(x: 0, y: 0))
        context!.addLine(to: CGPoint.init(x: TriangleWidth, y: 0))
        context!.addLine(to: CGPoint.init(x: TriangleWidth/2, y: TriangleHeight))
        context!.setLineCap(CGLineCap.butt)
        context!.setLineJoin(CGLineJoin.bevel)
        context!.closePath()
        
        valueDisplayViewColor?.setFill()
        valueDisplayViewColor?.setStroke()
        
        context!.drawPath(using: CGPathDrawingMode.fillStroke)
    }
    
}

/**************************************************************/

class ACRulerView: UIView {
    var minValue:Float = 0.0
    var maxValue:Float = 0.0
    var unit:String = ""
    var step:Float = 0.0
    var betweenNumber = 0
    override func draw(_ rect: CGRect) {
        let startX:CGFloat  = 0
        let lineCenterX     = CGFloat(RulerGap)
        let shortLineY      = (rect.size.height - CGFloat(temperatureViewHeight) - CGFloat(TriangleHeight) ) - CGFloat(RulerShort) - 7
        let longLineY       = (rect.size.height - CGFloat(temperatureViewHeight) - CGFloat(TriangleHeight) ) - CGFloat(RulerLong) - 3.5
        
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        context?.setLineCap(CGLineCap.butt)
        context?.setStrokeColor(red: 0.553, green: 0.596, blue: 0.647, alpha: 1)
        for i in 0...betweenNumber {
            print(i)
            if i%betweenNumber == 0 {
                
                let num = Float(i)*step+minValue
                print("unit = \(unit)")
                let numStr = String(format: "%.f%@", num,"")
                print(i,step,minValue)
                let attribute:Dictionary = [NSAttributedString.Key.font:TextRulerFont,NSAttributedString.Key.foregroundColor:UIColor.black]
                
                let width = numStr.boundingRect(
                    with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                    attributes: attribute,context: nil).size.width
                
                numStr.draw(in: CGRect.init(x: startX+lineCenterX*CGFloat(i)-width/2+positionXInset, y: longLineY+CGFloat(RulerLong)+8, width: width, height: 14), withAttributes: attribute)
                
                context?.move(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i)+positionXInset, y: longLineY))
                context!.addLine(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i)+positionXInset, y: longLineY+CGFloat(RulerLong)))
                
                
            }else{
                context?.move(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i)+positionXInset, y: shortLineY))
                context!.addLine(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i)+positionXInset, y: shortLineY+CGFloat(RulerShort)))
            }
            context!.strokePath()
            
        }
        
    }
}

/**************************************************************/

class ACHeaderRulerView: UIView {
    
    var headerMinValue = 0
    var headerUnit = ""
    
    override func draw(_ rect: CGRect) {
        let longLineY = rect.size.height - CGFloat(RulerShort)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context?.setLineWidth(1.0)
        context?.setLineCap(CGLineCap.butt)
        
        context?.move(to: CGPoint.init(x: rect.size.width, y: 0))
        let numStr:NSString = NSString(format: "%d%@", headerMinValue,headerUnit)
        let attribute:Dictionary = [NSAttributedString.Key.font:TextRulerFont,NSAttributedString.Key.foregroundColor:UIColor.init(white: TextColorWhiteAlpha, alpha: 1.0)]
        let width = numStr.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        numStr.draw(in: CGRect.init(x: rect.size.width-width/2, y: longLineY+10, width: width, height: 14), withAttributes: attribute)
        context?.addLine(to: CGPoint.init(x: rect.size.width, y: longLineY))
        context?.strokePath()
        
    }
}

/**************************************************************/

class ACFooterRulerView: UIView {
    var footerMaxValue = 0
    var footerUnit = ""
    
    override func draw(_ rect: CGRect) {
        let longLineY = Int(rect.size.height) - RulerShort
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context?.setLineWidth(1.0)
        context?.setLineCap(CGLineCap.butt)
        
        context?.move(to: CGPoint.init(x: 0, y: 0))
        let numStr:NSString = NSString(format: "%d%@", footerMaxValue,footerUnit)
        
        let attribute:Dictionary = [NSAttributedString.Key.font:TextRulerFont,NSAttributedString.Key.foregroundColor:UIColor.init(white: TextColorWhiteAlpha, alpha: 1.0)]
        let width = numStr.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        numStr.draw(in: CGRect.init(x: 0-width/2, y: CGFloat(longLineY+10), width: width, height:CGFloat(14)), withAttributes: attribute)
        context?.addLine(to: CGPoint.init(x: 0, y: longLineY))
        context?.strokePath()
    }
}

/**************************************************************/

protocol ACScrollRulerDelegate:NSObjectProtocol {
    func acScrollRulerViewValueChange(rulerView:ACScrollRulerView,value:Float)
}
class ACScrollRulerView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    weak var delegate:ACScrollRulerDelegate?
    
    var bgColor:UIColor? = nil
    
    var temperatureLowColor: UIColor = #colorLiteral(red: 0.9725490196, green: 0.7294117647, blue: 0, alpha: 1)
    var temperatureNormalColor: UIColor = #colorLiteral(red: 0, green: 0.7921568627, blue: 0.6156862745, alpha: 1)
    var temperatureHighColor: UIColor = #colorLiteral(red: 0.8588235294, green: 0.2470588235, blue: 0.2470588235, alpha: 1)
    
    var stepNum = 0
    
    private var redLine:UIImageView?
    private var fileRealValue:Float = 0.0
    var rulerUnit:String = "°C"
    var minValue:Float = 0.0
    var maxValue:Float = 0.0
    var step:Float = 0.0
    var betweenNum:Int = 0
    
    var currentVC:UIViewController?
    
    class func rulerViewHeight() -> Int {
        return CollectionHeight + 100
    }
    
    init(frame: CGRect,tminValue:Float,tmaxValue:Float,tstep:Float,tunit:String,tNum:Int,viewcontroller:UIViewController) {
        super.init(frame: frame)
        minValue    = tminValue
        maxValue    = tmaxValue
        betweenNum  = tNum
        step        = tstep
        stepNum     = Int((tmaxValue - tminValue)/step)/betweenNum
        rulerUnit   = tunit
        bgColor     = UIColor.white
        currentVC   = viewcontroller
        
        lazyTemperatureView.frame = CGRect.init(x: Double(self.bounds.size.width/2 - CGFloat(temperatureViewWidth/2 - 0.5)), y: Double(self.bounds.minY), width: temperatureViewWidth, height: temperatureViewHeight)
        self.addSubview(self.lazyTemperatureView)
        lazyTemperatureView.valueDisplayViewColor = temperatureNormalColor
        
        lazyTriangle.frame = CGRect.init(x: lazyTemperatureView.frame.width/2-0.5 - CGFloat(TriangleWidth)/2, y: lazyTemperatureView.frame.maxY-1, width: CGFloat(TriangleWidth), height: CGFloat(TriangleWidth))
        lazyTemperatureView.addSubview(self.lazyTriangle)
        self.lazyTriangle.valueDisplayViewColor = temperatureNormalColor
        
        lazyValueLabel.frame = CGRect.init(x: 0, y: 0, width: 60, height: 20)
        lazyTemperatureView.addSubview(self.lazyValueLabel)
        
        self.addSubview(self.lazyCollectionView)
        
        self.lazyCollectionView.frame = CGRect.init(x: 0, y:self.lazyValueLabel.frame.maxY, width: self.bounds.size.width, height: CGFloat(CollectionHeight))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lazyValueLabel: UILabel = {[unowned self] in
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = NSTextAlignment.center
        
        return valueLabel
        }()
    
    lazy var lazyCollectionView: UICollectionView = {[unowned self]in
        
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.scrollDirection  = UICollectionView.ScrollDirection.horizontal
        flowLayout.sectionInset     = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        let zyCollectionView:UICollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: CGFloat(CollectionHeight)), collectionViewLayout: flowLayout)
        zyCollectionView.backgroundColor    = UIColor.clear
        zyCollectionView.bounces            = true
        zyCollectionView.showsHorizontalScrollIndicator = false
        zyCollectionView.showsVerticalScrollIndicator   = false
        zyCollectionView.delegate   = self
        zyCollectionView.dataSource = self
        zyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "headCell")
        zyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "footerCell")
        zyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "customeCell")
        
        return zyCollectionView
        }()
    
    lazy var lazyTriangle: ACTriangleView = {
        let triangleView = ACTriangleView()
        triangleView.backgroundColor = UIColor.clear
        triangleView.valueDisplayViewColor = temperatureNormalColor
        return triangleView
    }()
    
    lazy var lazyTemperatureView: ACTemperatureView = {
        let temperatureView = ACTemperatureView()
        temperatureView.backgroundColor = UIColor.clear
        temperatureView.valueDisplayViewColor = temperatureNormalColor
        return temperatureView
    }()
    
//    @objc fileprivate func didChangeCollectionValue() {
//        let textFieldValue = Float(lazyValueLabel.text!)
//        if (textFieldValue!-minValue)>=0 {
//            self.setRealValueAndAnimated(realValue: (textFieldValue!-minValue)/step, animated: true)
//        }
//    }
    
    @objc fileprivate func setRealValueAndAnimated(realValue:Float,animated:Bool){
        fileRealValue       = realValue
        lazyValueLabel.text    = String.init(format: "%.1f", fileRealValue*step+minValue)+rulerUnit
        lazyCollectionView.setContentOffset(CGPoint.init(x: Int(realValue)*RulerGap, y: 0), animated: animated)
    }
    
    func setDefaultValueAndAnimated(defaultValue:Float,animated:Bool){
        fileRealValue = defaultValue
        lazyValueLabel.text = String.init(format: "%.1f", defaultValue)+rulerUnit
        lazyCollectionView.setContentOffset(CGPoint.init(x: Int((defaultValue-minValue)/step) * RulerGap, y: 0), animated: animated)
    }
    
    func judgeTextsHasWord(texts:String) -> Bool{
        let scan:Scanner = Scanner.init(string: texts)
        var value:Float = 0.0
        return scan.scanFloat(&value) && scan.isAtEnd
    }
}

extension ACScrollRulerView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2+stepNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell:UICollectionViewCell       = collectionView.dequeueReusableCell(withReuseIdentifier: "headCell", for: indexPath)
            var headerView:ACHeaderRulerView?   = cell.contentView.viewWithTag(1000) as?ACHeaderRulerView
            
            if headerView == nil{
                headerView = ACHeaderRulerView.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.frame.size.width/2), height: CollectionHeight))
                headerView!.backgroundColor  = UIColor.clear
                headerView!.headerMinValue   = Int(minValue)
                headerView!.headerUnit       = rulerUnit
                headerView!.tag              = 1000
                cell.contentView.addSubview(headerView!)
            }
            return cell
        }else if indexPath.item == stepNum+1 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "footerCell", for: indexPath)
            var footerView:ACFooterRulerView? = cell.contentView.viewWithTag(1001) as? ACFooterRulerView
            if footerView == nil {
                footerView = ACFooterRulerView.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.frame.size.width/2), height: CollectionHeight))
                footerView!.backgroundColor  = UIColor.clear
                footerView!.footerMaxValue   = Int(maxValue)
                footerView!.footerUnit       = rulerUnit
                footerView!.tag              = 1001
                cell.contentView.addSubview(footerView!)
            }
            return cell
        }else{
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customeCell", for: indexPath)
            var rulerView:ACRulerView? = cell.contentView.viewWithTag(1002) as? ACRulerView
            if rulerView == nil {
                rulerView = ACRulerView.init(frame: CGRect.init(x: 0, y: 0, width: RulerGap*betweenNum+Int(positionXInset)*2, height: CollectionHeight))
                rulerView!.backgroundColor   = UIColor.clear
                rulerView!.step              = step
                rulerView!.unit              = rulerUnit
                rulerView!.tag               = 1002
                rulerView!.betweenNumber     = betweenNum;
                cell.contentView.addSubview(rulerView!)
            }
            
            rulerView?.backgroundColor = UIColor.clear
            /* if need to color the ruler */
            //            if indexPath.item >= 8 && indexPath.item <= 12{
            //                rulerView?.backgroundColor = UIColor.green
            //            }else if(indexPath.item >= 13 && indexPath.item <= 18){
            //                rulerView?.backgroundColor = UIColor.red
            //            }else{
            //                rulerView?.backgroundColor = UIColor.gray
            //            }
            
            rulerView!.minValue = step*Float((indexPath.item-1))*Float(betweenNum)+minValue
            rulerView!.maxValue = step*Float(indexPath.item)*Float(betweenNum)
            rulerView!.setNeedsDisplay()
            
            return cell
        }
        
    }
    
    
}
extension ACScrollRulerView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x)/RulerGap
        var totalValue = Float(value)*step+minValue
        
        if totalValue>=maxValue {
            totalValue = maxValue
        }else if totalValue <= minValue {
            totalValue = minValue
        }
        
        colorTemperatureView(totalValue)
        
        lazyValueLabel.text = String.init(format: "%.1f", totalValue)
        lazyValueLabel.text! += rulerUnit
        
        delegate?.acScrollRulerViewValueChange(rulerView: self, value: totalValue)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.setRealValueAndAnimated(realValue: Float(scrollView.contentOffset.x)/Float(RulerGap), animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setRealValueAndAnimated(realValue: Float(scrollView.contentOffset.x)/Float(RulerGap), animated: true)
    }
    
    func colorTemperatureView(_ value:Float) {
        if value <= temperatureNormal {
            self.lazyTemperatureView.backgroundColor = temperatureLowColor
            self.lazyTriangle.backgroundColor = temperatureLowColor
        } else if value > temperatureNormal && value <= temperatureHigh {
            self.lazyTemperatureView.backgroundColor = temperatureNormalColor
            self.lazyTriangle.backgroundColor = temperatureNormalColor
        } else {
            self.lazyTemperatureView.backgroundColor = temperatureHighColor
            self.lazyTriangle.backgroundColor = temperatureHighColor
        }
    }
}
extension ACScrollRulerView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == stepNum + 1 {
            return CGSize(width: Int(self.frame.size.width/2), height: CollectionHeight)
        }
        return CGSize(width: RulerGap*betweenNum, height: CollectionHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: -positionXInset, bottom: 0, right: positionXInset)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
