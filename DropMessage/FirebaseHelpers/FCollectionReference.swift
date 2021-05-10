//
//  FCollectionReference.swift
//  DropMessage
//
//  Created by Mostafa Zidan on 5/8/21.
//  Copyright © 2021 Mostafa Zidan. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Recent
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
