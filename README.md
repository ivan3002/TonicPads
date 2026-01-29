## TonicPads Live 
TonicPads Live is an innovative iOS application built for live performers. It bridges the gap between complex sound design and real-time performance, allowing musicians to craft and manipulate lush pad soundscapes through an intuitive, gesture-based interface.

## Key Features
Gesture-Based Control: Use multi-finger touch gestures to shape sounds in real-time. 
Performance Mode: A minimalist, distraction-free interface designed for the heat of a live show. 
Dynamic Visuals: Built with SpriteKit, the UI features a particle emitter system that provides visual feedback for your sound manipulations. 
Customizable Audio: Adjust attack and release times via a dedicated settings page to fit your playing style. 
Help Guide: An integrated, easily accessible guide helps users master gestures quickly.

###  Gesture Controls
|Finger Count|Direction|Function|
|----------|---------|------------|
| 1 Finger | Vertical | Adjust Volume | 
| 1 Finger | Horizontal | Select Root Note (Release to Play) | 
| 2 Fingers | Vertical | Control Harmonic Complexity |
| 2 Fingers | Horizontal | Adjust Low Pass Filter Cutoff | 
| 3 Fingers | Vertical | Adjust Reverb Amount/Mix |


Absolutely! Here is a professional and engaging README.md for your GitHub repository, based on the technical report and the demo video provided.

TonicPads Live 🎹✨
TonicPads Live is an innovative iOS application built for live performers. It bridges the gap between complex sound design and real-time performance, allowing musicians to craft and manipulate lush pad soundscapes through an intuitive, gesture-based interface. 

🚀 Key Features

Gesture-Based Control: Use multi-finger touch gestures to shape sounds in real-time. 


Performance Mode: A minimalist, distraction-free interface designed for the heat of a live show. 


Dynamic Visuals: Built with SpriteKit, the UI features a particle emitter system that provides visual feedback for your sound manipulations. 


Customizable Audio: Adjust attack and release times via a dedicated settings page to fit your playing style. 


Help Guide: An integrated, easily accessible guide helps users master gestures quickly. 

🖐 Gesture Controls
The heart of TonicPads Live is its multi-touch control scheme: 

Finger Count	Direction	Function
1 Finger	Vertical	
Adjust Volume 

1 Finger	Horizontal	
Select Root Note (Release to Play) 

2 Fingers	Vertical	
Control Harmonic Complexity 

2 Fingers	Horizontal	
Adjust Low Pass Filter Cutoff 

3 Fingers	Vertical	
Adjust Reverb Amount/Mix 

🛠 Technical Architecture
TonicPads Live is built using a Model-View-Controller (MVC) architecture to ensure modularity and scalability. 


Model (SoundEngine): Powered by the AudioKit library, handling all DSP and audio processing logic. 


View (SwiftUI & SpriteKit): Uses SwiftUI for the main interface and SpriteKit (SKScene) for high-performance visual rendering and multi-touch tracking. 


Controller (SoundViewModel): Acts as the bridge, translating user gestures into real-time audio parameter updates. 

Dependencies
AudioKit 

SoundpipeAudioKit 

DunneAudioKit 

## Future Development
Planned additional features include: 

Granular Synthesis: Introducing a custom granular node for more textural complexity. 
Themed Preset Banks: Cinematic, Ambient, and Textural soundscape categories. 
Gesture Remapping: Allowing users to customize controls for their specific workflow. 
Advanced Recognition: Introducing new gestures for even deeper sound design possibilities. 
