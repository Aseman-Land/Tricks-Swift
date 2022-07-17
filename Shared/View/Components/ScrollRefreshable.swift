//
//  SwiftUIPullToRefresh.swift
//  Tricks (iOS)
//
//  Created by Armin on 4/10/22.
//

import SwiftUI

struct ScrollRefreshable<Content: View>: View {
    var content: Content
    var onRefresh: () async -> ()
    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping () async -> ()) {
        self.content = content()
        self.onRefresh = onRefresh
        
        #if os(iOS)
        UIRefreshControl.appearance().tintColor = UIColor(.accentColor)
        #endif
    }
    
    var body: some View {
        /// FIXME: - The `List` is not stable and hast so many glitches that could take so much ram and cpu usage (Commented for now to fix in the future)
        /*
        #if os(iOS)
        List {
            content
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .refreshable {
            await onRefresh()
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
            } catch {
                print("Failed")
            }
        }
        #elseif os(macOS)
        ScrollView {
            content
        }
        #endif
         */
        
        ScrollView {
            content
        }
    }
}

struct ScrollRefreshable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollRefreshable {
                Text("Hello")
            } onRefresh: {
                // Refreshed
            }
            .navigationTitle("Hello world")
        }
    }
}
