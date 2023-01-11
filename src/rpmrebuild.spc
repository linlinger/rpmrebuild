# get rpm version
%define rpm_ver %( rpm -q --queryformat='%{VERSION}' rpm | cut -f 1 -d.)
# test for an rpm version
%define test_ver() %(if test %1 == %2; then echo 1; else echo 0;fi )
# define binary flags
%define is_rpm3 %test_ver %rpm_ver 3

%define __brp_mangle_shebangs echo "no shebang change"

# The Summary: line should be expanded to about here -----^
Summary: A tool to build rpm file from rpm database
Summary(fr): Un outil pour construire un package depuis une base rpm
Name: rpmrebuild
License: GPL
Group: Development/Tools
BuildRoot: %{_topdir}/installroots/%{name}-%{version}-%{release}
Source: rpmrebuild-%{version}.tar.gz
# Following are optional fields
Url: http://rpmrebuild.sourceforge.net
Packager: Eric Gerbier <eric.gerbier@tutanota.com>
#Distribution: 
BuildArchitectures: noarch
Requires: bash
Requires: cpio
Requires: sed
Requires: gawk

%if %is_rpm3
# rpm v3
Requires: rpm < 4.0
Requires: fileutils
Requires: textutils
Requires: /usr/bin/setarch
%define release_suffix %{release}rpm3

%else
# rpm v4 v5
Requires: rpm-build
Requires: coreutils
Requires: util-linux
%define release_suffix  %{release} 
%endif

Release: %{release_suffix}

# compatibility with old digest format
%global _binary_filedigest_algorithm 1
%global _source_filedigest_algorithm 1

%description
rpmrebuild allows to build an rpm file from an installed rpm, or from
another rpm file, with or without changes (batch or interactive).
It can be extended by a plugin system.
A typical use is to easily repackage a software after some configuration
changes.

%description -l fr
rpmbuild permet de fabriquer un package rpm à partir d'un 
package installé ou d'un fichier rpm, avec ou sans modifications 
(interactives ou batch).
Un système de plugin permet d'étendre ses fonctionnalités.
Une utilisation typique est la fabrication d'un package suite à des modifications
de configuration.

%prep
%setup -c rpmrebuild

%build
make %{?_smp_mflags}

%install
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"
make install DESTDIR="$RPM_BUILD_ROOT"

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"

%files -f rpmrebuild.files

