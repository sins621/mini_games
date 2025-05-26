extends AnimatedSprite2D

enum Anim {
	IDLE,
	RUN,
	JUMP
}

const ANIM_NAMES = {
	Anim.IDLE: "idle",
	Anim.RUN: "run",
	Anim.JUMP: "jump"
}

func play_animation(anim: Anim):
	self.play(ANIM_NAMES[anim])