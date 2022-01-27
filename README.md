# apisix-plugin-demo

[![Build Status][badge-action-img]][badge-action-url]

This repository contains a basic [Apache APISIX][apisix] plugin template to help you
get started with Apache APISIX plugin development.

> This template was designed to work with the [GitHub Action][github-actions] development environments.

## Table of contents
- [Getting started](#getting-started)
- [Plugin template structure](#plugin-template-structure)
- [Testing](#testing)
  - [Continuous integration](#continuous-integration)
- [Useful links](#useful-links)

### Getting Started
> Before we dive into plugin development and everything related to it,
> a brief look at the [GitHub Template][github-public-template] is in order

All you need to do is click the [`Use this template`][apisix-plugin-use-template] button

[Back to TOC](#table-of-contents)

### Plugin template structure
```
.
├── .github/         GitHub Actions workflows and Dependabot configuration files
├── apisix           All files in this folder will be copied and overwrite the original APISIX
│   └── plugins/     APISIX plugin source
├── ci               All files in this folder will be copied and overwrite the original APISIX
│   └── utils/       CI utils script folder
├── t/               Test case folder
├── LICENSE
├── Makefile
└── README.md        README
```
[Back to TOC](#table-of-contents)

### Testing
[Testing plugins][apisix-testing-framework] is an essential part of the plugin development to make sure that everything works as expected.

#### Continuous integration
[Continuous integration][continuous-integration] (CI) depends on [GitHub Actions][github-actions], a set of workflows that make it possible to automate your testing process.
Thanks to such automation, you can delegate the testing and verification phases to the CI and instead focus on development (and writing more tests).

In the `.github/workflows` directory, you can find definitions for the following GitHub Actions workflows:

- [CI](.github/workflows/ci.yml)
  - Triggered on `push` and `pull_request` events.
  - Run test case in [`t`](t) folder

### Useful links
- [Getting started with GitHub Public Template][github-public-template]
- [What is APISIX Plugin][apisix-plugin]
- [APISIX Architecture Design][apisix-architecture-design]
- [APISIX Plugin Deveolpment][apisix-plugin-develop]
- [APISIX Code Style][apisix-code-style]
- [APISIX Debug Mode][apisix-debug-mode]
- [APISIX Testing Framework][apisix-testing-framework]
- [GitHub Actions][github-actions]

[Back to TOC](#table-of-contents)

[badge-action-url]: https://github.com/api7/apisix-plugin-template/actions
[badge-action-img]: https://github.com/api7/apisix-plugin-template/actions/workflows/ci.yml/badge.svg

[apisix]: https://github.com/apache/apisix
[apisix-architecture-design]: https://apisix.apache.org/docs/apisix/architecture-design/apisix
[apisix-code-style]: https://github.com/apache/apisix/blob/master/CODE_STYLE.md
[apisix-debug-mode]: https://apisix.apache.org/docs/apisix/architecture-design/debug-mode
[apisix-plugin]: https://apisix.apache.org/docs/apisix/architecture-design/plugin
[apisix-plugin-develop]: https://apisix.apache.org/docs/apisix/plugin-develop
[apisix-plugin-use-template]: https://github.com/api7/apisix-plugin-template/generate
[apisix-testing-framework]: https://apisix.apache.org/docs/apisix/internal/testing-framework

[continuous-integration]: https://en.wikipedia.org/wiki/Continuous_integration

[github-actions]: https://help.github.com/en/actions
[github-public-template]: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template
