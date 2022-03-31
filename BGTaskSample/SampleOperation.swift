//
//  SampleOperation.swift
//  BGTaskSample
//
//  Created by Bartlomiej Mika on 2022-03-31.
//

import Foundation

final class SampleOperation: Operation {

    let text: String

    init(text: String) {
        self.text = text
        super.init()
    }

    override func main() {
        guard !isCancelled else { return }
        print("Text:", text)
    }
}
