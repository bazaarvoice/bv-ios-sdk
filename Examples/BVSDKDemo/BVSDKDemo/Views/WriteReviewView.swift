//
//  WriteReviewView.swift
//  BVSDKDemo
//
//  Created by Rahul on 09/07/26.
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import SwiftUI
import BVSDK
import UniformTypeIdentifiers

// MARK: - Standalone Main SwiftUI Review Component
public struct WriteReviewView: View {
    @ObservedObject var viewModel: WriteReviewViewModel
    var dismissAction: () -> Void
    
    @State private var showingImagePicker = false
    @State private var showingVideoPicker = false

    public init(viewModel: WriteReviewViewModel, dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismissAction
    }

    public var body: some View {
        ZStack {
            Form {
                // Section: Product Info Header
                Section(header: Text("Product Details")) {
                    HStack(spacing: 12) {
                        if let product = viewModel.product {
                            if let imageUrlString = product.imageUrl, let url = URL(string: imageUrlString) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                         .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.name ?? "Product")
                                    .font(.headline)
                                    .foregroundColor(Color(UIColor.bazaarvoiceNavy()))
                                if let stats = product.reviewStatistics {
                                    HStack(spacing: 2) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color(UIColor.bazaarvoiceGold()))
                                            .font(.caption)
                                        Text(String(format: "%.1f", stats.averageOverallRating?.doubleValue ?? 0.0))
                                            .font(.caption2)
                                            .bold()
                                        Text("(\(stats.totalReviewCount?.intValue ?? 0))")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        } else {
                            ProgressView()
                            Text("Loading Product Details...")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Section: Product Performance Rating
                Section(header: Text("Rate this product")) {
                    VStack(alignment: .leading, spacing: 8) {
                        StarRatingView(rating: $viewModel.rating)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 8)
                        
                        Toggle(isOn: $viewModel.isRecommended) {
                            Text("I recommend this product")
                        }
                        .tint(Color(UIColor.bazaarvoiceNavy()))
                    }
                }

                // Section: Review Title & Text
                Section(header: Text("Your Review")) {
                    TextField("Add your review title", text: $viewModel.title)
                        .autocapitalization(.sentences)
                    
                    if !viewModel.targetTokens.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Consider mentioning these details:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                if viewModel.isMatching {
                                    Spacer()
                                    ProgressView().scaleEffect(0.6)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.targetTokens, id: \.self) { token in
                                        let isMatched = viewModel.matchedTokens.contains { $0.caseInsensitiveCompare(token) == .orderedSame }
                                        HStack(spacing: 4) {
                                            Image(systemName: isMatched ? "checkmark.circle.fill" : "circle")
                                                .font(.caption2)
                                            Text(token.capitalized)
                                                .font(.caption)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(isMatched ? Color.green : Color(.systemGray5))
                                        .foregroundColor(isMatched ? .white : .primary)
                                        .cornerRadius(12)
                                        .animation(.easeInOut, value: isMatched)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.reviewText)
                                .frame(minHeight: 120)
                                .onChange(of: viewModel.reviewText) { _ in
                                    // Live content analysis every 10 characters
                                    if viewModel.reviewText.count % 10 == 0 {
                                        viewModel.analyzeTokens()
                                    }
                                }
                            
                            if viewModel.reviewText.isEmpty {
                                Text("Add your thoughts and experiences with this product.")
                                    .foregroundColor(.gray)
                                    .font(.body)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                }

                // Section: Nickname & public Email alerts
                Section(header: Text("Nickname & Email")) {
                    TextField("Public display name", text: $viewModel.userNickname)
                    TextField("Enter a valid email address", text: $viewModel.userEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Toggle(isOn: $viewModel.sendEmailAlertWhenPublished) {
                        Text("Send me status by email?")
                    }
                    .tint(Color(UIColor.bazaarvoiceNavy()))
                }

                // Section: Attachments Media Selectors
                Section(header: Text("Add photo (optional)")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .foregroundColor(Color(UIColor.bazaarvoiceNavy()))
                            if let photo = viewModel.photo {
                                Text("Photo attached! (Tap to replace)")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(uiImage: photo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(4)
                            } else {
                                Text("Select Photo")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section(header: Text("Add video (optional)")) {
                    Button(action: {
                        showingVideoPicker = true
                    }) {
                        HStack {
                            Image(systemName: "video")
                                .foregroundColor(Color(UIColor.bazaarvoiceNavy()))
                            if let videoPath = viewModel.videoPath {
                                Text("Video selected: \(viewModel.videoFilename ?? "movie.mp4")")
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            } else {
                                Text("Select Video")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                // Section: Form Submission Trigger
                Section {
                    Button(action: {
                        viewModel.submit { result in
                            switch result {
                            case .success(let msg):
                                _ = SweetAlert().showAlert("Success!", subTitle: msg, style: .success)
                                dismissAction()
                            case .failure(let err):
                                _ = SweetAlert().showAlert("Error!", subTitle: err.localizedDescription, style: .error)
                            }
                        }
                    }) {
                        Text("Submit Review")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(UIColor.bazaarvoiceNavy()))
                    )
                }
            }
            .navigationBarTitle("Write a Review", displayMode: .inline)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $viewModel.photo)
            }
            .sheet(isPresented: $showingVideoPicker) {
                VideoPicker(selectedVideoPath: $viewModel.videoPath, selectedVideoName: $viewModel.videoFilename)
            }

            // Visual Progress overlay during Submission APIs
            if viewModel.isSubmitting {
                ZStack {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text("Submitting Review...")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(24)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6).opacity(0.8)))
                }
            }
        }
    }
}

#Preview {
    WriteReviewView(viewModel: WriteReviewViewModel(), dismissAction: {
    return})
}
