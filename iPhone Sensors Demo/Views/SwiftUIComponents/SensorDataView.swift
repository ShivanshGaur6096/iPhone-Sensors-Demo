//
//  SensorDataView.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 23/09/2025.
//

import SwiftUI

struct SensorDataView: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct EducationalCardView: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text(title)
                    .font(.headline)
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 16) {
        SensorDataView(
            title: "Pressure",
            value: "101.325",
            unit: "kPa",
            color: .green
        )
        
        EducationalCardView(
            title: "Barometer",
            description: "Measures atmospheric pressure and relative altitude changes.", icon: ""
        )
    }
    .padding()
}
