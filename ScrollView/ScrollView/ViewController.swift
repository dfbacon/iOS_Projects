//
//  ViewController.swift
//  ScrollView
//
//  Created by Daniel Bacon on 6/2/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var images = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // frame data NOT available in viewDidLoad()
    // must place code in viewDidAppear to access information from storyboard
    override func viewDidAppear(_ animated: Bool) {
        
        var contentWidth: CGFloat = 0.0
        let scrollWidth:CGFloat = scrollView.frame.size.width
        
        for x in 0...2 {
            // create image and put it in array
            let image = UIImage(named: "icon\(x).png")
            let imageView = UIImageView(image: image)
            images.append(imageView)
            
            var newX: CGFloat = 0.0
            
            // view.frame.midX gets value from 0.0 (top-left edge) to the midpoint of screen
            // view.frame.size.width is the entire width of the screen
            // CGFloat(x) is the index; cast as a CGFloat-type value
            //newX = view.frame.midX + view.frame.size.width * CGFloat(x)
            
            // newX now based on the size of the scrollView, not the full screen view
            newX = (scrollWidth / 2) + scrollWidth * CGFloat(x)
            
            contentWidth += newX
            
            // add new image view to subview
            scrollView.addSubview(imageView)
            
            // set image view of frame AFTER it has been added to scroll view
            // a view's coordinates are dependent on its parent
            // width and height (in this case) are set arbitrarily
            // y is offset by 75 to center the image vertically (because the height is set to 150)
            // x is offset from midpoint by 75 for same reason as y-coordinate
            // x-coordinate can also be written as `view.frame.midX - 75`
            // imageView.frame = CGRect(x: newX - 75, y: (view.frame.size.height/2) - 75, width: 150, height: 150)
            
            // image in scroll view now based on scrollView size, not full screen size
            imageView.frame = CGRect(x: newX - 75, y: (scrollView.frame.size.height / 2) - 75, width: 150, height: 150)
        }

        // allows for edge of next image to be seen on screen
        scrollView.clipsToBounds = false
        
        // scroll view can have content size > screen size
        // scroll view content size should be the same size as long as your content
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.size.height)
    }

}

