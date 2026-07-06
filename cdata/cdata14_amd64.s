// +build go1.4

#include "textflag.h"

/*
TEXT ·Ref(SB),NOSPLIT,$8-8
	CALL runtime·acquirem(SB)
	MOVQ 0(SP), AX
	MOVQ AX, ret+0(FP)
	CALL runtime·releasem(SB)
	RET
*/

// runtime·main_main is only a linkname alias for main·main and has no
// symbol of its own under external linking, so reference main·main directly.
TEXT ·Addrs(SB),NOSPLIT,$0-16
	MOVQ	$runtime·main(SB), AX
	MOVQ	AX, ret+0(FP)
	MOVQ	$main·main(SB), AX
	MOVQ	AX, ret+8(FP)
	RET
