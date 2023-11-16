%define _name angle
%define _cleaned_version %{getenv:CLEANED_VERSION}
%define _release %{getenv:RELEASE}
%define _url https://angle.khulnasoft.com
%define _version %{getenv:VERSION}
%define _source %{_name}-%{_arch}.tar.gz
%define _sourceroot %{_name}-%{_arch}
%define _buildname %{name}-%{version}-%{release}.%{_arch}
%define _username %{_name}
%define _sharedstatedir /var/lib

%if %{undefined _unitdir}
%global _unitdir %{_prefix}/lib/systemd/system
%endif

%if %{undefined _presetdir}
%global _presetdir %{_prefix}/lib/systemd/system-preset
%endif

%if %{undefined _modulesloaddir}
%global _modulesloaddir %{_prefix}/lib/modules-load.d
%endif

%if %{undefined _systemdgeneratordir}
%global _systemdgeneratordir %{_prefix}/lib/systemd/system-generators
%endif

%define _build_id_links none

Name: %{_name}
Summary: A lightweight and ultra-fast tool for building observability pipelines
Version: %{_cleaned_version}
Release: %{_release}
License: MPL-2.0
Group: Applications/System
Source: %{_source}
URL: %{_url}

%description
%{summary}

%prep
# We are currently in the BUILD dir
tar -xvf %{_sourcedir}/%{_source} --strip-components=2
cp -a %{_sourcedir}/systemd/. systemd

%install
# We are currently in the BUILDROOT dir
rm -rf %{buildroot}
mkdir -p %{buildroot}
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_sysconfdir}/%{_name}
mkdir -p %{buildroot}%{_sysconfdir}/default
mkdir -p %{buildroot}%{_sharedstatedir}/%{_name}
mkdir -p %{buildroot}%{_datadir}/%{_name}
mkdir -p %{buildroot}%{_unitdir}

cp -a %{_builddir}/bin/angle %{buildroot}%{_bindir}
cp -a %{_builddir}/config/angle.yaml %{buildroot}%{_sysconfdir}/%{_name}/angle.yaml
cp -a %{_builddir}/config/examples/. %{buildroot}%{_sysconfdir}/%{_name}/examples
cp -a %{_builddir}/systemd/angle.service %{buildroot}%{_unitdir}/angle.service
cp -a %{_builddir}/systemd/angle.default %{buildroot}%{_sysconfdir}/default/angle
cp -a %{_builddir}/licenses/. %{buildroot}%{_datadir}/%{_name}/licenses
cp -a %{_builddir}/NOTICE %{buildroot}%{_datadir}/%{_name}/NOTICE
cp -a %{_builddir}/LICENSE-3rdparty.csv %{buildroot}%{_datadir}/%{_name}/LICENSE-3rdparty.csv

%post
getent passwd %{_username} > /dev/null || \
  useradd --shell /sbin/nologin --system --home-dir %{_sharedstatedir}/%{_name} --user-group \
    --comment "Angle observability data router" %{_username}
chown %{_username} %{_sharedstatedir}/%{_name}
usermod -aG systemd-journal %{_username}  || true
usermod -aG systemd-journal-remote %{_username}  || true

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_bindir}/*
%{_unitdir}/angle.service
%config(noreplace) %{_sysconfdir}/%{_name}/angle.yaml
%config(noreplace) %{_sysconfdir}/default/angle
%config %{_sysconfdir}/%{_name}/examples/*
%dir %{_sharedstatedir}/%{_name}
%doc README.md
%doc %{_datadir}/%{_name}/NOTICE
%doc %{_datadir}/%{_name}/licenses/*
%doc %{_datadir}/%{_name}/LICENSE-3rdparty.csv
%license LICENSE

%changelog
* Fri Jun 21 2019 Angle Devs <angle@datadoghq.com> - 0.3.0
- Release v0.3.0
