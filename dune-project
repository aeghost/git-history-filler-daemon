(lang dune 3.17)

(name filler)

(generate_opam_files true)

(source
 (github aeghost/git-history-filler-daemon))

(authors "Matthieu GOSSET <matthieu.gosset.dev@outlook.com>")

(maintainers "Matthieu GOSSET <matthieu.gosset.dev@outlook.com>")

(license MIT)

(documentation https://github.com/aeghost/git-history-filler-daemon)

(package
 (name filler)
 (synopsis "Artificially fill github/gitlab/... history at random")
 (description
  "Some company looks for git history of patch, now I want to make it irrelevant")
 (depends ocaml)
 (tags
  ("fake" "bad" filler)))
