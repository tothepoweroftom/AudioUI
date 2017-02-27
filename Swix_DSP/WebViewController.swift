//
//  WebViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 23/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView : WKWebView!
    
    var button: UIButton!
    var upbutton: UIButton!
    var dnbutton: UIButton!

    var scroll: UIScrollView!
    var yPos: CGFloat = 0.0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        
        // loading URL :
        let myBlog = "https://en.wikipedia.org/wiki/Batman"
        let url = URL(string: myBlog)
        let request = URLRequest(url: url!)
        
        webView = WKWebView(frame: CGRect(x: 50, y: 0, width: self.view.frame.height, height: self.view.frame.width))
        webView.navigationDelegate = self
        webView.load(request)
        self.view = webView
//        self.view.sendSubview(toBack: webView)
        
        button = UIButton(frame: CGRect(x: self.view.frame.size.width-30, y: 10, width: 20, height: 20))
        button.setImage(UIImage(named: "close-button_black"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.add(button)
//
        upbutton = UIButton(frame: CGRect(x: 30, y: view.frame.height-50, width: 40, height: 20))
        upbutton.setTitle("UP", for: .normal)
        upbutton.tintColor = UIColor.black
        upbutton.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(upbutton)
        view.bringToFront(upbutton)

        
        upbutton.addTarget(self, action: #selector(scrollUp), for: .touchUpInside)
        
        dnbutton = UIButton(frame: CGRect(x: view.frame.width-50, y: view.frame.height-50, width: 40, height: 20))
        dnbutton.setTitle("DN", for: .normal)
        dnbutton.setTitleColor(UIColor.black, for: .normal)
        dnbutton.tintColor = UIColor.black
        
        dnbutton.addTarget(self, action: #selector(scrollDown), for: .touchUpInside)


        view.add(dnbutton)
        view.bringToFront(dnbutton)

        
        scroll = webView.scrollView
        yPos = scroll.frame.maxY
        
        webView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))

        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView(){
        
        self.dismiss(animated: true, completion: { [unowned self] in
            print("Dismissed")
        })
    }
    
    func scrollUp() {
        yPos += CGFloat(500.0)
        let poin = CGPoint(x: CGFloat(0), y: yPos)
        scroll.setContentOffset(poin, animated: true)

        
    }
    
    func scrollDown(){
        yPos -= CGFloat(500.0)
        let poin = CGPoint(x: CGFloat(0), y: yPos)
        scroll.setContentOffset(poin, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
