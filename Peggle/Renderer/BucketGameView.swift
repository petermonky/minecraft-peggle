//
//  BucketGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import SwiftUI

struct BucketGameView: View {
    @StateObject var gameObject: BucketGameObject

    init(gameObject: BucketGameObject) {
        _gameObject = StateObject(wrappedValue: gameObject)
    }

    var body: some View {
        Image("bucket")
            .resizable()
            .scaledToFill()
            .frame(width: Constants.Cannon.width, height: Constants.Cannon.height)
            .position(gameObject.position)
    }
}

struct BucketGameView_Previews: PreviewProvider {
    static var previews: some View {
        let bucketGameObject = BucketGameObject()
        BucketGameView(gameObject: bucketGameObject)
    }
}
