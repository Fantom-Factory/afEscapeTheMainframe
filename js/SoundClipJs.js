
fan.afFannyTheFantom.SoundClipJs = fan.sys.Obj.$extend(fan.sys.Obj);
fan.afFannyTheFantom.SoundClipJs.prototype.$ctor = function() {
	if (!fan.afFannyTheFantom.SoundClipJs.context)
		try {
			window.AudioContext = window.AudioContext || window.webkitAudioContext;
			fan.afFannyTheFantom.SoundClipJs.context = new AudioContext();
			var context = fan.afFannyTheFantom.SoundClipJs.context;
			if (!context.createGain)
				context.createGain = context.createGainNode;
		} catch(e) {
			console.warn(e);
			fan.afFannyTheFantom.SoundClipJs.context = null;
			console.warn("No Audio Context === No Sound Effects");
		}
}

fan.afFannyTheFantom.SoundClipJs.prototype.$typeof = function() {
	return fan.afFannyTheFantom.SoundClipJs.$type;
}

fan.afFannyTheFantom.SoundClipJs.prototype.m_buffer = null;
fan.afFannyTheFantom.SoundClipJs.make = function(soundUri) {
	var soundJs = new fan.afFannyTheFantom.SoundClipJs();

	if (soundUri.scheme() != "fan")
		throw fan.sys.ArgErr.make("Uri scheme must be 'fan': " + soundUri.toStr());
	var soundUrl = fan.sys.UriPodBase + soundUri.host() + soundUri.pathStr();

	var context = fan.afFannyTheFantom.SoundClipJs.context;
	if (context == null)
		return soundJs;

	soundJs.m_gainNode	= context.createGain();
	soundJs.m_url		= soundUrl;

	var request = new XMLHttpRequest();
	request.open("GET", soundUrl, true);
	request.responseType = "arraybuffer";
	request.onload = function() {
		context.decodeAudioData(request.response, function(buffer) {
			soundJs.m_buffer = buffer;
		});
	}
	request.send();

	return soundJs;
}

fan.afFannyTheFantom.SoundClipJs.prototype.loaded = function() {
	return this.m_buffer != null
}

fan.afFannyTheFantom.SoundClipJs.prototype.play = function() {
	var context = fan.afFannyTheFantom.SoundClipJs.context;
	if (context == null)
		return;

	var source = context.createBufferSource();
	source.buffer = this.m_buffer;
	source.connect(this.m_gainNode);
	this.m_gainNode.connect(context.destination);
	source.start(0);
}

fan.afFannyTheFantom.SoundClipJs.prototype.stop = function() {
	console.info("Stop!")
}

fan.afFannyTheFantom.SoundClipJs.prototype.m_volume = 1;
fan.afFannyTheFantom.SoundClipJs.prototype.volume = function() { return this.m_volume; }
fan.afFannyTheFantom.SoundClipJs.prototype.volume$ = function(volume) {
	var volVal = volume.valueOf();
	if (volVal < 0 || volVal > 1)
		throw fan.sys.ArgErr.make("Invalid volume: " + volVal);
	this.m_volume = volVal;

	if (this.m_gainNode)
		this.m_gainNode.gain.value = volVal;
}
