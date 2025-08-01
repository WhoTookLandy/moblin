import SwiftUI

struct StreamOverlayRightSceneSelectorView: View {
    @EnvironmentObject var model: Model
    @ObservedObject var database: Database
    @ObservedObject var sceneSelector: SceneSelector
    let width: CGFloat

    private func height() -> Double {
        if database.bigButtons {
            return segmentHeightBig
        } else {
            return segmentHeight
        }
    }

    var body: some View {
        SegmentedPicker(model.enabledScenes, selectedItem: Binding(get: {
            if sceneSelector.sceneIndex < model.enabledScenes.count {
                model.enabledScenes[sceneSelector.sceneIndex]
            } else {
                nil
            }
        }, set: { value in
            if let value, let index = model.enabledScenes.firstIndex(of: value) {
                sceneSelector.sceneIndex = index
            } else {
                sceneSelector.sceneIndex = 0
            }
        })) {
            Text($0.name)
                .font(.subheadline)
                .frame(
                    width: min(sceneSegmentWidth, (width - 20) / CGFloat(model.enabledScenes.count)),
                    height: height()
                )
        } onLongPress: { index in
            if index < model.enabledScenes.count {
                model.showSceneSettings(scene: model.enabledScenes[index])
            }
        }
        .onChange(of: sceneSelector.sceneIndex) { tag in
            model.selectScene(id: model.enabledScenes[tag].id)
        }
        .background(pickerBackgroundColor)
        .foregroundColor(.white)
        .frame(width: min(sceneSegmentWidth * Double(model.enabledScenes.count), width - 20))
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(pickerBorderColor)
        )
    }
}
