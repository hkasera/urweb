table channels : { Client : client, Channel : channel (string * int * float) }
  PRIMARY KEY Client

fun writeBack v =
    me <- self;
    r <- oneRow (SELECT channels.Channel FROM channels WHERE channels.Client = {[me]});
    send r.Channels.Channel v

fun main () =
    me <- self;
    ch <- channel;
    dml (INSERT INTO channels (Client, Channel) VALUES ({[me]}, {[ch]}));
    
    buf <- Buffer.create;

    let
        fun receiverA () =
            v <- recv ch;
            Buffer.write buf ("A:(" ^ v.1 ^ ", " ^ show v.2 ^ ", " ^ show v.3 ^ ")");
            receiverA ()

        fun receiverB () =
            v <- recv ch;
            Buffer.write buf ("B:(" ^ v.1 ^ ", " ^ show v.2 ^ ", " ^ show v.3 ^ ")");
            error <xml>Bail out!</xml>;
            receiverB ()

        fun sender s n f =
            sleep 9;
            writeBack (s, n, f);
            sender (s ^ "!") (n + 1) (f + 1.23)
    in
        return <xml><body onload={spawn (receiverA ()); spawn (receiverB ()); sender "" 0 0.0}>
          <dyn signal={Buffer.render buf}/>
        </body></xml>
    end
