//
//  PriceChartView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

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
        .onAppear {
            Task {
                await viewModel.fetchPriceHistory(for: coinId, vsCurrency: vsCurrency)
            }
        }
        .onChange(of: selectedDuration) { oldValue, newValue in
        }
    }
}

#Preview {
    PriceChartView(coinId: "bitcoin", vsCurrency: "usd")
}


//struct PriceChartView: View {
//    @StateObject var viewModel: PriceChartViewModel = PriceChartViewModel()
//    let coinId: String
//    let vsCurrency: String
//    
//    @State private var selectedDuration: ChartDuration = .week
//    
//    var body: some View {
//        VStack {
//            // Picker für die Dauer des Charts
//            HStack {
//                Text("Zeitraum:")
//                Picker("Zeitraum", selection: $selectedDuration) {
//                    ForEach(ChartDuration.allCases) { duration in
//                        Text(duration.rawValue).tag(duration)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//            }
//            .padding(.horizontal)
//            
//            if viewModel.isLoading {
//                ProgressView("Lade Chart...")
//            } else if let errorMessage = viewModel.errorMessage {
//                Text("Fehler: \(errorMessage)")
//                    .foregroundColor(.red)
//            } else {
//                Chart {
//                    ForEach(viewModel.priceData) { dataPoint in
//                        LineMark(
//                            x: .value("Datum", dataPoint.date),
//                            y: .value("Preis", dataPoint.price)
//                        )
//                    }
//                }
//                .chartYAxisLabel("Preis")
//                .frame(height: 200)
//                .padding()
//            }
//        }
//        .onAppear {
//            Task {
//                await viewModel.fetchPriceHistory(for: coinId, vsCurrency: vsCurrency, days: selectedDuration.days)
//            }
//        }
//        .onChange(of: selectedDuration) { oldValue, newValue in
//            Task {
//                await viewModel.fetchPriceHistory(for: coinId, vsCurrency: vsCurrency, days: newValue.days)
//            }
//        }
//    }
//}
//
//#Preview {
//    PriceChartView(coinId: "bitcoin", vsCurrency: "usd")
//}

//struct PriceChartView: View {
//    @StateObject var viewModel: PriceChartViewModel = PriceChartViewModel()
//    let coinId: String
//    let vsCurrency: String
//    
//    var body: some View {
//        VStack {
//            if viewModel.isLoading {
//                ProgressView("Lade Chart...")
//            } else if let errorMessage = viewModel.errorMessage {
//                Text("Fehler: \(errorMessage)")
//                    .foregroundColor(.red)
//            } else {
//                Text("Im Vergleich der letzten Woche")
//                Chart {
//                    ForEach(viewModel.priceData) { dataPoint in
//                        LineMark(
//                            x: .value("Datum", dataPoint.date),
//                            y: .value("Preis", dataPoint.price)
//                        )
//                    }
//                }
//                .chartYAxisLabel("Preis")
//                .frame(height: 200)
//                .padding()
//            }
//        }
//        .onAppear {
//            Task {
//                await viewModel.fetchPriceHistory(for: coinId, vsCurrency: vsCurrency)
//            }
//        }
//    }
//}
//
//#Preview {
//    PriceChartView(coinId: "bitcoin", vsCurrency: "usd")
//}
