//
//  LoaderView.swift
//  DemoChat
//
//  Created by Enterprise Mobility on 21/11/17.
//  Copyright © 2017 RIL. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    var arrayView : [UIView]!
    var isAnimating = false
    var currentViewIndex = 0
    var currentColorIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
         self.setView()
        
    }
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
 
        self.setView()
       
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setView()
    }
    func setView() {
        self.isAnimating = false
        self.currentColorIndex = 0
        self.currentViewIndex = 0
        view1 = self.viewWithTag(100)!
        view2 = self.viewWithTag(101)!
        view3 = self.viewWithTag(102)!
        view1.translatesAutoresizingMaskIntoConstraints = true
        view2.translatesAutoresizingMaskIntoConstraints = true
        view3.translatesAutoresizingMaskIntoConstraints = true
        self.arrayView = [view1,view2,view3]
        view1.layer.cornerRadius = 13.5/2
        view2.layer.cornerRadius = 13.5/2
        view3.layer.cornerRadius = 13.5/2
        self.layer.cornerRadius = 12.0
      
        
        beginAnimation()
    }
    
    func beginAnimation()  {
       
        isAnimating = true
        startAnimation()
    }
    

    func startAnimation()  {
        isAnimating = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            if self.arrayView.count > 0
            {
              let view = self.arrayView[self.currentViewIndex]
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                view.backgroundColor = .black
            }
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations:  {
                if self.arrayView.count > 0
                {
                    let view = self.arrayView[self.currentViewIndex]
                    view.transform = .identity
                    view.backgroundColor = .white
                }
            }, completion: { (finished) in
                self.currentViewIndex += 1
                if (self.currentViewIndex < self.arrayView.count) {
                    self.startAnimation()
                }
                else
                {
                    self.currentViewIndex = 0;
                    self.startNextLevelAnimation()
                }

            })
        
        }
 

    }
 
    
    func startNextLevelAnimation()  {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            for view in self.arrayView {
                
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
            }
            
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                for view in self.arrayView {
                    
                    view.transform = .identity;
                }
                
            }, completion: { (finished) in
                
                    
                    if (self.isAnimating) {
                        self.currentViewIndex = 0;
                        self.startAnimation()
                    }
                    else
                    {
                        self.isAnimating = false
                        self.currentViewIndex = 0;
                        for view in self.arrayView {
                            
                            view.backgroundColor = .white
                            view.transform = .identity;
                        }
                    }
                
            })
        }
        

    }

 
    /*// Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
