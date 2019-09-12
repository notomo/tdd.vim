test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" themis --exclude ./test/plugin/_test_data

setup_test:
	$(MAKE) -C ./test/plugin/_test_data/npm

.PHONY: test
.PHONY: setup_test
