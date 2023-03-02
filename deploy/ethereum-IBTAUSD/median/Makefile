build  :; dapp --use solc:0.5.12 build
clean  :; dapp clean
test   :; dapp --use solc:0.5.12 test -v ${TEST_FLAGS}

# NOTE(jamesr) This locks to a working version of ds-test per median
.PHONY: dappinit
dappinit:
	rm -fr lib/ds-test
	git clone https://github.com/dapphub/ds-test --no-checkout lib/ds-test && \
		pushd lib/ds-test && \
		git checkout 6f7efd37230533f2542ae5d0d5882ba3933590d9 && \
		popd

.PHONY: msg
msg:
	@echo '1) Be sure you have set ETH_* vars for the appropriate environment'
	@echo '2) You must call with MEDIAN_NAME set, e.g. export MEDIAN_NAME=MedianGNOUSD'

.PHONY: estimate
estimate: msg build
	export MEDIAN_NAME && \
	seth estimate --create $(shell jq -r '.contracts | ."src/median.sol" | .Median.evm.bytecode.object' ./out/dapp.sol.json) "$(MEDIAN_NAME)()"
