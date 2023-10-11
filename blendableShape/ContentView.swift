//
//  ContentView.swift
//  blendableShape
//
//  Created by  Pavel Nepogodin on 11.10.23.
//

import SwiftUI

struct ContentView: View {
    @State private var location: CGPoint = CGPoint(x: 100, y: 100)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
    }
    
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    
    let colors = [Color.white, .pink, .yellow, .black]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(colors, id: \.self) { color in
                    color
                }
            }
            blendableShape(shape: RoundedRectangle(cornerRadius: 15))
                .frame(width: 100, height: 100)
                .position(location)
                .gesture(
                    simpleDrag.simultaneously(with: fingerDrag)
                )
        }.ignoresSafeArea()
    }
}

struct blendableShape<Shape: View>: View {
    let shape: Shape
    
    var body: some View {
        shape
            .foregroundColor(.white)
            .blendMode(.difference)
            .overlay(shape.blendMode(.hue))
            .overlay(shape.blendMode(.hue))
            .overlay(shape.foregroundColor(.white).blendMode(.overlay))
            .overlay(shape.foregroundColor(.black).blendMode(.overlay))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

