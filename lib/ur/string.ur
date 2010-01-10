type t = Basis.string

val str = Basis.str1

val length = Basis.strlen
val append = Basis.strcat

val sub = Basis.strsub
val suffix = Basis.strsuffix

val index = Basis.strindex
val atFirst = Basis.strchr

fun mindex {Haystack = s, Needle = chs} = Basis.strcspn s chs

fun substring s {Start = start, Len = len} = Basis.substring s start len

fun split s ch =
    case index s ch of
        None => None
      | Some i => Some (substring s {Start = 0, Len = i},
                        substring s {Start = i + 1, Len = length s - i - 1})
fun msplit {Haystack = s, Needle = chs} =
    case mindex {Haystack = s, Needle = chs} of
        None => None
      | Some i => Some (substring s {Start = 0, Len = i},
                        sub s i,
                        substring s {Start = i + 1, Len = length s - i - 1})

fun all f s =
    let
        val len = length s

        fun al i =
            i >= len
            || (f (sub s i) && al (i + 1))
    in
        al 0
    end

fun newlines [ctx] [[Body] ~ ctx] s : xml ([Body] ++ ctx) [] [] =
    case split s #"\n" of
        None => cdata s
      | Some (s1, s2) => <xml>{[s1]}<br/>{newlines s2}</xml>
