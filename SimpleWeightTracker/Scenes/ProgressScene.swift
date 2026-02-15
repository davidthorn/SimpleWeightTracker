//
//  ProgressScene.swift
//  SimpleWeightTracker
//
//  Created by David Thorn on 15.02.2026.
//

import SwiftUI

internal struct ProgressScene: View {
    private let serviceContainer: ServiceContainerProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    internal var body: some View {
        NavigationStack {
            ProgressView(serviceContainer: serviceContainer)
        }
    }
}

#if DEBUG
    #Preview {
        ProgressScene(serviceContainer: PreviewServiceContainer())
    }
#endif
