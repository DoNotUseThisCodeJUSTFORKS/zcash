package=libzerocash
$(package)_download_path=https://github.com/Electric-Coin-Company/$(package)/archive/
$(package)_file_name=$(package)-$($(package)_git_commit).tar.gz
$(package)_download_file=$($(package)_git_commit).tar.gz
$(package)_sha256_hash=1364a739751bcdda86cfd66d3d019844d116c374d7a7634bfb3e1a47c085f3c0
$(package)_git_commit=dd5db5815be70f0e4895784cc905df6f1c73cb17

$(package)_dependencies=libsnark crypto++ openssl boost libgmp
$(package)_patches=

# FIXME: How do we know, at the point where the _build_cms are run, that the
# $(host_prefix)/include/libsnark folder is there? The lifecycle of that folder
# is as follows:
# 	1. First, the _stage_cmds of libsnark.mk create it in the staging directory.
#	2. At some point in time, the depends system moves it from the staging
#	   directory to the actual $(host_prefix)/include/libsnark directory.
#
# If (2) happens after the libzerocash_build_cmds get run, then what's in the
# $(host_prefix)/include/libsnark directory will be an *old* copy of the
# libsnark headers, and we might have to build twice in order for libzerocash to
# get the changes. If (2) happens before, then all is well, and it works.
#
#                       ** Which is it? **
#
$(package)_cppflags += -I$(BASEDIR)/../src -I. -I$(host_prefix)/include -I$(host_prefix)/include/libsnark -DCURVE_ALT_BN128 -DBOOST_SPIRIT_THREADSAFE -DHAVE_BUILD_INFO -D__STDC_FORMAT_MACROS -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -std=c++11 -pipe -O2 -O0 -g -Wstack-protector -fstack-protector-all -fPIE -fvisibility=hidden -fPIC

define $(package)_build_cmds
  $(MAKE) all DEPINST=$(host_prefix) CXXFLAGS="$($(package)_cppflags)" STATIC=1 MINDEPS=1 USE_MT=1 LINK_RT=1
endef

define $(package)_stage_cmds
  $(MAKE) install DEPINST=$(host_prefix) PREFIX=$($(package)_staging_dir)$(host_prefix) STATIC=1 MINDEPS=1 USE_MT=1
endef
