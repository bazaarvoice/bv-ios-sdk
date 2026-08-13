//
//  WriteReviewViewModel.swift
//  BVSDKDemo
//
//  Created by Rahul on 09/07/26.
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import SwiftUI
import BVSDK

// MARK: - Reactive Form State & Actions Model
public class WriteReviewViewModel: ObservableObject {
    @Published var product: BVProduct?
    @Published var productId: String = ""
    @Published var productReviewData: BVInitiateSubmitFormData?
    @Published var isProgressiveReview: Bool = false
    
    // Core Form Fields
    @Published var rating: Int = 0
    @Published var title: String = ""
    @Published var reviewText: String = ""
    @Published var userNickname: String = ""
    @Published var userEmail: String = ""
    @Published var isRecommended: Bool = true
    @Published var sendEmailAlertWhenPublished: Bool = false
    @Published var photo: UIImage? = nil
    @Published var videoPath: String? = nil
    @Published var videoFilename: String? = nil
    
    // Async Triggers & State Coach Elements
    @Published var isSubmitting: Bool = false
    @Published var targetTokens: [String] = []
    @Published var matchedTokens: [String] = []
    @Published var isMatching: Bool = false

    public init() {}

    public func setup(product: BVProduct?, productId: String?, reviewData: BVInitiateSubmitFormData?) {
        if let product = product {
            self.product = product
            self.productId = product.identifier
            self.isProgressiveReview = false
            self.loadTokens(for: product.identifier)
        } else if let productId = productId {
            self.productId = productId
            self.isProgressiveReview = false
            self.loadProduct(productId: productId)
            self.loadTokens(for: productId)
        } else if let reviewData = reviewData {
            self.productReviewData = reviewData
            self.productId = reviewData.progressiveSubmissionReview?.productId ?? ""
            self.isProgressiveReview = true
            
            if let progressive = reviewData.progressiveSubmissionReview {
                self.rating = Int(progressive.rating) // as? Int ?? 0
                print("self.rating: \(self.rating)")
                self.title = progressive.title ?? ""
                self.reviewText = progressive.reviewText ?? ""
                self.isRecommended = progressive.isRecommended?.boolValue ?? true
                self.userNickname = progressive.userNickname ?? ""
            }
            self.loadProduct(productId: self.productId)
            self.loadTokens(for: self.productId)
        }
    }
    
    private func loadProduct(productId: String) {
        let request = BVProductDisplayPageRequest(productId: productId)
            .includeStatistics(.reviews)
            .includeStatistics(.questions)
        request.load({ [weak self] (response) in
            DispatchQueue.main.async {
                self?.product = response.result
            }
        }) { (errors) in
            print("Error loading product details: \(String(describing: errors))")
        }
    }
    
    private func loadTokens(for productId: String) {
        let request = BVReviewTokensRequest(productId: productId)
        request.load({ [weak self] (response) in
            guard let self = self else { return }
            var tokensList: [String] = []
            if let directTokens = response.tokens {
                tokensList = directTokens
            } else if let dictTokens = response.value(forKey: "tokens") as? [String] {
                tokensList = dictTokens
            }
            DispatchQueue.main.async {
                self.targetTokens = tokensList
            }
        }) { (errors) in
            print("Error loading review feedback tokens: \(String(describing: errors))")
        }
    }
    
    public func analyzeTokens() {
        guard !reviewText.isEmpty else {
            DispatchQueue.main.async {
                self.matchedTokens = []
            }
            return
        }
        self.isMatching = true
        let submission = BVMatchedTokensSubmission(productId: productId, withReviewText: reviewText)
        submission.submit({ [weak self] (response) in
            guard let self = self else { return }
            var matches: [String] = []
            if let matchedObj = response.result {
                if let directMatches = matchedObj.tokens {
                    matches = directMatches
                } else if let dictMatches = matchedObj.value(forKey: "tokens") as? [String] {
                    matches = dictMatches
                }
            }
            DispatchQueue.main.async {
                self.matchedTokens = matches
                self.isMatching = false
            }
        }) { [weak self] (errors) in
            DispatchQueue.main.async {
                self?.isMatching = false
                print("Error calculating matches: \(String(describing: errors))")
            }
        }
    }
    
    public func submit(completion: @escaping (Result<String, Error>) -> Void) {
        self.isSubmitting = true
        
        if isProgressiveReview {
            let submission = BVProgressiveSubmitRequest(productId: self.productId)
            let agreedtotermsandconditions = true
            let fields: [AnyHashable: Any] = [
                "rating": self.rating,
                "title": self.title,
                "reviewtext": self.reviewText,
                "usernickname": self.userNickname,
                "isrecommended": self.isRecommended ? 1 : 0,
                "sendemailalertwhenpublished": self.sendEmailAlertWhenPublished ? 1 : 0,
                "agreedtotermsandconditions": agreedtotermsandconditions
            ]
            
            submission.submissionSessionToken = self.productReviewData?.submissionSessionToken ?? ""
            submission.locale = "en_US"
            submission.userToken = MockDataManager.sharedInstance.userToken
            submission.submissionFields = fields
            
            submission.submit({ [weak self] (response) in
                DispatchQueue.main.async {
                    self?.isSubmitting = false
                    completion(.success("Your progressive review was successfully submitted!"))
                }
            }) { [weak self] (errors) in
                DispatchQueue.main.async {
                    self?.isSubmitting = false
                    let error = errors.first ?? NSError(domain: "WriteReview", code: -1, userInfo: [NSLocalizedDescriptionKey: "Progressive submission failed."])
                    completion(.failure(error))
                }
            }
        } else {
            let submission = BVReviewSubmission(
                reviewTitle: self.title,
                reviewText: self.reviewText,
                rating: UInt(self.rating),
                productId: self.productId
            )
            
            submission.action = .preview
            let userId = "123abc\(arc4random())"
            submission.userNickname = self.userNickname
            submission.userEmail = self.userEmail
            submission.userId = userId
            submission.isRecommended = self.isRecommended as NSNumber
            submission.sendEmailAlertWhenPublished = self.sendEmailAlertWhenPublished as NSNumber
            submission.hostedAuthenticationEmail = self.userEmail
            
            if let photo = self.photo {
                submission.addPhoto(photo, withPhotoCaption: nil)
            }
            if let video = self.videoPath {
                submission.addVideo(video, withVideoCaption: "Video from Demo app", uploadVideo: true)
            }
            
            submission.submit({ [weak self] (response) in
                DispatchQueue.main.async {
                    self?.isSubmitting = false
                    completion(.success("Your review was successfully submitted in preview mode!"))
                }
            }) { [weak self] (errors) in
                DispatchQueue.main.async {
                    self?.isSubmitting = false
                    let error = errors.first ?? NSError(domain: "WriteReview", code: -1, userInfo: [NSLocalizedDescriptionKey: "Standard submission failed."])
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - SwiftUI Star Rating View Component
struct StarRatingView: View {
    @Binding var rating: Int
    var maxRating = 5
    var color = Color(UIColor.bazaarvoiceGold())
    var size: CGFloat = 32

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(index <= rating ? color : .gray)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

// MARK: - Declarative Media Picker Systems
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var selectedVideoPath: String?
    @Binding var selectedVideoName: String?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie", "public.video"]
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.selectedVideoPath = url.path
                parent.selectedVideoName = url.lastPathComponent
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
