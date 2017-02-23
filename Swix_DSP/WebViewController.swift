//
//  WebViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 23/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIPageViewController, WKNavigationDelegate {
    
    var webView : WKWebView!
    
    var button: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // loading URL :
        let myBlog = "https://en.wikipedia.org/wiki/Batman"
        let url = URL(string: myBlog)
        let request = URLRequest(url: url!)
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        
        button = UIButton(frame: CGRect(x: self.view.frame.size.width-30, y: 10, width: 20, height: 20))
        button.setImage(UIImage(named: "close-button_black"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.add(button)
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
