struct CryptoCurrencyModel: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

extension CryptoCurrencyModel: CustomStringConvertible {
    var description: String {
        "\nName: \(name)\n-------"
    }
}
