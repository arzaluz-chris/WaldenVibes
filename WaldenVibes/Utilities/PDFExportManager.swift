// WaldenVibes/Utilities/PDFExportManager.swift
import Foundation
import UIKit
import PDFKit

class PDFExportManager {
    static let shared = PDFExportManager()
    
    private init() {}
    
    func createPDF(from dataManager: DataManager) -> Data? {
        // Get current locale for localization
        let currentLocale = Locale.current.language.languageCode?.identifier ?? "en"
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Walden Vibes",
            kCGPDFContextAuthor: "Walden Vibes App",
            kCGPDFContextTitle: currentLocale == "es" ? "Reporte de Bienestar Emocional" : "Emotional Wellness Report",
            kCGPDFContextSubject: currentLocale == "es" ? "Exportación de datos emocionales personales" : "Personal emotional data export"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // 8.5" x 11" at 72 DPI
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            let isSpanish = Locale.current.language.languageCode?.identifier == "es"
            
            // Cover Page
            createCoverPage(context: context, pageRect: pageRect, isSpanish: isSpanish)
            
            // Emotions Section
            if !dataManager.emotions.isEmpty {
                createEmotionsSection(context: context, pageRect: pageRect, emotions: dataManager.emotions, isSpanish: isSpanish)
            }
            
            // Moments Section
            if !dataManager.moments.isEmpty {
                createMomentsSection(context: context, pageRect: pageRect, moments: dataManager.moments, isSpanish: isSpanish)
            }
            
            // Stress Section
            if !dataManager.stressRecords.isEmpty {
                createStressSection(context: context, pageRect: pageRect, stressRecords: dataManager.stressRecords, isSpanish: isSpanish)
            }
            
            // Statistics Summary
            createStatisticsSection(context: context, pageRect: pageRect, dataManager: dataManager, isSpanish: isSpanish)
        }
        
