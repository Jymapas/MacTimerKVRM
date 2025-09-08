import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: TimerViewModel

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.clear
                Text(vm.timerText)
                    .font(.system(size: 120, weight: .regular, design: .rounded))
                    .foregroundColor(vm.timerColor)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 200)

            // 2x2 кнопки как UniformGrid
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                GridRow {
                    Button("Вопрос", action: vm.startQuestion)
                        .font(.system(size: 24))
                        .buttonStyle(.borderedProminent)
                        .disabled(!vm.canStartQuestion)

                    Button("Дуплет", action: vm.startDupletOrContinue)
                        .font(.system(size: 24))
                        .buttonStyle(.borderedProminent)
                        .disabled(!vm.canStartDupletOrContinue)
                }
                GridRow {
                    Button("Блиц", action: vm.startBlitzOrContinue)
                        .font(.system(size: 24))
                        .buttonStyle(.borderedProminent)
                        .disabled(!vm.canStartBlitzOrContinue)

                    Button("Стоп", action: vm.stop)
                        .font(.system(size: 24))
                        .buttonStyle(.bordered)
                        .disabled(!vm.canStop)
                }
            }
            .padding(12)
        }
        .padding(.top, 8)
    }
}
