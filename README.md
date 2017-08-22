# AudioUI
Audio UI is a Swift iOS experiment in Ultrasound based gesture recognition on iOS. The research is based on a paper by Microsoft Research https://www.microsoft.com/en-us/research/publication/ultrasound-based-gesture-recognition-2/
The simple idea behind this experiment is utilise the inbuilt speaker and microphone on mobile devices to allow hands free interaction.
An ultrasonic tone ~20-22kHz is emitted by the phone's speaker. This tone will reflect off the user's hand. This reflected sound will be affected by a Doppler Shift. The Doppler Shift is a long standing principle in Physics that tells us that the velocity at which an object emits sounds --> effects the frequency of the emitted sound. f = (c+v)/(c) f_o
