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
            .flatMap{ (response, json) -> Observable<Track?> in
                return try Observable.from(parseVideoJson(json as? [String: AnyObject]))
            }
            .filter { track in
                guard
                    let _ = track
                    else { return false
                }
                return true;
            }
            .map { $0! }
            .toArray()
            .observeOn(MainScheduler.instance);
    }
    
    private static func parseVideoJson(_ jsonVal: Any) throws -> [Track?] {
        let json = JSON(jsonVal)
        
        guard
            let tracks = json["tracks"].array
            else {
                throw RequestError.parsing(msg: "Couldn't parse JSON response")
        }
        
        return tracks.map { track in
            if let title = track["title"].string,
                let imagUri = track["imageUri"].string,
                let videoUri = track["videoUri"].string {
                return Track(title: title, imageUri: imagUri, videoUri: videoUri)
            }
            
            return nil
        }
    }
}
