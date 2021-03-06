#!/bin/sh

# system utilities stubs

# UUT
. ../share/pot/set-rss.sh

# common stubs
. common-stub.sh

# app specific stubs
set-rss-help()
{
	__monitor HELP "$@"
}

_cpuset_validation()
{
	__monitor CPUSETVAL "$@"
	case $1 in
	0)
		return 0 # true
	esac
	return 1 # false
}

_set_rss()
{
	__monitor ADDRSS "$@"
}

test_pot_set_rss_001()
{
	pot-set-rss
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "0" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -bv
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "0" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "0" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -b bb
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "0" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "0" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -h
	assertEquals "Exit rc" "0" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "0" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "0" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"
}

test_pot_set_rss_002()
{
	pot-set-rss -p test-pot
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "1" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -C 0
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "0" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -M 200M
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "0" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -M 200M -C 0
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "0" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"
}

test_pot_set_rss_020()
{
	pot-set-rss -p test-no-pot -C 0
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "1" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -p test-no-pot -M 200M
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "1" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "1" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"

	setUp
	pot-set-rss -p test-pot -M 200M -C 44
	assertEquals "Exit rc" "1" "$?"
	assertEquals "Help calls" "0" "$HELP_CALLS"
	assertEquals "Error calls" "1" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "1" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "0" "$ADDRSS_CALLS"
	assertEquals "_cpuset_validation calls" "1" "$CPUSETVAL_CALLS"
}

test_pot_set_rss_021()
{
	pot-set-rss -p test-pot -M 200M
	assertEquals "Exit rc" "0" "$?"
	assertEquals "Help calls" "0" "$HELP_CALLS"
	assertEquals "Error calls" "0" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "1" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "1" "$ADDRSS_CALLS"
	assertEquals "_cpuset_validation calls" "0" "$CPUSETVAL_CALLS"

	setUp
	pot-set-rss -p test-pot -C 0
	assertEquals "Exit rc" "0" "$?"
	assertEquals "Help calls" "0" "$HELP_CALLS"
	assertEquals "Error calls" "0" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "1" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "1" "$ADDRSS_CALLS"
	assertEquals "_cpuset_validation calls" "1" "$CPUSETVAL_CALLS"

	setUp
	pot-set-rss -p test-pot -C 0 -M 200M
	assertEquals "Exit rc" "0" "$?"
	assertEquals "Help calls" "0" "$HELP_CALLS"
	assertEquals "Error calls" "0" "$ERROR_CALLS"
	assertEquals "_is_pot calls" "1" "$ISPOT_CALLS"
	assertEquals "_set_rss calls" "2" "$ADDRSS_CALLS"
	assertEquals "_cpuset_validation calls" "1" "$CPUSETVAL_CALLS"
}

setUp()
{
	common_setUp
	HELP_CALLS=0
	CPUSETVAL_CALLS=0
	ADDRSS_CALLS=0
}

. shunit/shunit2
