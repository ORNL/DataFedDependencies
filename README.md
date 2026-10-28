DataFed is a federated scientific data management system, supporting cross-facility research activities including experimentation, simulation, and/or analytics. DataFed provides the software service infrastructure needed to build a loosely-couple data network between geographically distributed and heterogeneous facilities. Within this DataFed network, access to data is simple and uniform regardless of physical storage location, local environment type, or security policies.

DataFed includes a suite of services that are built from code housed in this repository:
- Core Service - Central service providing record and metadata management as well as orchestration
- Core Database - Central database containing records, metadata, and relationships - everything but raw data
- Repository Service - Data repository management service (co-located with raw data storage)
- Globus Auth-N Module - GridFTP custom authorization module that interfaces with core service
- Web Service - Web server hosting the DataFed Web Portal - includes core proxy service
- Web Portal Application - The primary point-of-presence and user interface for DataFed
- Command Line Interface - Utility for accessing data from compute and data environments (interactive and scriptable)


Please refer to the [DataFed homepage](https://ornl.github.io/DataFed) for full
documentation, papers, and presentations describing the architecture and use
cases of DataFed.

NOTE: This repository is meant simply for managing the external dependencies of DataFed.

## Web dependency ownership

`web/package.json` is the authoritative source for DataFed web `dependencies`,
`devDependencies`, and security `overrides`. The dependency image installs this
manifest directly. DataFed generates its application `web/package.json` by
combining these sections with application metadata from `web/package.json.in`.
Update dependency versions and overrides here rather than in the application
template. The relative `file:./zeromq-compat` dependency must be shipped alongside
the manifest when installing packages in another directory.

Commit dependency changes in this repository, then update DataFed's submodule
reference and rebuild the dependency and web images.

## Upgrade compatibility

The small `web/zeromq-compat` adapter preserves DataFed's existing ZeroMQ socket API
while using ZeroMQ.js 6.8.0 with the updated Node runtime.

Foxx CLI is pinned to 2.1.1 for provisioning and upgrades; its package internals are
unchanged. The `extract-zip` advisories (GHSA-jmr9-qjv8-65gv and GHSA-7pqw-9j4j-h8q3)
are accepted for the current deployment, which uploads trusted local sources and
uses no archive extraction. Run it as an unprivileged deployment user. Successful
deployment commands were checked against a mock ArangoDB; a full deployment was
not run. Upstream Foxx error reporting still uses `util.isError`, removed in Node 24.
