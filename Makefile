IVERILOG = iverilog
VVP      = vvp

SRC = src

TB = tb

all:
	@echo "Use one of:"
	@echo "make multiplier"
	@echo "make router"
	@echo "make popcount"

multiplier:
	$(IVERILOG) \
	-o multiplier.out \
	$(SRC)/compute/sc_multiplier.v \
	$(TB)/tb_sc_multiplier.v

	$(VVP) multiplier.out

router:
	$(IVERILOG) \
	-o router.out \
	$(SRC)/compute/sign_router.v \
	$(TB)/tb_sign_router.v

	$(VVP) router.out

popcount:
	$(IVERILOG) \
	-o popcount.out \
	$(SRC)/compute/popcount.v \
	$(TB)/tb_popcount.v

	$(VVP) popcount.out

clean:
	rm -f *.out *.vcd
