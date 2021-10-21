//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by macbook on 10/13/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    let themes = [
        "Sports":"⚽🏀🏈⚾🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals":"🐶🐔🦊🐼🦀🐪🐓🐋🐙🦄🐵",
        "Faces":"😀😂😎😫😰😴🙄🧐😘😷",
    ]
    
    // Originally when split view (which works only on iPads) is displayed on iPhones,
    // it first displays detail, not the master, so delegates can
    // help turn it the other way around
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // collapsing detail
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                // if the theme was never set, then collapse
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        // Changing theme without updating the game
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle , let theme = themes[themeName] {
                cvc.theme = theme
            }
        }else if let cvc = lastSeguedToConcentrationViewController {
            // holding last thrown off view controller in the heap
            navigationController?.pushViewController(cvc, animated: true)
            if let themeName = (sender as? UIButton)?.currentTitle , let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            
                if let themeName = (sender as? UIButton)?.currentTitle , let theme = themes[themeName] { // resolving Any? type of the sender (sender as? UIButton)?
                    if let cvc = segue.destination as? ConcentrationViewController { // cvc - Concentration View Controller
                        cvc.theme = theme
                        lastSeguedToConcentrationViewController = cvc
                    }
                }
            
        }
    }
 

}