        return data
    }
    
    // MARK: - Cover Page
    private func createCoverPage(context: UIGraphicsPDFRendererContext, pageRect: CGRect, isSpanish: Bool) {
        context.beginPage()
        
        let cgContext = context.cgContext
        
        // Background gradient
        let colors = [UIColor(hex: "9966CC").cgColor, UIColor(hex: "9966CC").withAlphaComponent(0.3).cgColor]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0.0, 1.0])!
        cgContext.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: pageRect.height), options: [])
        
        // App Logo Area with actual logo
        let logoRect = CGRect(x: pageRect.width/2 - 50, y: 100, width: 100, height: 100)
        cgContext.setFillColor(UIColor.white.withAlphaComponent(0.9).cgColor)
        cgContext.fillEllipse(in: logoRect)
        
        // Try to load and draw the app logo
        if let logoImage = UIImage(named: "LaunchLogo") {
            let logoImageRect = CGRect(x: logoRect.minX + 10, y: logoRect.minY + 10, width: 80, height: 80)
            logoImage.draw(in: logoImageRect)
        } else {
            // Fallback: Draw a heart emoji as logo
            let logoAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 50),
                .foregroundColor: UIColor(hex: "9966CC")
            ]
            let logoText = "💜"
            let logoTextRect = CGRect(x: logoRect.minX + 25, y: logoRect.minY + 25, width: 50, height: 50)
            logoText.draw(in: logoTextRect, withAttributes: logoAttributes)
        }
        
        // App name
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 48, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        let title = "Walden Vibes"
        let titleRect = CGRect(x: 50, y: 220, width: pageRect.width - 100, height: 60)
        title.draw(in: titleRect, withAttributes: titleAttributes)
        
        // Subtitle
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ]
        let subtitle = isSpanish ? "Reporte de Bienestar Emocional" : "Emotional Wellness Report"
        let subtitleRect = CGRect(x: 50, y: 290, width: pageRect.width - 100, height: 30)
        subtitle.draw(in: subtitleRect, withAttributes: subtitleAttributes)
        
        // Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = isSpanish ? Locale(identifier: "es") : Locale(identifier: "en")
        
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white.withAlphaComponent(0.8)
        ]
        let datePrefix = isSpanish ? "Generado el" : "Generated on"
        let dateText = "\(datePrefix) \(dateFormatter.string(from: Date()))"
        let dateRect = CGRect(x: 50, y: 330, width: pageRect.width - 100, height: 20)
        dateText.draw(in: dateRect, withAttributes: dateAttributes)
        
        // Decorative elements
        cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.3).cgColor)
        cgContext.setLineWidth(2)
        cgContext.move(to: CGPoint(x: 50, y: 400))
        cgContext.addLine(to: CGPoint(x: pageRect.width - 50, y: 400))
        cgContext.strokePath()
        
        // Privacy notice
        let privacyText = isSpanish ?
            "Este reporte contiene tus datos personales de bienestar emocional.\nToda la información se procesa localmente en tu dispositivo." :
            "This report contains your personal emotional wellness data.\nAll information is processed locally on your device."
        let privacyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white.withAlphaComponent(0.7)
        ]
        let privacyRect = CGRect(x: 50, y: pageRect.height - 150, width: pageRect.width - 100, height: 40)
        privacyText.draw(in: privacyRect, withAttributes: privacyAttributes)
    }
    
    // MARK: - Emotions Section
    private func createEmotionsSection(context: UIGraphicsPDFRendererContext, pageRect: CGRect, emotions: [Emotion], isSpanish: Bool) {
        context.beginPage()
        
        var yPosition: CGFloat = 50
        
        // Section header
        let emotionsTitle = isSpanish ? "🫶 Emociones" : "🫶 Emotions"
        yPosition = drawSectionHeader(context: context, pageRect: pageRect, title: emotionsTitle, yPosition: yPosition)
        yPosition += 20
        
        // Summary stats
        let totalEmotions = emotions.count
        let avgIntensity = emotions.reduce(0) { $0 + $1.intensity } / Double(emotions.count)
        let mostCommon = getMostCommonEmotion(emotions: emotions, isSpanish: isSpanish)
        
        let totalLabel = isSpanish ? "Total Registrado" : "Total Recorded"
        let avgLabel = isSpanish ? "Intensidad Promedio" : "Average Intensity"
        let commonLabel = isSpanish ? "Más Común" : "Most Common"
        
        yPosition = drawStatsBox(context: context, pageRect: pageRect, yPosition: yPosition, stats: [
            (totalLabel, "\(totalEmotions)"),
            (avgLabel, String(format: "%.1f/10", avgIntensity)),
            (commonLabel, "\(mostCommon.emoji) \(mostCommon.name)")
        ])
        yPosition += 30
        
        // Recent emotions
        let recentEmotions = Array(emotions.prefix(10))
        
        for emotion in recentEmotions {
            if yPosition > pageRect.height - 100 {
                context.beginPage()
                yPosition = 50
            }
            
            yPosition = drawEmotionCard(context: context, pageRect: pageRect, emotion: emotion, yPosition: yPosition, isSpanish: isSpanish)
            yPosition += 20
        }
    }
    
    private func drawEmotionCard(context: UIGraphicsPDFRendererContext, pageRect: CGRect, emotion: Emotion, yPosition: CGFloat, isSpanish: Bool) -> CGFloat {
        let cardRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 80)
        let cgContext = context.cgContext
        
        // Card background
        cgContext.setFillColor(emotion.type.uiColor.withAlphaComponent(0.1).cgColor)
        cgContext.fill(cardRect)
        
        // Card border
        cgContext.setStrokeColor(emotion.type.uiColor.withAlphaComponent(0.3).cgColor)
        cgContext.setLineWidth(1)
        cgContext.stroke(cardRect)
        
        // Emoji
        let emojiAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 32)
        ]
        let emojiRect = CGRect(x: cardRect.minX + 15, y: cardRect.minY + 15, width: 40, height: 40)
        emotion.type.emoji.draw(in: emojiRect, withAttributes: emojiAttributes)
        
        // Emotion name and intensity
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let nameText = emotion.type.localizedName(isSpanish: isSpanish)
        let nameRect = CGRect(x: cardRect.minX + 70, y: cardRect.minY + 15, width: 150, height: 20)
        nameText.draw(in: nameRect, withAttributes: nameAttributes)
        
        // Intensity visualization
        let intensityRect = CGRect(x: cardRect.minX + 70, y: cardRect.minY + 40, width: 100, height: 8)
        cgContext.setFillColor(UIColor.lightGray.cgColor)
        cgContext.fill(intensityRect)
        
        let filledWidth = intensityRect.width * (emotion.intensity / 10.0)
        let filledRect = CGRect(x: intensityRect.minX, y: intensityRect.minY, width: filledWidth, height: intensityRect.height)
        cgContext.setFillColor(emotion.type.uiColor.cgColor)
        cgContext.fill(filledRect)
        
        // Date and intensity text
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = isSpanish ? Locale(identifier: "es") : Locale(identifier: "en")
        
        let detailsText = "\(dateFormatter.string(from: emotion.date)) • \(Int(emotion.intensity))/10"
        let detailsAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]
        let detailsRect = CGRect(x: cardRect.minX + 70, y: cardRect.minY + 55, width: 200, height: 15)
        detailsText.draw(in: detailsRect, withAttributes: detailsAttributes)
        
        // Note if available
        if !emotion.note.isEmpty {
            let noteLabel = isSpanish ? "Nota:" : "Note:"
            let noteText = "\(noteLabel) \(emotion.note)"
            let noteAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.darkGray
            ]
            let noteRect = CGRect(x: cardRect.minX + 300, y: cardRect.minY + 15, width: cardRect.width - 320, height: 50)
            noteText.draw(in: noteRect, withAttributes: noteAttributes)
        }
        
        return yPosition + 80
    }
    
    // MARK: - Moments Section
    private func createMomentsSection(context: UIGraphicsPDFRendererContext, pageRect: CGRect, moments: [Moment], isSpanish: Bool) {
        context.beginPage()
        
        var yPosition: CGFloat = 50
        
        // Section header
        let momentsTitle = isSpanish ? "⭐ Momentos Especiales" : "⭐ Special Moments"
        yPosition = drawSectionHeader(context: context, pageRect: pageRect, title: momentsTitle, yPosition: yPosition)
        yPosition += 20
        
        // Summary stats
        let totalMoments = moments.count
        let totalDuration = moments.reduce(0) { $0 + $1.duration }
        let avgDuration = totalDuration / moments.count
        
        let totalLabel = isSpanish ? "Total de Momentos" : "Total Moments"
        let timeLabel = isSpanish ? "Tiempo Total" : "Total Time"
        let avgLabel = isSpanish ? "Duración Promedio" : "Average Duration"
        let minutesText = isSpanish ? "minutos" : "minutes"
        let minText = isSpanish ? "min" : "min"
        
        yPosition = drawStatsBox(context: context, pageRect: pageRect, yPosition: yPosition, stats: [
            (totalLabel, "\(totalMoments)"),
            (timeLabel, "\(totalDuration) \(minutesText)"),
            (avgLabel, "\(avgDuration) \(minText)")
        ])
        yPosition += 30
        
        // Recent moments
        let recentMoments = Array(moments.prefix(8))
        
        for moment in recentMoments {
            if yPosition > pageRect.height - 120 {
                context.beginPage()
                yPosition = 50
            }
            
            yPosition = drawMomentCard(context: context, pageRect: pageRect, moment: moment, yPosition: yPosition, isSpanish: isSpanish)
            yPosition += 20
        }
    }
    
    private func drawMomentCard(context: UIGraphicsPDFRendererContext, pageRect: CGRect, moment: Moment, yPosition: CGFloat, isSpanish: Bool) -> CGFloat {
        let cardRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 100)
        let cgContext = context.cgContext
        
        // Card background
        cgContext.setFillColor(moment.category.uiColor.withAlphaComponent(0.1).cgColor)
        cgContext.fill(cardRect)
        
        // Card border
        cgContext.setStrokeColor(moment.category.uiColor.withAlphaComponent(0.3).cgColor)
        cgContext.setLineWidth(1)
        cgContext.stroke(cardRect)
        
        // Category icon (using text representation)
        let iconAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: moment.category.uiColor
        ]
        let iconText = moment.category.iconEmoji
        let iconRect = CGRect(x: cardRect.minX + 15, y: cardRect.minY + 15, width: 30, height: 30)
        iconText.draw(in: iconRect, withAttributes: iconAttributes)
        
        // Category name
        let categoryAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: moment.category.uiColor
        ]
        let categoryText = moment.category.localizedName(isSpanish: isSpanish)
        let categoryRect = CGRect(x: cardRect.minX + 55, y: cardRect.minY + 15, width: 100, height: 20)
        categoryText.draw(in: categoryRect, withAttributes: categoryAttributes)
        
        // Duration
        let durationText = moment.formattedDuration
        let durationAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]
        let durationRect = CGRect(x: cardRect.minX + 55, y: cardRect.minY + 35, width: 100, height: 15)
        durationText.draw(in: durationRect, withAttributes: durationAttributes)
        
        // Description
        let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.darkText
        ]
        let descriptionRect = CGRect(x: cardRect.minX + 15, y: cardRect.minY + 55, width: cardRect.width - 30, height: 30)
        moment.description.draw(in: descriptionRect, withAttributes: descriptionAttributes)
        
        // Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = isSpanish ? Locale(identifier: "es") : Locale(identifier: "en")
        
        let dateText = dateFormatter.string(from: moment.date)
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.gray
        ]
        let dateRect = CGRect(x: cardRect.maxX - 150, y: cardRect.minY + 15, width: 140, height: 15)
        dateText.draw(in: dateRect, withAttributes: dateAttributes)
        
        return yPosition + 100
    }
    
    // MARK: - Stress Section
    private func createStressSection(context: UIGraphicsPDFRendererContext, pageRect: CGRect, stressRecords: [Stress], isSpanish: Bool) {
        context.beginPage()
        
        var yPosition: CGFloat = 50
        
        // Section header
        let stressTitle = isSpanish ? "⚡ Manejo del Estrés" : "⚡ Stress Management"
        yPosition = drawSectionHeader(context: context, pageRect: pageRect, title: stressTitle, yPosition: yPosition)
        yPosition += 20
        
        // Summary stats
        let totalRecords = stressRecords.count
        let avgStress = stressRecords.reduce(0) { $0 + $1.level } / Double(stressRecords.count)
        let maxStress = stressRecords.map { $0.level }.max() ?? 0
        
        let totalLabel = isSpanish ? "Total de Registros" : "Total Records"
        let avgLabel = isSpanish ? "Nivel Promedio" : "Average Level"
        let maxLabel = isSpanish ? "Nivel Máximo" : "Highest Level"
        
        yPosition = drawStatsBox(context: context, pageRect: pageRect, yPosition: yPosition, stats: [
            (totalLabel, "\(totalRecords)"),
            (avgLabel, String(format: "%.1f/10", avgStress)),
            (maxLabel, String(format: "%.1f/10", maxStress))
        ])
        yPosition += 30
        
        // Recent stress records
        let recentStress = Array(stressRecords.prefix(8))
        
        for stress in recentStress {
            if yPosition > pageRect.height - 100 {
                context.beginPage()
                yPosition = 50
            }
            
            yPosition = drawStressCard(context: context, pageRect: pageRect, stress: stress, yPosition: yPosition, isSpanish: isSpanish)
            yPosition += 20
        }
    }
    
    private func drawStressCard(context: UIGraphicsPDFRendererContext, pageRect: CGRect, stress: Stress, yPosition: CGFloat, isSpanish: Bool) -> CGFloat {
        let cardRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 80)
        let cgContext = context.cgContext
        
        // Card background
        cgContext.setFillColor(stress.stressUIColor.withAlphaComponent(0.1).cgColor)
        cgContext.fill(cardRect)
        
        // Card border
        cgContext.setStrokeColor(stress.stressUIColor.withAlphaComponent(0.3).cgColor)
        cgContext.setLineWidth(1)
        cgContext.stroke(cardRect)
        
        // Stress emoji
        let emojiAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 32)
        ]
        let emojiRect = CGRect(x: cardRect.minX + 15, y: cardRect.minY + 15, width: 40, height: 40)
        stress.stressEmoji.draw(in: emojiRect, withAttributes: emojiAttributes)
        
        // Stress level
        let levelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: stress.stressUIColor
        ]
        let levelText = "\(Int(stress.level))/10"
        let levelRect = CGRect(x: cardRect.minX + 70, y: cardRect.minY + 15, width: 60, height: 25)
        levelText.draw(in: levelRect, withAttributes: levelAttributes)
        
        // Stress level bar
        let barRect = CGRect(x: cardRect.minX + 70, y: cardRect.minY + 45, width: 100, height: 8)
        cgContext.setFillColor(UIColor.lightGray.cgColor)
        cgContext.fill(barRect)
        
        let filledWidth = barRect.width * (stress.level / 10.0)
        let filledRect = CGRect(x: barRect.minX, y: barRect.minY, width: filledWidth, height: barRect.height)
        cgContext.setFillColor(stress.stressUIColor.cgColor)
        cgContext.fill(filledRect)
        
        // Triggers
        if !stress.triggers.isEmpty {
            let triggersLabel = isSpanish ? "Detonantes:" : "Triggers:"
            let triggerNames = stress.triggers.map { $0.localizedName(isSpanish: isSpanish) }.joined(separator: ", ")
            let triggersText = "\(triggersLabel) \(triggerNames)"
            let triggersAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.darkGray
            ]
            let triggersRect = CGRect(x: cardRect.minX + 200, y: cardRect.minY + 15, width: cardRect.width - 220, height: 30)
            triggersText.draw(in: triggersRect, withAttributes: triggersAttributes)
        }
        
        // Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = isSpanish ? Locale(identifier: "es") : Locale(identifier: "en")
        
        let dateText = dateFormatter.string(from: stress.date)
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]
        let dateRect = CGRect(x: cardRect.minX + 70, y: cardRect.minY + 58, width: 200, height: 15)
        dateText.draw(in: dateRect, withAttributes: dateAttributes)
        
        return yPosition + 80
    }
    
    // MARK: - Statistics Section
    private func createStatisticsSection(context: UIGraphicsPDFRendererContext, pageRect: CGRect, dataManager: DataManager, isSpanish: Bool) {
        context.beginPage()
        
        var yPosition: CGFloat = 50
        
        // Section header
        let statsTitle = isSpanish ? "📊 Estadísticas y Análisis" : "📊 Statistics & Insights"
        yPosition = drawSectionHeader(context: context, pageRect: pageRect, title: statsTitle, yPosition: yPosition)
        yPosition += 20
        
        // Overall summary
        let totalEntries = dataManager.emotions.count + dataManager.moments.count + dataManager.stressRecords.count
        let daysTracked = Set(dataManager.emotions.map { Calendar.current.startOfDay(for: $0.date) }).count
        
        let totalLabel = isSpanish ? "Total de Entradas" : "Total Entries"
        let daysLabel = isSpanish ? "Días Registrados" : "Days Tracked"
        let qualityLabel = isSpanish ? "Calidad de Datos" : "Data Quality"
        let qualityValue = daysTracked > 30 ? (isSpanish ? "Excelente" : "Excellent") :
                          daysTracked > 7 ? (isSpanish ? "Buena" : "Good") :
                          (isSpanish ? "Comenzando" : "Getting Started")
        
        yPosition = drawStatsBox(context: context, pageRect: pageRect, yPosition: yPosition, stats: [
            (totalLabel, "\(totalEntries)"),
            (daysLabel, "\(daysTracked)"),
            (qualityLabel, qualityValue)
        ])
        yPosition += 40
        
        // Emotion frequency
        if !dataManager.emotions.isEmpty {
            yPosition = drawEmotionFrequencyChart(context: context, pageRect: pageRect, emotions: dataManager.emotions, yPosition: yPosition, isSpanish: isSpanish)
            yPosition += 40
        }
        
        // Key insights
        yPosition = drawInsightsSection(context: context, pageRect: pageRect, dataManager: dataManager, yPosition: yPosition, isSpanish: isSpanish)
    }
    
    private func drawEmotionFrequencyChart(context: UIGraphicsPDFRendererContext, pageRect: CGRect, emotions: [Emotion], yPosition: CGFloat, isSpanish: Bool) -> CGFloat {
        let chartRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 150)
        let cgContext = context.cgContext
        
        // Chart title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let titleRect = CGRect(x: chartRect.minX, y: chartRect.minY, width: chartRect.width, height: 20)
        let chartTitle = isSpanish ? "Frecuencia de Emociones" : "Emotion Frequency"
        chartTitle.draw(in: titleRect, withAttributes: titleAttributes)
        
        // Calculate frequencies
        var frequencies: [EmotionType: Int] = [:]
        for emotion in emotions {
            frequencies[emotion.type, default: 0] += 1
        }
        
        let sortedFreqs = frequencies.sorted { $0.value > $1.value }
        
        // Draw bars
        let barChartRect = CGRect(x: chartRect.minX, y: chartRect.minY + 30, width: chartRect.width, height: 100)
        let barWidth = barChartRect.width / CGFloat(sortedFreqs.count) - 10
        let maxValue = sortedFreqs.first?.value ?? 1
        
        for (index, (emotionType, count)) in sortedFreqs.enumerated() {
            let barHeight = (CGFloat(count) / CGFloat(maxValue)) * barChartRect.height
            let barRect = CGRect(
                x: barChartRect.minX + CGFloat(index) * (barWidth + 10),
                y: barChartRect.maxY - barHeight,
                width: barWidth,
                height: barHeight
            )
            
            cgContext.setFillColor(emotionType.uiColor.cgColor)
            cgContext.fill(barRect)
            
            // Emoji label
            let emojiAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16)
            ]
            let emojiRect = CGRect(x: barRect.minX, y: barRect.maxY + 5, width: barWidth, height: 20)
            emotionType.emoji.draw(in: emojiRect, withAttributes: emojiAttributes)
        }
        
        return yPosition + 150
    }
    
    private func drawInsightsSection(context: UIGraphicsPDFRendererContext, pageRect: CGRect, dataManager: DataManager, yPosition: CGFloat, isSpanish: Bool) -> CGFloat {
        var currentY = yPosition
        
        // Section title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let titleRect = CGRect(x: 50, y: currentY, width: pageRect.width - 100, height: 20)
        let insightsTitle = isSpanish ? "Análisis Clave" : "Key Insights"
        insightsTitle.draw(in: titleRect, withAttributes: titleAttributes)
        currentY += 30
        
        // Generate insights
        let insights = generateInsights(dataManager: dataManager, isSpanish: isSpanish)
        
        for insight in insights {
            let insightRect = CGRect(x: 70, y: currentY, width: pageRect.width - 120, height: 30)
            let insightAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.darkText
            ]
            "• \(insight)".draw(in: insightRect, withAttributes: insightAttributes)
            currentY += 25
        }
        
        return currentY
    }
    
    // MARK: - Helper Methods
    private func drawSectionHeader(context: UIGraphicsPDFRendererContext, pageRect: CGRect, title: String, yPosition: CGFloat) -> CGFloat {
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor(hex: "9966CC")
        ]
        let headerRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 30)
        title.draw(in: headerRect, withAttributes: headerAttributes)
        
        // Underline
        let cgContext = context.cgContext
        cgContext.setStrokeColor(UIColor(hex: "9966CC").withAlphaComponent(0.3).cgColor)
        cgContext.setLineWidth(2)
        cgContext.move(to: CGPoint(x: 50, y: yPosition + 35))
        cgContext.addLine(to: CGPoint(x: pageRect.width - 50, y: yPosition + 35))
        cgContext.strokePath()
        
        return yPosition + 45
    }
    
    private func drawStatsBox(context: UIGraphicsPDFRendererContext, pageRect: CGRect, yPosition: CGFloat, stats: [(String, String)]) -> CGFloat {
        let boxRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 60)
        let cgContext = context.cgContext
        
        // Background
        cgContext.setFillColor(UIColor(hex: "9966CC").withAlphaComponent(0.1).cgColor)
        cgContext.fill(boxRect)
        
        // Border
        cgContext.setStrokeColor(UIColor(hex: "9966CC").withAlphaComponent(0.3).cgColor)
        cgContext.setLineWidth(1)
        cgContext.stroke(boxRect)
        
        // Stats
        let statWidth = boxRect.width / CGFloat(stats.count)
        for (index, (label, value)) in stats.enumerated() {
            let statRect = CGRect(x: boxRect.minX + CGFloat(index) * statWidth, y: boxRect.minY + 10, width: statWidth, height: 40)
            
            // Value
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor(hex: "9966CC")
            ]
            let valueRect = CGRect(x: statRect.minX, y: statRect.minY, width: statRect.width, height: 25)
            value.draw(in: valueRect, withAttributes: valueAttributes)
            
            // Label
            let labelAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.gray
            ]
            let labelRect = CGRect(x: statRect.minX, y: statRect.minY + 25, width: statRect.width, height: 15)
            label.draw(in: labelRect, withAttributes: labelAttributes)
        }
        
        return yPosition + 60
    }
    
    private func getMostCommonEmotion(emotions: [Emotion], isSpanish: Bool) -> (emoji: String, name: String) {
        var frequencies: [EmotionType: Int] = [:]
        for emotion in emotions {
            frequencies[emotion.type, default: 0] += 1
        }
        
        let mostCommon = frequencies.max { $0.value < $1.value }?.key ?? .happy
        return (mostCommon.emoji, mostCommon.localizedName(isSpanish: isSpanish))
    }
    
    private func generateInsights(dataManager: DataManager, isSpanish: Bool) -> [String] {
        var insights: [String] = []
        
        // Emotion insights
        if !dataManager.emotions.isEmpty {
            let avgIntensity = dataManager.emotions.reduce(0) { $0 + $1.intensity } / Double(dataManager.emotions.count)
            if isSpanish {
                insights.append("Tu intensidad emocional promedio es \(String(format: "%.1f", avgIntensity))/10")
            } else {
                insights.append("Your average emotion intensity is \(String(format: "%.1f", avgIntensity))/10")
            }
            
            let positiveEmotions = dataManager.emotions.filter { [.happy, .calm, .excited, .grateful].contains($0.type) }
            let positivePercentage = (Double(positiveEmotions.count) / Double(dataManager.emotions.count)) * 100
            if isSpanish {
                insights.append("\(String(format: "%.0f", positivePercentage))% de tus emociones registradas son positivas")
            } else {
                insights.append("\(String(format: "%.0f", positivePercentage))% of your recorded emotions are positive")
            }
        }
        
        // Stress insights
        if !dataManager.stressRecords.isEmpty {
            let avgStress = dataManager.stressRecords.reduce(0) { $0 + $1.level } / Double(dataManager.stressRecords.count)
            if avgStress < 5 {
                if isSpanish {
                    insights.append("Tus niveles de estrés están generalmente bien manejados")
                } else {
                    insights.append("Your stress levels are generally well-managed")
                }
            } else {
                if isSpanish {
                    insights.append("Considera técnicas de manejo del estrés - tu promedio es \(String(format: "%.1f", avgStress))/10")
                } else {
                    insights.append("Consider stress management techniques - your average is \(String(format: "%.1f", avgStress))/10")
                }
            }
        }
        
        // Activity insights
        let totalEntries = dataManager.emotions.count + dataManager.moments.count + dataManager.stressRecords.count
        if totalEntries > 100 {
            if isSpanish {
                insights.append("¡Excelente constancia en el registro! Tienes \(totalEntries) entradas totales")
            } else {
                insights.append("Excellent tracking consistency! You have \(totalEntries) total entries")
            }
        } else if totalEntries > 50 {
            if isSpanish {
                insights.append("¡Buenos hábitos de registro! Sigue registrando regularmente para mejores análisis")
            } else {
                insights.append("Good tracking habits! Keep recording regularly for better insights")
            }
        }
        
        return insights
    }
}

