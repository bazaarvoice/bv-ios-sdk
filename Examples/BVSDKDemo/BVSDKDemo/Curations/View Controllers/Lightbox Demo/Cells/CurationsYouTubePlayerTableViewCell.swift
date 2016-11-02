//
//  CurationsYouTubePlayerTableViewCell.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import youtube_ios_player_helper

class CurationsYouTubePlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rightChevronImageView: UIImageView!
    
    @IBOutlet weak var leftChevronImageView: UIImageView!
    
    @IBOutlet weak var playerView: YTPlayerView!
   
    var video : BVCurationsVideo! {
        
        didSet {
            
            let playerVars =  ["playsinline": true, "controls": false, "showinfo": true, "modestbraning": true, "autohide": true ]
            
            self.playerView.load(withVideoId: self.video.token, playerVars: playerVars)
            
        }
        
    }
    
    var hasNext : Bool! {
        
        didSet {
            self.rightChevronImageView.isHidden = !self.hasNext!
        }
        
    }
    var hasPrev : Bool! {
        
        didSet {
            self.leftChevronImageView.isHidden = !self.hasPrev!
        }
        
    }

    
    
}
