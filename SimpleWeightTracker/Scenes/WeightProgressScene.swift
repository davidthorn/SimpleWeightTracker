//
//  WeightProgressScene.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct WeightProgressScene: View {
    private let serviceContainer: ServiceContainerProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    internal var body: some View {
        NavigationStack {
            WeightProgressView(serviceContainer: serviceContainer)
        }
    }
}

#if DEBUG
    #Preview {
        WeightProgressScene(serviceContainer: PreviewServiceContainer())
    }
#endif