// MARK: - Extensions for UI Colors
extension EmotionType {
    var uiColor: UIColor {
        switch self {
        case .happy: return UIColor(hex: "FFD700")
        case .sad: return UIColor(hex: "6495ED")
        case .anxious: return UIColor(hex: "9370DB")
        case .calm: return UIColor(hex: "90EE90")
        case .angry: return UIColor(hex: "FF6B6B")
        case .excited: return UIColor(hex: "FF69B4")
        case .tired: return UIColor(hex: "B0C4DE")
        case .grateful: return UIColor(hex: "DDA0DD")
        }
    }
    
    func localizedName(isSpanish: Bool) -> String {
        if isSpanish {
            switch self {
            case .happy: return "Feliz"
            case .sad: return "Triste"
            case .anxious: return "Ansioso"
            case .calm: return "Calma"
            case .angry: return "Enojado"
            case .excited: return "Emocionado"
            case .tired: return "Cansado"
            case .grateful: return "Agradecido"
            }
        } else {
            switch self {
            case .happy: return "Happy"
            case .sad: return "Sad"
            case .anxious: return "Anxious"
            case .calm: return "Calm"
            case .angry: return "Angry"
            case .excited: return "Excited"
            case .tired: return "Tired"
            case .grateful: return "Grateful"
            }
        }
    }
}

