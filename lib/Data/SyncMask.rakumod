use v6.d;

use DB::SQLite:ver<0.7>:auth<github:CurtTilmes>:api<1>;
use JSON::Fast;

class SyncMask {
    has $!mask;
    has $!db-name;
    has $!db-connection;
    has $!locale;

    submethod BUILD ( :$mask, :$db-name, :$locale = 'en-US' ){
        $!mask    = $mask;
        $!db-name = $db-name;
        $!db-connection = DB::SQLite.new(filename => $db-name, busy-timeout => 50000);
        $!locale  = $locale;
    }



}