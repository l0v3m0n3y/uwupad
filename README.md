# uwupad
web-api for uwupad.me The best sounds for your Soundpad and ringtones.Find that meme sound from TikTok or a scream from your favorite game in 5 seconds. Download for free for your Soundpad or set it as a ringtone. Our collection is updated daily!
# main
```swift
import Foundation
let client = Uwupad()

do {
    let country = try await client.get_country_list()
    print(country)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swiftc -o uwu uwupad.swift main.swift
./uwu
```
