#!/bin/sh

# system utilities stubs

if [ "$(uname)" = "Linux" ]; then
	TEST=/usr/bin/[
else
	TEST=/bin/[
fi

[()
{
	if ${TEST} "$1" = "!" ]; then
		if ${TEST} "$2" = "-d" ]; then
			if ${TEST} "$3" = "/jails/pot-test" ]; then
				return 1 # false
			elif ${TEST} "$3" = "/jails/pot-test-nodset" ]; then
				return 1 # false
			elif ${TEST} "$3" = "/jails/pot-test-noconf" ]; then
				return 1 # false
			elif ${TEST} "$3" = "/jails/pot-test/m" ]; then
				if ${TEST} "$4" = "-o" ]; then
					return 1 # false
				fi
			elif ${TEST} "$3" = "/bases/base-test" ]; then
				return 1 # false
			elif ${TEST} "$3" = "/bases/base-test-nodset" ]; then
				return 1 # false
			else
				return 0 # true
			fi
		fi
	fi
	${TEST} "$@"
	return $?
}


# UUT
. ../share/pot/common.sh

# app specific stubs
POT_FS_ROOT=
POT_ZFS_ROOT=

_error()
{
	:
}

_zfs_is_dataset()
{
	if ${TEST} "$1" = "/jails/pot-test" ]; then
		return 0 # true
	elif ${TEST} "$1" = "/jails/pot-test-noconf" ]; then
		return 0 # true
	fi
	if ${TEST} "$1" = "/bases/base-test" ]; then
		return 0
	fi
	return 1 # false
}

test_is_pot()
{
	_is_pot
	assertEquals "1" "$?"

	_is_pot nopot
	assertEquals "1" "$?"

	_is_pot pot-test-nodset
	assertEquals "2" "$?"

	_is_pot pot-test-noconf
	assertEquals "3" "$?"

	_is_pot pot-test
	assertEquals "0" "$?"
}

test_is_base()
{
	_is_base
	assertEquals "1" "$?"

	_is_base nobase
	assertEquals "1" "$?"

	_is_base base-test-nodset
	assertEquals "2" "$?"

	_is_base base-test
	assertEquals "0" "$?"
}

. shunit/shunit2
