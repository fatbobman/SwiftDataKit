# SwiftDataKit

> Due to adjustments in the storage logic, SwiftDataKit is **no longer applicable to SwiftData following WWDC 2024**. For more details, please read [SwiftData in WWDC 2024: The Revolution Continues, Stability Still Awaits](https://fatbobman.com/en/posts/use-core-data-features-in-swiftdata-by-swiftdatakit/).

SwiftDataKit is an extension library of SwiftData that allows SwiftData developers to access Core Data objects corresponding to SwiftData elements.

Since the SwiftData framework was not fully functional in the initial creation, developers still need to call Core Data methods to implement some advanced features.

By using SwiftDataKit, developers can avoid duplicating the creation of Core Data version Data Model and Stack in certain scenarios.

Currently, this is an experimental library. Since the API of SwiftData is still changing rapidly, we only recommend experienced developers to try it in specific scenarios unless the user understands the implementation method and potential usage risks of the library.

For details, please refer to [SwiftDataKit: Unleashing Advanced Core Data Features in SwiftData](https://fatbobman.com/en/posts/use-core-data-features-in-swiftdata-by-swiftdatakit/) .

> 由于存储逻辑的调整，SwiftDataKit **不再适用于 WWDC 2024 后的 SwiftData**。详情请阅读 [SwiftData in WWDC 2024：革命仍在继续、稳定还需时日](https://fatbobman.com/zh/posts/use-core-data-features-in-swiftdata-by-swiftdatakit/)

SwiftDataKit 是 SwiftData 的扩展库，它使 SwiftData 开发人员可以访问 SwiftData 元素背后对应的Core Data对象。

由于 SwiftData 框架在创建初期功能尚不完善，开发人员仍需通过调用 Core Data 的方法来实现一些高级功能。

使用 SwiftDataKit，可以让开发人员在某些场景下避免重复创建 Core Data 版本的 Data Model 和Stack。

当前这是一个实验性的库。由于 SwiftData 的 API 仍在高速变化中，除非使用者清楚地了解该库的实现方法和可能的使用风险，我们仅推荐有经验的开发者在特定场景下进行尝试。

详细内容，请参阅[SwiftDataKit：让你在 SwiftData 中使用 Core Data 的高级功能](https://fatbobman.com/zh/posts/use-core-data-features-in-swiftdata-by-swiftdatakit/)。
