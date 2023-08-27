//
//  ContentView.swift
//  BetterRest
//
//  Created by Muhammad Fahmi on 24/08/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 5
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    @State private var sleepAmout = 8.0
    @State private var coffeeAmount = 1
    //    @State private var alertTitle = ""
    //    @State private var alertMessage = ""
    ////    @State private var showingAlert = false
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(colors: [.mint, .white], startPoint: .bottom, endPoint: .top)
                    .ignoresSafeArea()
                Form{
                    Section{
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Wake up at", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        
                    }
                    Section{
                        Text("How much sleep do you want")
                            .font(.headline)
                        Stepper("\(sleepAmout.formatted()) hours", value: $sleepAmout, in: 4...12, step: 0.25)
                    }
                    Section{
                        //                        Text("How much coffee do you drink")
                        //                            .font(.headline)
                        //                        Stepper("\(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups")", value: $coffeeAmount, in: 1...20)
                        Picker("How much coffee do you drink", selection: $coffeeAmount){
                            ForEach(1..<21){
                                Text("\($0)")
                            }
                        }
                        .font(.headline.bold())
                    }
                    Section{
                        Text("Recommended Bedtime")
                            .fontWeight(.bold)
                        Text(calculateBedTime())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("BetterRest")
                //                .toolbar(){
                //                    Button("Calculate", action: calculateBedTime)
                //                }
                //                .alert(alertTitle, isPresented: $showingAlert){
                //                    Button("OK"){ }
                //                } message: {
                //                    Text("\(alertMessage)")
                //                }
            }
        }
    }
    
    //  Day 28 - Challenge 3.
    // "Change the user interface so that it always shows their
    //  recommended bedtime using a nice and large font. You
    //  should be able to remove the “Calculate” button entirely.
    func calculateBedTime() -> String {
        let bedTime: String
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            // more codes here
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmout, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            //            alertTitle = "Your ideal bedtime is..."
            bedTime = "\(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            // if something error
            //            alertTitle = "Error"
            bedTime = "Sorry, there was a problem calculating your bedtime."
        }
        return bedTime
        //        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

