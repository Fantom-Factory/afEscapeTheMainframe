using fwt
using gfx
using afIoc

@Js
class SineDots {

	Dot[]	dots	:= Dot[,]
	Buf		imgBuf	:= Buf.fromHex("00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0000009a242424f46a6a6bcd4242421c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000007e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008a1a1a1affdadadafffdfdfdfe8a8a8a3600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003d000000f31919192f000000000000000000000000000000160000006700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c54b4b4cffffffffffb2b2b264000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000dd4a4b4bd84d4d4e4404040499202020ac282828b7313132f15f5f60b823232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000931d1d1dfff0f0f0ffebebebad252526040000000000000000000000000000000000000000000000000000000000000000000000000000000000000061000000ffb3b4b5ef2a2a2afc848485ffcfd0d2ffd3d4d6ffc7c8caf460606146040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b000000f78d8d8dffffffffffd7d7d7d44b4b4c5403030303000000000000000a000000790f0f0f8114141425000000000000000000000000000000b7343434ffdddee0ff7b7c7dffd7d7d9ffd3d4d6fb8283849f1a1a1a1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009b1e1e1efff1f1f1fffefefffff9f9faffb4b5b5c0383838200000003e000000ff999a9affd7d8d8f57778786b0a0a0a0000000004000000e35e5e5fffdbdcdeff89898affd5d6d8ff999a9b850404048a0000003e0000001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002f000000ff9b9c9cffe5e5e6fffafafbfff8f8f8ffecececdc4b4b4b1e000000f2757676ffeaeaebffe7e7e8fe9c9c9d640a0a0a10000000f36e6f70ffd8d9dbff9d9d9fffd3d4d6ff737374ff7c7d7eff484949ff919293fa6d6e6fa62323255b0000002a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f3222222ffababacffe1e2e2fff6f6f7fff4f4f4ffd0d1d179020202e769696affe8e8e9ffe5e5e7ffe2e3e4ec5c5d5d17000000ed686969ffd7d8daffd5d6d7ffd2d3d5ffa5a6a7ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffcacbcdff61616250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000088181818fb7b7b7bffc3c3c4ffd5d5d5fff5f5f5fff2f2f3fff0f1f1b43a3a3ae15d5e5effe7e7e8ffe4e4e6ffe1e2e3ffafb0b157000000ce454547ff808182ffcecfd1ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc0c1c2d43f3f3f4d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000db525252ffdcdcddfffbfbfbfff9f9f9fff6f6f6fff3f4f4fff1f1f1ffebecec9e1f1f20e15c5d5dffe5e5e7ffe2e3e4ffdfe0e2ffdcdddf9c1a1a1a9a030303ff606061ff7c7c7dffcdced0ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ff8182832e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041040404f2737474fffcfcfcfffcfcfdfff9fafafff7f7f8fff2f2f2ffc4c4c5ff8c8d8df87b7b7b3b000000e6646565ffe3e3e5ffe1e1e3ffdddee0ffdbdcdedb484849d53d3e3effcfd0d2ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffb7b8b9ba2020206d0909090a0000000000000010000000000000000000000000000000000000000000000000000000000000000000000028000000f06f6f6ffffcfcfcfffdfdfefffbfbfbfff8f9f9ffa7a7a7ff929293ff9e9e9eff8e8e8fee5353538d0b0b0bf5727272ffe2e3e4ffdfe0e1ffdcdddfffd9dadcffa7a7a9ffc2c3c5ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffcdced0ffabacaed340414184040404d81415150800000000000000000000000000000000000000000000000000000006000000c93f3f3ffffafafafffefefffffcfcfcfff9fafafff7f7f7ffeeeeeefff1f2f2ffeeefefffebecedffe9e9eaff717172ff868687ffe0e1e2ffdddee0ffdadbddffd8d9dbffd5d6d8ffd2d3d5ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc9caccf16868690f0000000000000000000000000000000000000000000000000000005d080808ffc0c0c0fffffffffffdfdfefffafbfbfff8f8f9fff6f6f6fff3f3f3fff0f1f1ffecedeeffeaeaebffe7e8e9ffd5d5d7ffbababbffdfdfe1ffdbdcdeffd9dadcffd7d7d9ffd3d4d6ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffcacbcdbf2f2f3001000000000000000000000000000000000000000000000000000000cb494949fffefefefffefefffffcfcfcfff9fafafff7f7f7fff4f4f4fff1f2f2ffeeefefffebececffe8e9eaffe5e6e7ffe3e3e5ffe0e1e2ffdddedfffdadbddffd8d8daffd5d6d7ffd2d3d5ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffa4a5a6fd2c2d2d6800000008000000000000000000000000000000000000000000000023000000ff949595fffffffffffdfdfefffafbfbfff8f8f8fff5f5f5fff2f3f3fff0f0f0ffecedeeffeaeaebffe7e7e8ffe4e4e6ffe1e2e3ffdedfe1ffdbdcdeffd8d9dbffd6d7d9ffd3d4d6ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc2c3c4ffbabbbdff9a9b9dda444445430000000000000000000000000000000000000061000000ffd4d4d5fffefefefffbfbfcfff9f9fafff6f6f6fff3f4f4fff1f1f1ffedeeefffebebecffe8e8e9ffe5e5e7ffdadbdfffacb4c1ff94a0b2ff9ca6b6ffc5c8ceffd5d5d7ffd2d3d5ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4fb7a7a7b630a0a0a00000000000000000000000091121212fffdfdfefffdfdfdfffafafafff8f8f8fff5f5f5fff2f2f3ffeff0f0ffecededffe9eaeaffe1e3e5ff7487a6ff15458eff003d99ff0041a2ff003f9eff093e8fff677c9dffcfd0d3ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd3d4d6ffd2d3d5fa727374350000000000000000000000a8323232fffefefefffbfbfbfff8f9f9fff6f6f6fff3f3f4fff1f1f1ffedeeeeffebebecffe5e5e7ff476594ff0042a4ff0044aaff0044aaff0044aaff0044aaff0044aaff0040a0ff7486a2ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ff7d7e7fbc171717af2a2a2ce858595a9e0b0d0d0000000000000000a42c2c2cfffcfcfdfff9fafafff7f7f8fff5f5f5fff2f2f2ffeff0f0ffebecedffe9e9eaffdfe1e4ff1d498dff0044aaff0044aaff0044aaff0044aaff0044aaff0044aaff0044aaff214c8dffd2d3d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc7c8cad73c3e3e1a0000000e0000002b00000000000000000000008e0d0d0dfffafafafff8f9f9fff6f6f6fff3f3f3fff0f1f1ffedeeeeffeaebebffe7e8e9ffe4e4e6ff99a5b8ff033e97ff0044aaff0044aaff0044aaff0044aaff0044aaff0044aaff013687ffd4d4d6ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc7c8caec535354ba07070711000000000000000000000065000000ffd5d5d5fff7f7f7fff4f4f5fff2f2f2ffeeefefffebecedffe9e9eaffe6e6e8ffe3e3e5ffe1e1e3ff8e9cb2ff0d3f8dff0043a8ff0044aaff0044aaff0044aaff0044aaff0e3f8bffd3d3d5ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffb2b2b4e53333348f1b1b1b4d0707070000000000000000000000002e000000ff9e9e9ffff6f6f6fff2f3f3fff0f1f1ffecedeeffeaeaebffe7e7e9ffe4e4e6ffe2e2e4ffdedfe1ffdbdcdeffc6cad0ff5b7398ff083e92ff0044a9ff0044aaff0044aaff385b91ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc5c6c8ff898a8bc13030301700000000000000000000000000000003000000e7606161fff4f4f5fff1f1f2ffeeefefffebececffe8e8e9ffe5e6e7ffe3e3e5ffe0e1e2ffdddedfffdadbddffd8d8daffd5d6d8ffaeb5bfff1a478cff0044aaff0042a5ff7989a4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc0c1c3ff808182fc666667fb666667ff7d7d7effa9aaabbe2b2c2c010000000000000000000000000000008d191919ffdfdfe0ffeff0f0ffecededffeaeaebffe7e7e8ffe4e4e6ffe1e2e3ffdedfe1ffdbdcdeffd8d9dbffd6d7d9ffd3d4d6ffd1d2d4ff8b97abff0040a0ff0d408effc0c4caffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffcbcccef26565668f0b0b0b330000000c000000080000002300000074040404d81616184200000000000000000000000000000022000000f67c7d7dffedeeefffebebecffe8e8e9ffe5e5e7ffe2e3e4ffe0e0e2ffdcdddfffdadbddffd7d8daffd5d5d7ffd2d3d5ffd1d2d4ffa2aab7ff003d9aff3f5f90ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc8c9cbdb41414228000000000000000000000000000000000000000000000000000000090000000e0000000000000000000000000000000000000085111111ffc8c9caffe9e9eaffe6e7e8ffe3e3e5ffe1e1e3ffdedfe0ffdbdcdeffd8d9dbffd6d6d8ffd3d4d6ffd1d2d4ffc5c8cdff36598dff0043a9ff083e8fffbdc1c8ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4e7545555200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000ca39393affdbdbdcffe5e5e7ffe2e3e4ffdfe0e1ffdcdddfffd9dadcffd7d8daffd4d5d7ffcfd0d3ff8290a7ff1c488cff0042a6ff0044aaff0041a3ff8996aaffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4fc7b7c7d4900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000019000000d4404040ffd2d2d4ffe1e1e3ffdddee0ffdbdcdeffd8d9dbffd6d6d8ff99a3b4ff204a8aff0040a1ff0044aaff0044aaff0044aaff0044aaff62799cffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4fa7d7e7f63080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000015000000b92d2d2dffaaabacffdcdddfffd9dadcffd7d7d9ff8c98adff033d95ff0044aaff0044aaff0044aaff0044aaff0044aaff0043a8ff6e819fffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffc4c5c7ee5a5a5b4e030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000064000000e4555656ffb0b1b3ffd5d5d8ff244b89ff0044aaff0044aaff0044aaff0044aaff0044aaff0044aaff083e90ffb0b6c0ffd1d2d4ffd1d2d4ffbcbdbff7737374a11d1e1e1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0000006a0a0a0ad1434344fe4b515cff0e3063ff003584ff003e9cff0041a2ff003d99ff0e3c82ff758193ff8f9091fe606061cf4343437d0e0e0e24000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000180000004f000000ba010101ff575859ff5a5a5bff5a5b5cff666667ff787879ff909192b01a1a1a0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000039000000f3656667ffd1d2d4ffd1d2d4ffd1d2d4ffd1d2d4ffcdced0e64b4b4c1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a8202020ffcbccceffd1d2d4ffd1d2d4ffd0d1d3ffaeafb1da4040422c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000038000000d83f3f40ff5d5d5ef3565757c0393939740b0b0b0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
	
	new make() {
		imgW := 40
		imgH := 40

		xb	:= FannyTheFantom.windowSize.w / 4
		yb	:= FannyTheFantom.windowSize.h / 2
		
		imgW.times |x| {
			imgH.times |y| {
				pix := imgBuf.readU4
				if (pix == 0)
					return

				xx := x - (imgW / 2)
				yy := y - (imgH / 2)
				
				dot := Dot {
					// forced perspective
					it.x  = (xx*6) - (yy / 2) + xb
					it.y  = (yy*6) - (xx / 2) + yb
					it.v  = 40	// how many pix it moves

					it.ax = ((xx * 5f) + (yy * 4f)) / 360f
					it.ay = ((xx * 5f) + (yy * 4f)) / 360f

					it.sx = 0.003f
					it.sy = 0.012f

					it.col = Color(pix)
				}
				dots.add(dot)
			}
		}
//		echo("$dots.size dots")
	}

	Void draw(Gfx g, Int catchUp) {
		dots.each { it.draw(g).animate }

		if (catchUp > 1) {
			catchUp.decrement.times { 
				dots.each { it.animate }
			}
		}
	}
}

@Js
class Dot {
	const Int	x
	const Int	y
	const Int	v
	const Float sx
	const Float sy
	const Color	col
		  Float	ax
		  Float	ay
	
	new make(|This| in) { in(this) }

	This animate() {
		ax -= sx
		ax = ax - ax.floor

		ay -= sy
		ay = ay - ay.floor

		return this
	}
	
	This draw(Gfx g) {
		xx := x + (Sin.sinSimple(ax) * v)
		yy := y + (Sin.sinSimple(ay) * v)
		g.brush = col
//		g.drawPoint(xx.toInt + (g.bounds.w/2), yy.toInt+(g.bounds.h/2))
		g.drawRect(xx.toInt, yy.toInt, 1, 1)
		return this
	}
}