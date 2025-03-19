import SwiftUI
import Charts

struct PriceChartView: View {
    @StateObject var viewModel: PriceChartViewModel = PriceChartViewModel()
    let coinId: String
    let vsCurrency: String
    
    @State private var selectedDuration: ChartDuration = .week
    
    var body: some View {
        VStack {
            HStack {
                Text("Zeitraum:")
                Picker("Zeitraum", selection: $selectedDuration) {
                    ForEach(ChartDuration.allCases) { duration in
                        Text(duration.rawValue).tag(duration)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView("Lade Chart...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Fehler: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                let filteredData = viewModel.filteredData(for: selectedDuration)
                if filteredData.isEmpty {
                    Text("Keine Daten verfügbar, versuche es bitte in einer Minute erneut.")
                } else {
                    Chart {
                        ForEach(filteredData) { dataPoint in
                            LineMark(
                                x: .value("Datum", dataPoint.date),
                                y: .value("Preis", dataPoint.price)
                            )
                        }
                    }
                    .chartYAxisLabel("Preis")
                    .frame(height: 200)
                    .padding()
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPriceHistory(for: coinId)
            }
        }
        .onChange(of: selectedDuration) { _, _ in
            Task {
                await viewModel.fetchPriceHistory(for: coinId)
            }
        }
    }
}

#Preview {
    PriceChartView(coinId: "bitcoin", vsCurrency: "usd")
}
