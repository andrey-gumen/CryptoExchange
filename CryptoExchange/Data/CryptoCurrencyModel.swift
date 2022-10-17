struct CryptoCurrencyModel: Codable {
    let id: String
    let name: String
    let priceInUsd: Double?

    enum CodingKeys: String, CodingKey {
        case id = "asset_id"
        case name
        case priceInUsd = "price_usd"
    }
}

extension CryptoCurrencyModel: CustomStringConvertible {
    var description: String {
        "\nName: \(name) (\(id)) / Price: \(priceInUsd ?? 0): \n-------"
    }
}
