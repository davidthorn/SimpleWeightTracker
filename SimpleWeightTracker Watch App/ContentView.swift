//
//  ContentView.swift
//  SimpleWeightTracker Watch App
//
//  Created by David Thorn on 15.02.26.
//

import SwiftUI

internal struct ContentView: View {
    @StateObject private var viewModel: WatchContentViewModel

    internal init() {
        let vm = WatchContentViewModel()
        _viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        VStack {
            Image(systemName: viewModel.symbolName)
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(viewModel.titleText)
        }
        .padding()
    }
}

#if DEBUG
    #Preview {
        ContentView()
    }
#endif
