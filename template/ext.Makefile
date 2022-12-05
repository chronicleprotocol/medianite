dappinit:
	rm -fr lib/ds-test
	git clone https://github.com/dapphub/ds-test lib/ds-test
estimate: build
	@echo '1) Be sure you have set ETH_* vars for the appropriate environment'
	@echo '2) You must call with MEDIAN_NAME set, e.g. MEDIAN_NAME=MedianGNOUSD'
	export MEDIAN_NAME && \
	seth estimate --create $(shell jq -r '.contracts | ."src/median.sol" | .Median.evm.bytecode.object' ./out/dapp.sol.json) "$(MEDIAN_NAME)()"
