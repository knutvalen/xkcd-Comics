final class ComicModel: Codable {
	var news: String?
	var transcript: String?
	var image: String?
	var alternative: String?
	var title: String?
	var year: String?
	var month: String?
	var day: String?
	var link: String?
	var number: Int?
	var safeTitle: String?
	
	enum Key: String, CodingKey {
		case news
		case transcript
		case image = "img"
		case alternative = "alt"
		case title
		case year
		case month
		case day
		case link
		case number = "num"
		case safeTitle = "safe_title"
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Key.self)
		news = try container.decodeIfPresent(String.self, forKey: .news)
		transcript = try container.decodeIfPresent(String.self, forKey: .transcript)
		image = try container.decodeIfPresent(String.self, forKey: .image)
		alternative = try container.decodeIfPresent(String.self, forKey: .alternative)
		title = try container.decodeIfPresent(String.self, forKey: .title)
		year = try container.decodeIfPresent(String.self, forKey: .year)
		month = try container.decodeIfPresent(String.self, forKey: .month)
		day = try container.decodeIfPresent(String.self, forKey: .day)
		link = try container.decodeIfPresent(String.self, forKey: .link)
		number = try container.decodeIfPresent(Int.self, forKey: .number)
		safeTitle = try container.decodeIfPresent(String.self, forKey: .safeTitle)
	}
	
}