extension MomentCategory {
    var uiColor: UIColor {
        switch self {
        case .work: return UIColor.systemBlue
        case .family: return UIColor.systemGreen
        case .friends: return UIColor.systemOrange
        case .personal: return UIColor.systemPink
        case .general: return UIColor.systemPurple
        }
    }
    
    var iconEmoji: String {
        switch self {
        case .work: return "💼"
        case .family: return "🏠"
        case .friends: return "👥"
        case .personal: return "❤️"
        case .general: return "⭐"
        }
    }
    
    func localizedName(isSpanish: Bool) -> String {
        if isSpanish {
            switch self {
            case .work: return "Trabajo"
            case .family: return "Familia"
            case .friends: return "Amigos"
            case .personal: return "Personal"
            case .general: return "General"
            }
        } else {
            switch self {
            case .work: return "Work"
            case .family: return "Family"
            case .friends: return "Friends"
            case .personal: return "Personal"
            case .general: return "General"
            }
        }
    }
}

extension StressTrigger {
    func localizedName(isSpanish: Bool) -> String {
        if isSpanish {
            switch self {
            case .work: return "Trabajo"
            case .relationships: return "Relaciones"
            case .health: return "Salud"
            case .finances: return "Finanzas"
            case .time: return "Presión de Tiempo"
            case .environment: return "Medio ambiente"
            case .technology: return "Tecnología"
            case .other: return "Otro"
            }
        } else {
            switch self {
            case .work: return "Work"
            case .relationships: return "Relationships"
            case .health: return "Health"
            case .finances: return "Finances"
            case .time: return "Time Pressure"
            case .environment: return "Environment"
            case .technology: return "Technology"
            case .other: return "Other"
            }
        }
    }
}

extension Stress {
    var stressUIColor: UIColor {
        switch level {
        case 0..<3: return UIColor(hex: "4CAF50")
        case 3..<5: return UIColor(hex: "FFC107")
        case 5..<7: return UIColor(hex: "FF9800")
        case 7...10: return UIColor(hex: "F44336")
        default: return UIColor.gray
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
