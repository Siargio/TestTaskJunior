import Foundation

struct AlbumModel: Decodable {
    let results : [Album]
}

struct Album: Decodable {
    let  artistName: String
    let collectionName: String
    let artworkUrl100: String?
    let trackCount: Int
    let releaseDate: String
}
