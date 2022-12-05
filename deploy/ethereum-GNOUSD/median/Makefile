build  :; dapp --use solc:0.5.12 build
clean  :; dapp clean
test   :; dapp --use solc:0.5.12 test -v ${TEST_FLAGS}
dappinit:
	rm -fr lib/ds-test
	git clone https://github.com/dapphub/ds-test lib/ds-test
estimate: build
	@echo 'Be sure you have set ETH_* vars for the appropriate environment'
	export MEDIAN_NAME && \
	seth estimate --create $(shell jq -r '.contracts | ."src/median.sol" | .MedianGNOUSD.evm.bytecode.object' ./out/dapp.sol.json) "$(MEDIAN_NAME)()"
	@echo "Next step? 'dapp create $(MEDIAN_NAME)'"
