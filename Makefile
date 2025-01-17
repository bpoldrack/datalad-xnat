PYTHON ?= python

clean:
	$(PYTHON) setup.py clean
	rm -rf dist build bin docs/build docs/source/generated *.egg-info
	-find . -name '*.pyc' -delete
	-find . -name '__pycache__' -type d -delete

release-pypi:
	# better safe than sorry
	git grep -q '^##.*??? ??' -- CHANGELOG.md && exit 1 || true
	# avoid upload of stale builds
	test ! -e dist
	$(PYTHON) setup.py sdist
	python setup.py bdist_wheel
	twine upload dist/*

update-buildsupport:
	git subtree pull \
		-m "Update DataLad build helper" \
		--squash \
		--prefix _datalad_buildsupport \
		https://github.com/datalad/datalad-buildsupport.git \
		master
