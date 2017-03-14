//
//  ViewController.swift
//  SwiftPlayer
//
//

import UIKit
import RxSwift
import youtube_ios_player_helper

class TrackTableViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var tracks = [Track]()
    
    var progressHUDfetch = ProgressHUD(text: "Fetching Data")
    var progressHUDplayer = ProgressHUD(text: "Loading Video")
    
    let playerView = YTPlayerView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(progressHUDfetch)
        progressHUDfetch.hide()
        self.view.addSubview(progressHUDplayer)
        progressHUDplayer.hide()
        
        playerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func reloadData(){
        progressHUDfetch.show()
        
        let uri = "http://pastebin.com/raw/Rw6R9D2f"
        Requests.videos(uri)
            .subscribe(onNext: { tracks in
                    self.tracks.removeAll()
                    self.tracks.append(contentsOf: tracks)
                    self.tableView.reloadData()
                    self.progressHUDfetch.hide()
                },
                onError: { error in
                    self.progressHUDfetch.hide()
                    self.showAlertViewController("Failed to connect", buttonMessage: "Retry?"){ action in
                        print("Reloading data")
                        self.reloadData()
                    }
                })
        .addDisposableTo(self.disposeBag)
    }
}

// TableView
extension TrackTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "TrackTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TrackTableViewCell
        
        let targetTrack = tracks[indexPath.row]
        if let url = URL(string: targetTrack.imageUri),
            let data = try? Data(contentsOf: url){
                cell.trackCover.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let track: Track = tracks[indexPath.row]
            
            else {
            fatalError("Could not find track object")
        }
        
        self.progressHUDplayer.show()
        self.tableView.allowsSelection = false
        let videoUriArr = track.videoUri.components(separatedBy: "=")
        let videoId = videoUriArr[1]
        
        playerView.load(withVideoId: videoId)
    }
}

//YTPlayer
extension TrackTableViewController: YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.progressHUDplayer.hide()
        self.tableView.allowsSelection = true
        
        playerView.playVideo()
    }
}
