

// SILENCE DETECTION

(
		SynthDef(\silencesynth, {| in=0, gain=1, threshold=0.45, falltime=0.15, checkrate=20 |
			var detected, signal;
			signal = SoundIn.ar(in)*gain;
			detected = DetectSilence.ar( signal, amp:threshold, time:falltime );
			SendReply.kr(Impulse.kr(checkrate), '/silence', detected); // report
			//Out.ar(3, signal); // for monitoring the signal in channel 3. otherwise not needed
		}).add;
)

(
b = Synth(\silencesynth, [
				\in, 0,
				\gain, 1,
				\threshold, 0.35,
				\falltime, 0.15,
				\checktime, 10,
]);


OSCdef(\silenceOSCdef).clear;
OSCdef(\silenceOSCdef).free;
OSCdef(\silenceOSCdef, {|msg, time, addr, recvPort|
	if (msg[3]==1, {
		"silence".postln;
	},{
		"sound".postln;
	});
}, '/silence', s.addr);

)

