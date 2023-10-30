//
//  RecommendationView.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 11/09/2023.
//

import SwiftUI

struct RecommendationView: View {
    
    @ObservedObject var viewModel: RecommendationViewModel
    @Environment(\.presentationMode) private var presentation


    var body: some View {
        VStack {
            Constants.Icons.logo
            stateView(state: viewModel.state)
            Spacer()
            Button(action: { handleStateButtonClicked() }) {
                Text(viewModel.state.buttonDescription)
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: Constants.Colors.primaryBlue, textColor: Color.white))
        }
        .padding([.top,.bottom], 45)
        .padding([.leading, .trailing], 20)
        .background(Color.white)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView(viewModel: RecommendationViewModel())
    }
}

extension RecommendationView {

    private func handleStateButtonClicked() {
       navigate()
    }
    
    private func navigate() {
        ProcessStatus.shared.status.send(.initialize)
        presentation.wrappedValue.dismiss()
    }
    
    @ViewBuilder private func stateView(state: ProcessState) -> some View {
        switch state {
        case .initialize,.processing, .completed, .autenticateFailed, .registrationFailed:
            RecommendationStateView(state: $viewModel.state)
        }
    }
}


struct RecommendationStateView: View {
    @Binding var state: ProcessState

    var body: some View {
        VStack {
            Text(state.title).font(Font.custom(Constants.Fonts.Inter.semiBold, size: 24)).foregroundColor(Color.black).multilineTextAlignment(.center)
                .padding([.trailing, .leading], 15)
            VStack(spacing: 38) {
                if state == .processing {
                    LoaderView(tintColor: .gray, scaleSize: 3.0)
                } else {
                    Image(state.icon)
                }
                Text(state.description).font(Font.custom(Constants.Fonts.Inter.regular, size: 16)).foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
            }.padding(.top, 72)
            .padding([.trailing, .leading], 15)
        }
        .padding(.top, 75)
    }
}
