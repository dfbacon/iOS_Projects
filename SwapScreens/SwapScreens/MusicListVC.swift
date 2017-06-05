//
//  MusicListVC.swift
//  SwapScreens
//
//  Created by Daniel Bacon on 6/5/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class MusicListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func LoadThirdScreenPressed(_ sender: Any) {
        
        let songTitle = "Moonlight Sonata"
        
        // PlaySong is the name of the identifier. Lets the code know which segue to show.
        // sender is the object passed to the view controller
        performSegue(withIdentifier: "PlaySong", sender: songTitle)
    }
    
    // prepareForSegue is called BEFORE ViewDidLoad() of the destination VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // segue.destination is the call to the segue destination
        if let destination = segue.destination as? PlaySongVC {

            if let song = sender as? String {
                // destination."" allows for functions from the destination to be called.
                destination.selectedSong = song
            }
        }
    }
}
