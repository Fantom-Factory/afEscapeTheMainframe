
@Js
const class Runtime {
	
	static Str version() {
		Runtime#.pod.version.toStr
	}

	static Bool isJs() {
		Env.cur.runtime == "js"
	}

	static Bool isJava() {
		Env.cur.runtime == "java"
	}

	static Bool isDotNet() {
		Env.cur.runtime == "dotnet"
	}
}
