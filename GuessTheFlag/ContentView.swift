import SwiftUI

struct FlagImage: View{
    var imageFileName: String
    
    var body: some View{
        Image(imageFileName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    
    @State private var alertMessage = ""
    
    @State private var phase = 0
    @State private var isOver = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()  // Embaralha
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var animationAmount = 0.0
    @State private var animationWrong = 0.0
    @State private var numberTapped = 0  // Helper
    @State private var opacityLevel = 1.0
    
    
    
    var body: some View {
        
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.75, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Spacer()  // On small devices, it'll virtually disappear. It's a great way to make sure our UI is flexible across all screen sizes.
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(imageFileName: countries[number])
                        }
                        .rotation3DEffect(.degrees(isThePressed(number) ? animationAmount : animationWrong),
                        axis: isThePressed(number) ? (x: 0, y: 1, z: 0) : (x: 1, y: 0, z: 0) )
                        .opacity(!isThePressed(number) ? opacityLevel : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert("Game Over!", isPresented: $isOver){
            Button("Restart", action: resetGame)
        } message: {
            Text("Your score is: \(score)")
        }
    }
    
    func isThePressed(_ num: Int) -> Bool{
        String(countries[numberTapped]) == String(countries[num])
    }
    
    func flagTapped(_ number: Int){
        
        numberTapped = number  // To verify in the rotating3d
        
        withAnimation{
            animationAmount = 360
            opacityLevel = 0.25
            animationWrong = 180
        }
        
        phase += 1
        
        if number == correctAnswer{
            scoreTitle = "Correct!"
            score += 1
            
            alertMessage = "Your score is \(score)"
        } else{
            scoreTitle = "Wrong!"
            alertMessage = "That's the flag of \(countries[number])!"
        }
        
        if phase == 8{
            isOver = true
        } else{
            showingScore = true
        }
    }
    
    func askQuestion(){  // resset the game
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityLevel = 1
        animationWrong = 0.0
    }
    
    func resetGame(){
        score = 0
        countries.shuffle()
        opacityLevel = 1
        animationWrong = 0.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
