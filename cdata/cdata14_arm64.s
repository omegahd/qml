// +build go1.4

#include "textflag.h"

// runtime·main_main is only a linkname alias for main·main and has no
// symbol of its own under external linking, so reference main·main directly.
TEXT ·Addrs(SB),NOSPLIT,$0-16
	MOVD	$runtime·main(SB), R0
	MOVD	R0, ret+0(FP)
	MOVD	$main·main(SB), R0
	MOVD	R0, ret+8(FP)
	RET
