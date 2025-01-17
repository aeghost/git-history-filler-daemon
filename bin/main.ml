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

let content_generator out =
  Random.self_init ();
  let sz = Random.int 1000 in
  let b = Buffer.(create 1024) in
  let bf = Fmt.with_buffer b in
  (for _ = 0 to Random.int 100 do
     Fmt.pf bf "@.%s" String.(make sz '%')
   done);
  (try Path.rmtree (changes_folder out) with _ -> ());
  Path.mkdir ~perm:0o776 (changes_folder out);
  Path.(save ~create:(`If_missing 0o644)) (changes_folder out |> file) Buffer.(contents b)

let main env =
  let out = Eio.Stdenv.cwd env in
  content_generator out

let () = Eio_main.run main

