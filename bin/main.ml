(** [GITHUB FILLER DAEMON]
    @copyright (C) 2024 ChapsVision -- ALL RIGHTS RESERVED.
    @author Matthieu GOSSET
    @maintainers
      Matthieu GOSSET <mgosset@chapsvision.com>
      Vincent DROUIN <vdrouin@chapsvision.com>
      Olivier TOURDES <otourdes@chapsvision.com>
    @purpose
      Stupid daemon to fill my github history artificially, at least as often as my gitlab
*)
open Eio

let changes_folder dir = Path.(dir / "process")
let file dir = Path.(dir / "content")

let content_generator env =
  let out = Eio.Stdenv.cwd env in
  let sz = Random.int 1000 in
  let b = Buffer.(create 1024) in
  let bf = Fmt.with_buffer b in
  (for _ = 0 to Random.int 100 do
     Fmt.pf bf "@.%s" String.(make sz '%')
   done);
  (try Path.rmtree (changes_folder out) with _ -> ());
  Path.mkdir ~perm:0o776 (changes_folder out);
  Path.(save ~create:(`If_missing 0o644)) (changes_folder out |> file) Buffer.(contents b)

let run ?(silent = true) env cmd =
  let output = Buffer.create 1024 in
  let stderr = Buffer.create 1024 in
  Process.run
    ~stdout:(Flow.(buffer_sink output))
    ~stderr:(Flow.(buffer_sink stderr))
    ~cwd:(Stdenv.cwd env)
    Stdenv.(process_mgr env)
    cmd;
  if not silent then Fmt.pr "@.Running: %a@.Out: %a@.Err: %a@." Fmt.(list ~sep:(any " ") string) cmd Fmt.buffer output Fmt.buffer stderr;
  Buffer.contents output

let git_commit env =
  let _ = run env ["git"; "add"; "process/content"] in
  let fortune = run env ["fortune";] in
  let _ = run env ["git"; "commit"; "-m"; fortune] in
  ()

let git_push env =
  let _ = run ~silent:false env ["git"; "push"; "origin"; "HEAD:next/main"] in
  ()

let git_rm_branch env =
  let _ = run ~silent:false env ["git"; "push"; "origin"; ":next/main"] in
  ()

let main env =
  while true do
    content_generator env;
    git_commit env;
    git_push env;
    Unix.sleep (Random.(int 100) + 100)
  done;
  git_rm_branch env

let () =
  Random.self_init ();
  Eio_main.run main

