// +build go1.4

#include "textflag.h"

/*
TEXT ·Ref(SB),NOSPLIT,$4-4
	CALL runtime·acquirem(SB)
	MOVL 0(SP), AX
	MOVL AX, ret+0(FP)
	CALL runtime·releasem(SB)
	RET
*/

// runtime·main_main is only a linkname alias for main·main and has no
// symbol of its own under external linking, so reference main·main directly.
TEXT ·Addrs(SB),NOSPLIT,$0-8
	MOVL	$runtime·main(SB), AX
	MOVL	AX, ret+0(FP)
	MOVL	$main·main(SB), AX
	MOVL	AX, ret+8(FP)
	RET
