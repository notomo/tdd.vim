test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" themis --exclude ./test/plugin/_test_data

.PHONY: test
