# AGENTS.md

Guidance for AI agents (and new contributors) working on this Puppet module.

## What this is

A Puppet module managing Vim: the packages, root's `.vimrc` and the `.vim`
directory with a few syntax files. It runs on the OpenVox / Vox Pupuli
ecosystem, not Puppet Labs / Perforce tooling.

## Toolchain rules

- Use OpenVox and Vox Pupuli tooling, never the Puppet Labs equivalents:
  the `openvox` gem (selected via `OPENVOX_GEM_VERSION`), `openfact`,
  `voxpupuli-test`, `voxpupuli-acceptance`, `voxpupuli-rubocop`,
  `openvox-strings`, `beaker_puppet_helpers`. The `puppet` and `facter`
  gems must never appear in `Gemfile.lock`.
- PDK is not used. Do not suggest `pdk update` or pdk-templates.
- Acceptance tests install `openvox-agent` from the Vox Pupuli repositories
  (`BEAKER_PUPPET_COLLECTION`, openvox8 or openvox9) into Docker containers
  defined by `spec/acceptance/nodesets/*.yml`.

## Commands

```sh
bundle install
bundle exec rake parallel_spec        # full unit suite
bundle exec rake check:git_ignore check:dot_underscore check:test_file \
  rubocop syntax lint metadata_lint   # the CI validate chain
BEAKER_set=el9 bundle exec rake beaker  # acceptance for one nodeset (needs Docker)
```

To try vim by hand on a host that has the module applied, keep the beaker
container after the run and exec into it (nodesets name the container
`vim-<set>`):

```sh
BEAKER_destroy=no BEAKER_set=el10 BEAKER_PUPPET_COLLECTION=openvox9 bundle exec rake beaker
docker exec -it vim-el10 bash   # module is under /etc/puppetlabs/code/environments/production/modules/vim
docker rm -f vim-el10           # stop and remove it when done
```

Use the same Ruby version CI uses; see `ruby-version` in
`.github/workflows/ci.yaml` (the OpenVox 9 jobs run Ruby 4.0, matching the
Ruby bundled with openvox-agent 9). RVM is the suggested way to install and
manage it. A UTF-8 locale is required: `export LC_ALL=en_US.UTF-8` or
`metadata_lint` fails with an encoding error.

## Conventions

- **`data/` holds vanilla distribution package names only**: the vim
  packages a basic install of that OS family provides, verified against the
  real distribution container (the image named in the platform's nodeset),
  never a contributor's customized settings. Users layer their own choices
  on top via parameters and Hiera.
- **`data/os/` is permanent.** Package data for end of life platforms is
  deliberately kept, even after the platform leaves `metadata.json` and the
  test matrix, so users on those platforms keep working. Never delete files
  under `data/`.
- **Platform support tiers**: an OS listed in `metadata.json` *with* an
  `operatingsystemrelease` array is actively supported and tested (the spec
  matrix is built from it by `on_supported_os`). An OS listed *without*
  versions (Solaris) is known-to-work only: its data remains but nothing
  tests it. Platforms that only have `data/` entries (Suse) are likewise
  untested.
- **`files/vim/` carries only what Vim 9 does not ship.** Vim 8 is not
  supported. Vim 9 detects `*.pp`, `*.epp`, `*.md` and Vagrantfile itself
  and ships markdown syntax/ftplugin and `macros/less.vim`, so the module
  only bundles the Puppet and EPP files from rodjek/vim-puppet. Do not add
  files that duplicate the Vim runtime; a copy in `~/.vim` shadows the
  newer one Vim provides. `files/vim/README` records the upstream commit.
- **RuboCop**: config is inherited from the `voxpupuli-rubocop` gem;
  pre-existing offenses are grandfathered in `.rubocop_todo.yml`. Never run
  mass autocorrects over existing code; style churn destroys git history and
  breaks open pull requests. New code must comply.
- **100% resource coverage is enforced** (`RSpec::Puppet::Coverage.report!(100)`).
  Every resource in any compiled catalog must be touched by an assertion.
- Pull requests are typically a single commit; amend rather than stacking
  fixup commits. Preserve original authorship when rebasing contributor
  commits and add co-authors via `Co-Authored-By` trailers.
- `voxpupuli-test` and `voxpupuli-rubocop` versions are pinned in lockstep
  (both pin the same rubocop line); bump them together.
- **ASCII only.** Never use em dashes, smart quotes, or other non-ASCII
  characters in any file in this repo; use plain ASCII punctuation instead.
  Multibyte strings in spec/ used as test input vectors are deliberate test
  data that verifies unicode handling, and must be kept.

## Updating the bundled vim files

`files/vim/` is a verbatim subset of https://github.com/rodjek/vim-puppet
(the `voxpupuli/vim-puppet` fork named in the syntax header is stale).
To refresh it:

1. Clone the upstream repo and note `git rev-parse HEAD` and the commit date.
2. Copy exactly the files listed in `files/vim/README` over the existing
   ones, keeping the same relative paths. Do not add ftdetect, ctags,
   tagbar, gutentags, compiler or Lua files (see the README for why).
3. Check nothing new is required: `grep -rhoE 'puppet#[A-Za-z_#]+'
   files/vim` must only name functions defined under
   `files/vim/autoload/puppet/`.
4. Run `grep -rnP '[^\x00-\x7F]' files/vim`; the repo is ASCII only.
5. Smoke test with Vim 9 by opening a `.pp` and a `.epp` file with
   `vim -Nu NONE -i NONE --cmd "set rtp^=$PWD/files/vim"
   --cmd "set rtp+=$PWD/files/vim/after" -c 'filetype plugin indent on'
   -c 'syntax on'` and confirm `:set ft? indentexpr? formatexpr?` and
   `:messages` show no errors.
6. Update the Commit line in `files/vim/README` and run an acceptance
   nodeset so the recursive `root_vim_dir` copy is exercised.

## Gotchas

- If facterdb has no facts for a declared platform, `on_supported_os` yields
  nothing and that platform's tests are **silently skipped**. After adding or
  changing platforms, confirm the total example count went up and grep the
  spec output for "No facts were found".
- Local variables assigned only inside removed `when` branches cause
  `NameError` at spec load; check them when editing platform case statements.
- Verify a platform's vim package names against the real distribution
  container (the image named in its nodeset), not from memory.
- Solaris cannot be unit tested: rspec-puppet-facts hardcodes the Solaris
  hardware model to i86pc and facterdb only ships sun4v (SPARC) Solaris 11
  facts, so `on_supported_os` never yields it. That is why Solaris is listed
  without versions in `metadata.json`.
