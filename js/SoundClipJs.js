
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
			// console.warn(e);
			fan.afFannyTheFantom.SoundClipJs.context = null;
			console.warn("No Audio Context === No Sound Effects ... :(");
		}
}

fan.afFannyTheFantom.SoundClipJs.prototype.$typeof = function() {
	return fan.afFannyTheFantom.SoundClipJs.$type;
}

fan.afFannyTheFantom.SoundClipJs.prototype.m_url        = null;
fan.afFannyTheFantom.SoundClipJs.prototype.m_soundClips = null;
fan.afFannyTheFantom.SoundClipJs.prototype.m_buffer     = null;
fan.afFannyTheFantom.SoundClipJs.prototype.m_source     = null;
fan.afFannyTheFantom.SoundClipJs.prototype.m_gainNode   = null;

fan.afFannyTheFantom.SoundClipJs.make = function(soundUri, soundClips) {
	var soundJs = new fan.afFannyTheFantom.SoundClipJs();

	soundJs.m_soundClips = soundClips;

	if (soundUri.scheme() != "fan")
		throw fan.sys.ArgErr.make("Uri scheme must be 'fan': " + soundUri.toStr());
	var soundUrl = fan.sys.UriPodBase + soundUri.host() + soundUri.pathStr();
	soundJs.m_url = soundUrl;

	var context = fan.afFannyTheFantom.SoundClipJs.context;
	if (context == null)
		return soundJs;

	// create now so we can immediately set the volume
	soundJs.m_gainNode = context.createGain();

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
	// return 'true' if no sounds so the start screen thinks all the clips have loaded.
	return this.m_buffer != null || fan.afFannyTheFantom.SoundClipJs.context == null;
}

fan.afFannyTheFantom.SoundClipJs.prototype.volume = function() { return fan.sys.Float.make(this.m_gainNode.gain.value); }
fan.afFannyTheFantom.SoundClipJs.prototype.volume$ = function(volume) {
	var volVal = volume.valueOf();
	if (volVal < 0 || volVal > 1)
		throw fan.sys.ArgErr.make("Invalid volume: " + volVal);

	if (this.m_gainNode != null)
		this.m_gainNode.gain.value = volVal;
}

fan.afFannyTheFantom.SoundClipJs.prototype.play = function() {
	if (this.m_soundClips.mute() === true) return;

	var context = fan.afFannyTheFantom.SoundClipJs.context;
	if (context == null)
		return;
	if (this.m_buffer == null)
		return;

	this.m_source = context.createBufferSource();
	this.m_source.buffer = this.m_buffer;
	this.m_source.connect(this.m_gainNode);
	this.m_gainNode.connect(context.destination);
	this.m_source.start();

	var volume = this.volume();
	var curTime = context.currentTime;
	this.m_gainNode.gain.exponentialRampToValueAtTime(volume.valueOf(), curTime);
}

fan.afFannyTheFantom.SoundClipJs.prototype.stop = function() {
	if (this.m_source == null)
		return;
	this.m_source.stop();
}

fan.afFannyTheFantom.SoundClipJs.prototype.fadeOut = function(duration) {
	if (this.m_source == null)
		return;
	var volume  = this.volume();
	var context = fan.afFannyTheFantom.SoundClipJs.context;
	var curTime = context.currentTime;
	this.m_gainNode.gain.exponentialRampToValueAtTime(volume.valueOf(), curTime);
	this.m_gainNode.gain.exponentialRampToValueAtTime(0.01, curTime + (duration.toMillis() / 1000));

	var that = this;
	window.setTimeout(function() { that.stop(); }, duration.toMillis());
}
