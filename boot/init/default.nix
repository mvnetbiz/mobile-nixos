{ fetchurl
, mruby
, mrbgems

# Additional tasks
, tasks ? []
}:

let
  ruby_rev = "37457117c941b700b150d76879318c429599d83f";
  shellwords = fetchurl {
    name = "shellwords.rb";
    url = "https://raw.githubusercontent.com/ruby/ruby/${ruby_rev}/lib/shellwords.rb";
    sha256 = "197g7qvrrijmajixa2h9c4jw26l36y8ig6qjb5d43qg4qykhqfcx";
  };
in
mruby.builder {
  pname = "mobile-nixos-init";
  version = "0.1.0";

  src = ./.;

  postPatch = ''
    cp ${shellwords} lib/0001_shellwords.rb
  '';

  # Sorting ensures a stable lexicographic import order.
  # Otherwise the compiler could accidentally be flaky.
  buildPhase = ''
    get_tasks() {
      for s in $tasks; do
        find $s -type f -iname '*.rb'
      done | sort
    }

    makeBin init \
      $(find lib -type f | sort) \
      $(get_tasks) \
      main.rb
  '';

  tasks = [
    "./tasks"
  ] ++ tasks;

  gems = with mrbgems; [
    { core = "mruby-exit"; }
    { core = "mruby-io"; }
    { core = "mruby-sleep"; }
    mruby-dir
    mruby-dir-glob
    mruby-env
    mruby-json
    mruby-logger
    mruby-open3
    mruby-regexp-pcre
    mruby-singleton
  ];
}
