all:
	# NOTE note create `test` action, as make base on file name, there exist a dir named test/
	# thus `make test` would says nothing to do
	mix dialyzer
	mix test --exclude slow:true --exclude wip:true --trace
