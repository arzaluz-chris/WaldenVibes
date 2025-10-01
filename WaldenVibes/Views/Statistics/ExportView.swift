// WaldenVibes/Views/Statistics/ExportView.swift
import SwiftUI

struct ExportView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
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
    
    // MARK: - Computed Properties for iPad Layout
    private var isIPad: Bool { horizontalSizeClass == .regular }
    private var contentMaxWidth: CGFloat { isIPad ? 700 : .infinity }
    private var headerIconSize: CGFloat { isIPad ? 80 : 60 }
    private var sectionSpacing: CGFloat { isIPad ? 32 : 24 }
    private var horizontalPadding: CGFloat { isIPad ? 40 : 20 }
    
    var body: some View {
        NavigationView {
            ZStack {
                if #available(iOS 26.0, *) {
                    AnimatedGlassBackground(color: Color("AccentColor")).ignoresSafeArea()
                }
                
                ScrollView {
                    VStack(spacing: sectionSpacing) {
                        headerSection
                        
                        if isIPad { iPadFormatSelectionSection }
                        else { iPhoneFormatSelectionSection }
                        
                        DataSummaryCard(dataManager: dataManager, isIPad: isIPad)
                            .padding(.horizontal, horizontalPadding)
                        
                        exportButton
                            .padding(.horizontal, horizontalPadding)
                        
                        Spacer(minLength: isIPad ? 50 : 30)
                    }
                    .frame(maxWidth: contentMaxWidth)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { navigationToolbar }
            .sheet(isPresented: $showingShareSheet) {
                if let pdfData = generatedPDFData {
                    ShareSheet(items: [PDFShareItem(data: pdfData, filename: "WaldenVibes-Report.pdf")])
                }
            }
            .sheet(isPresented: $showingTextShareSheet) {
                ShareSheet(items: [dataManager.exportAllData()])
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.system(size: headerIconSize))
                .foregroundColor(Color("AccentColor"))
            
            Text("Export Your Data", comment: "Export view title")
                .font(isIPad ? .largeTitle : .title2)
                .fontWeight(.semibold)
            
            Text("Choose how you want to export your wellness data", comment: "Export view description")
                .font(isIPad ? .title3 : .body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, horizontalPadding)
        }
        .padding(.top, isIPad ? 40 : 20)
    }
    
    private var iPadFormatSelectionSection: some View {
        VStack(spacing: 24) {
            Text("Choose Export Format", comment: "Format selection title")
                .font(.title2).fontWeight(.semibold).padding(.horizontal, horizontalPadding)
            HStack(spacing: 30) {
                ForEach(ExportFormat.allCases, id: \.self) { format in
                    iPadFormatSelectionCard(format: format)
                }
            }.padding(.horizontal, horizontalPadding)
        }
    }
    
    private var iPhoneFormatSelectionSection: some View {
        VStack(spacing: 12) {
            Text("Choose Export Format", comment: "Format selection title")
                .font(.headline).padding(.horizontal, horizontalPadding)
            
            ForEach(ExportFormat.allCases, id: \.self) { format in
                FormatSelectionCard(format: format, isSelected: exportFormat == format) {
                    exportFormat = format
                }
            }
        }.padding(.horizontal, horizontalPadding)
    }
    
    private func iPadFormatSelectionCard(format: ExportFormat) -> some View {
        Button(action: { exportFormat = format }) {
            VStack(spacing: 20) {
                Image(systemName: format.icon).font(.system(size: 50)).foregroundColor(exportFormat == format ? Color("AccentColor") : .secondary)
                VStack(spacing: 8) {
                    Text(format.displayName).font(.title3).fontWeight(.semibold).foregroundColor(.primary)
                    Text(format.description).font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                }
                VStack(spacing: 8) {
                    if format == .pdf {
                        ExportContentRow(icon: "heart.fill", title: NSLocalizedString("Emotions with charts", comment: ""), color: Color("EmotionHappy"))
                        ExportContentRow(icon: "star.fill", title: NSLocalizedString("Special moments", comment: ""), color: Color("EmotionExcited"))
                        ExportContentRow(icon: "waveform.path.ecg", title: NSLocalizedString("Stress analysis", comment: ""), color: Color("StressModerate"))
                        ExportContentRow(icon: "paintbrush.fill", title: NSLocalizedString("Colors, emojis and beautiful formatting", comment: ""), color: .orange)
                    } else {
                        ExportContentRow(icon: "doc.text", title: NSLocalizedString("Raw data export", comment: ""), color: .blue)
                        ExportContentRow(icon: "textformat", title: NSLocalizedString("Plain text format", comment: ""), color: .green)
                        ExportContentRow(icon: "square.and.arrow.up", title: NSLocalizedString("Compatible with all apps", comment: ""), color: .purple)
                    }
                }.padding(.top, 10)
            }
            .frame(maxWidth: .infinity).frame(height: 320).padding(24)
            .background(backgroundMaterial)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(exportFormat == format ? Color("AccentColor") : .clear, lineWidth: 3))
        }.buttonStyle(PlainButtonStyle())
    }
    
    private var exportButton: some View {
        Button(action: {
            if exportFormat == .pdf { generateAndSharePDF() } else { showingTextShareSheet = true }
        }) {
            HStack(spacing: 12) {
                if isGeneratingPDF { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).scaleEffect(isIPad ? 1.2 : 0.8) }
                else { Image(systemName: exportFormat.icon).font(isIPad ? .title2 : .headline) }
                
                if isGeneratingPDF { Text("Generating PDF...", comment: "PDF generation status").fontWeight(.semibold).font(isIPad ? .title3 : .headline) }
                else { HStack(spacing: 4) { Text("Export as", comment: "Export button prefix"); Text(exportFormat.displayName) }.fontWeight(.semibold).font(isIPad ? .title3 : .headline) }
            }
            .foregroundColor(.white).frame(maxWidth: isIPad ? 400 : .infinity).padding(isIPad ? 20 : 16)
            .background(exportButtonBackground)
            .cornerRadius(isIPad ? 16 : 12)
            .disabled(isGeneratingPDF)
        }
    }
    
    // MARK: - Helper Methods & Views
    
    @ViewBuilder
    private var backgroundMaterial: some View {
        if #available(iOS 26.0, *) {
            Color.clear.background(.regularMaterial)
        } else {
            Color(UIColor.secondarySystemBackground)
        }
    }
    
    @ViewBuilder
    private var exportButtonBackground: some View {
        if #available(iOS 26.0, *) {
            Color.clear.background(.regularMaterial).overlay(Color("AccentColor").opacity(0.8)).clipShape(RoundedRectangle(cornerRadius: isIPad ? 16 : 12))
        } else {
            Color("AccentColor")
        }
    }
    
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() }.font(isIPad ? .title3 : .body) }
    }
    
    private func generateAndSharePDF() {
        isGeneratingPDF = true
        DispatchQueue.global(qos: .userInitiated).async {
            let pdfData = PDFExportManager.shared.createPDF(from: dataManager)
            DispatchQueue.main.async {
                isGeneratingPDF = false
                if let data = pdfData { generatedPDFData = data; showingShareSheet = true }
                else { print("Failed to generate PDF") }
            }
        }
    }
}

