
// ONSET DETECTION

(
SynthDef(\onsetsynth, { |in=0, gain=1, threshold=0.6, relaxtime=2.1, floor=0.1, mingap=1, offset=0.04|
	var signal, onset;
	signal = SoundIn.ar(in)*gain;
	signal = FFT(LocalBuf(2048), signal, wintype:1);
	onset = Onsets.kr(signal, threshold, \rcomplex, relaxtime, floor, mingap, medianspan:11, whtype:1, rawodf:0);
	// you can do all kinds of analisys of the signal here and send them back in the SendReply
	SendReply.kr(onset, '/onset', 1);
}).add;
)




(
c = Synth(\onsetsynth, [
	\in, 0,
	\gain, 1,
	\threshold, 0.6, // usually you just need to tweak this parameter
	\relaxtime, 2.1,
	\floor, 0.1,
	\mingap, 1,
	\offset, 0.04
]);


OSCdef(\onsetOSCdef).clear;
OSCdef(\onsetOSCdef).free;
OSCdef(\onsetOSCdef, {|msg, time, addr, recvPort|
	msg[3].postln; // posts 1 if hit is detected
}, '/onset', s.addr);

)