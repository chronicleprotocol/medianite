build  :; dapp --use solc:0.5.12 build
clean  :; dapp clean
test   :; dapp --use solc:0.5.12 test -v ${TEST_FLAGS}
dappinit:
	rm -fr lib/ds-test
	git clone https://github.com/dapphub/ds-test lib/ds-test
	rm -fr lib/ds-thing
	git clone https://github.com/dapphub/ds-thing lib/ds-thing