// MARK: - Sub-components (Moved outside ExportView)

struct FormatSelectionCard: View {
    let format: ExportView.ExportFormat
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: format.icon).font(.title2).foregroundColor(isSelected ? Color("AccentColor") : .secondary).frame(width: 30)
                VStack(alignment: .leading, spacing: 4) {
                    Text(format.displayName).font(.headline).foregroundColor(.primary)
                    Text(format.description).font(.subheadline).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                if isSelected { Image(systemName: "checkmark.circle.fill").font(.title3).foregroundColor(Color("AccentColor")) }
            }
            .padding(20)
            .background(backgroundMaterial)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? Color("AccentColor") : .clear, lineWidth: 2))
        }.buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var backgroundMaterial: some View {
        if #available(iOS 26.0, *) {
            Color.clear.background(.regularMaterial)
        } else { Color(UIColor.secondarySystemBackground) }
    }
}

struct ExportContentRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.subheadline).foregroundColor(color).frame(width: 20)
            Text(title).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
            Spacer()
        }
    }
}

struct DataSummaryCard: View {
    @ObservedObject var dataManager: DataManager
    let isIPad: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 24 : 16) {
            Text("Your Data Summary", comment: "Data summary card title").font(isIPad ? .title2 : .headline).fontWeight(.semibold)
            
            let gridLayout = isIPad ? AnyView(HStack(spacing: 40) { summaryItems }) : AnyView(HStack(spacing: 20) { summaryItems })
            gridLayout
            
            let totalEntries = dataManager.emotions.count + dataManager.moments.count + dataManager.stressRecords.count
            HStack {
                Text(String(format: NSLocalizedString("Total entries: %d", comment: "Total entries count"), totalEntries)).font(isIPad ? .title3 : .subheadline).foregroundColor(.secondary)
                Spacer()
                if totalEntries > 0 {
                    Text("Ready to export! 🎉", comment: "Ready to export message").font(isIPad ? .title3 : .subheadline).foregroundColor(Color("AccentColor"))
                } else {
                    Text("No data to export yet", comment: "No data message").font(isIPad ? .title3 : .subheadline).foregroundColor(.secondary)
                }
            }
        }
        .padding(isIPad ? 32 : 20)
        .background(backgroundMaterial)
        .cornerRadius(isIPad ? 20 : 16)
    }

    @ViewBuilder
    private var summaryItems: some View {
        DataSummaryItem(icon: "heart.fill", count: dataManager.emotions.count, label: NSLocalizedString("Emotions", comment: ""), color: Color("EmotionHappy"), isIPad: isIPad)
        DataSummaryItem(icon: "star.fill", count: dataManager.moments.count, label: NSLocalizedString("Moments", comment: ""), color: Color("EmotionExcited"), isIPad: isIPad)
        DataSummaryItem(icon: "waveform.path.ecg", count: dataManager.stressRecords.count, label: NSLocalizedString("Stress Records", comment: ""), color: Color("StressModerate"), isIPad: isIPad)
    }

    @ViewBuilder
    private var backgroundMaterial: some View {
        if #available(iOS 26.0, *) {
            Color.clear.background(.regularMaterial)
        } else { Color(UIColor.secondarySystemBackground) }
    }
}

struct DataSummaryItem: View {
    let icon: String
    let count: Int
    let label: String
    let color: Color
    let isIPad: Bool
    
    var body: some View {
        VStack(spacing: isIPad ? 12 : 8) {
            Image(systemName: icon).font(isIPad ? .largeTitle : .title2).foregroundColor(color)
            Text("\(count)").font(isIPad ? .title : .title3).fontWeight(.bold)
            Text(label).font(isIPad ? .body : .caption).foregroundColor(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, isIPad ? 8 : 0)
    }
}

class PDFShareItem: NSObject, UIActivityItemSource {
    let data: Data
    let filename: String
    
    init(data: Data, filename: String) { self.data = data; self.filename = filename; super.init() }
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any { return data }
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? { return data }
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String { return "Walden Vibes - Wellness Report" }
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String { return "com.adobe.pdf" }
}
