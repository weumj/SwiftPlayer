//
//  Requests.swift
//  SwiftPlayer
//
//
import RxSwift
import RxAlamofire
import SwiftyJSON

class Requests {
    enum RequestError: Error {
        case parsing(msg: String)
    }
}

extension Requests {
    static func videos (_ uri: String) -> Observable<[Track]>{
        return RxAlamofire.requestJSON(.get, uri)
            .map{JSON.init($1)}
            .flatMap{Observable.from($0["tracks"].array!)}
            .map{try parseTrack(track:$0)}
            .toArray()
            .map{$0.flatMap{$0}}
            .observeOn(MainScheduler.instance);
    }
    
    private static func parseTrack( track: JSON) throws -> Track? {
        if let title = track["title"].string,
            let imagUri = track["imageUri"].string,
            let videoUri = track["videoUri"].string {
            return Track(title: title, imageUri: imagUri, videoUri: videoUri)
        }
        
        return nil
    }
}
