// WaldenVibes/Views/Statistics/ExportView.swift
import SwiftUI

struct ExportView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingShareSheet = false
    @State private var showingTextShareSheet = false
    @State private var exportFormat: ExportFormat = .pdf
    @State private var isGeneratingPDF = false
    @State private var generatedPDFData: Data?
    
    enum ExportFormat: String, CaseIterable {
        case pdf = "PDF"
        case text = "Text"
        
        var displayName: String {
            switch self {
            case .pdf: return NSLocalizedString("PDF Report", comment: "Export format option")
            case .text: return NSLocalizedString("Text File", comment: "Export format option")
            }
        }
        
        var description: String {
            switch self {
            case .pdf: return NSLocalizedString("Rich visual report with colors, emojis and charts", comment: "Export format description")
            case .text: return NSLocalizedString("Simple text format compatible with any app", comment: "Export format description")
            }
        }
        
        var icon: String {
            switch self {
            case .pdf: return "doc.richtext"
            case .text: return "doc.text"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color("AccentColor"))
                        
                        Text(NSLocalizedString("Export Your Data", comment: "Export view title"))
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(NSLocalizedString("Choose how you want to export your wellness data", comment: "Export view description"))
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Format Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text(NSLocalizedString("Export Format", comment: "Section header for export format selection"))
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        ForEach(ExportFormat.allCases, id: \.self) { format in
                            FormatSelectionCard(
                                format: format,
                                isSelected: exportFormat == format,
                                action: { exportFormat = format }
                            )
                        }
                    }
                    
                    // Preview/Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(NSLocalizedString("What's Included", comment: "Section header for export contents"))
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 8) {
                            ExportContentRow(icon: "heart.fill", title: NSLocalizedString("All recorded emotions with intensities and notes", comment: ""), color: Color("EmotionHappy"))
                            ExportContentRow(icon: "star.fill", title: NSLocalizedString("Special moments with categories and durations", comment: ""), color: Color("EmotionExcited"))
                            ExportContentRow(icon: "waveform.path.ecg", title: NSLocalizedString("Stress records with triggers and levels", comment: ""), color: Color("StressModerate"))
                            if exportFormat == .pdf {
                                ExportContentRow(icon: "chart.bar.fill", title: NSLocalizedString("Visual charts and statistics", comment: ""), color: Color("AccentColor"))
                                ExportContentRow(icon: "paintpalette.fill", title: NSLocalizedString("Colors, emojis and beautiful formatting", comment: ""), color: .orange)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Export Button
                    Button(action: {
                        if exportFormat == .pdf {
                            generateAndSharePDF()
                        } else {
                            showingTextShareSheet = true
                        }
                    }) {
                        HStack {
                            if isGeneratingPDF {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: exportFormat.icon)
                            }
                            
                            if isGeneratingPDF {
                                Text(NSLocalizedString("Generating PDF...", comment: "PDF generation status"))
                                    .fontWeight(.semibold)
                            } else {
                                HStack(spacing: 4) {
                                    Text(NSLocalizedString("Export as", comment: "Export button prefix"))
                                    Text(exportFormat.displayName)
                                }
                                .fontWeight(.semibold)
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(12)
                        .disabled(isGeneratingPDF)
                    }
                    .padding(.horizontal, 20)
                    
                    // Data Summary
                    DataSummaryCard(dataManager: dataManager)
                        .padding(.horizontal, 20)
                    
                    Spacer(minLength: 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "Done button")) {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let pdfData = generatedPDFData {
                ShareSheet(items: [PDFShareItem(data: pdfData, filename: "WaldenVibes-Report.pdf")])
            }
        }
        .sheet(isPresented: $showingTextShareSheet) {
            ShareSheet(items: [dataManager.exportAllData()])
        }
    }
    
    private func generateAndSharePDF() {
        isGeneratingPDF = true
        
        // Generate PDF on background queue
        DispatchQueue.global(qos: .userInitiated).async {
            let pdfData = PDFExportManager.shared.createPDF(from: dataManager)
            
            DispatchQueue.main.async {
                isGeneratingPDF = false
                if let data = pdfData {
                    generatedPDFData = data
                    showingShareSheet = true
                } else {
                    // Handle error - could show an alert
                    print("Failed to generate PDF")
                }
            }
        }
    }
}

// MARK: - Format Selection Card
struct FormatSelectionCard: View {
    let format: ExportView.ExportFormat
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: format.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? Color("AccentColor") : .secondary)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(format.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(format.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color("AccentColor") : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

// MARK: - Export Content Row
struct ExportContentRow: View {
    let icon: String
    let title: String
    let color: Color
    
    init(icon: String, title: String, color: Color) {
        self.icon = icon
        self.title = title
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Data Summary Card
struct DataSummaryCard: View {
    let dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(NSLocalizedString("Your Data Summary", comment: "Data summary card title"))
                .font(.headline)
            
            HStack(spacing: 20) {
                DataSummaryItem(
                    icon: "heart.fill",
                    count: dataManager.emotions.count,
                    label: NSLocalizedString("Emotions", comment: ""),
                    color: Color("EmotionHappy")
                )
                
                DataSummaryItem(
                    icon: "star.fill",
                    count: dataManager.moments.count,
                    label: NSLocalizedString("Moments", comment: ""),
                    color: Color("EmotionExcited")
                )
                
                DataSummaryItem(
                    icon: "waveform.path.ecg",
                    count: dataManager.stressRecords.count,
                    label: NSLocalizedString("Stress Records", comment: ""),
                    color: Color("StressModerate")
                )
            }
            
            let totalEntries = dataManager.emotions.count + dataManager.moments.count + dataManager.stressRecords.count
            
            HStack {
                Text(String(format: NSLocalizedString("Total entries: %d", comment: "Total entries count"), totalEntries))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if totalEntries > 0 {
                    Text(NSLocalizedString("Ready to export! 🎉", comment: "Ready to export message"))
                        .font(.subheadline)
                        .foregroundColor(Color("AccentColor"))
                } else {
                    Text(NSLocalizedString("No data to export yet", comment: "No data message"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

// MARK: - Data Summary Item
struct DataSummaryItem: View {
    let icon: String
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - PDF Share Item
class PDFShareItem: NSObject, UIActivityItemSource {
    let data: Data
    let filename: String
    
    init(data: Data, filename: String) {
        self.data = data
        self.filename = filename
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Walden Vibes - Wellness Report"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "com.adobe.pdf"
    }
}
