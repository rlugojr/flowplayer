/*!
 Flowplayer : The Video Player for Web

 Copyright (c) 2012 - 2014 Flowplayer Ltd
 http://flowplayer.org

 Author: Anssi Piirainen

 -----

 This GPL version includes Flowplayer branding

 http://flowplayer.org/GPL-license/#term-7

 Commercial versions are available
 * part of the upgrade cycle
 * support the player development
 * no Flowplayer trademark

 http://flowplayer.org/pricing/
 */
package {
    import flash.net.NetConnection;

    public class SubscribingConnector implements Connector {
        private var connector:ParallelConnector;
        private var url:String;
        private var player:Flowplayer;

        public function SubscribingConnector(player:Flowplayer, url:String) {
            this.player = player;
            this.url = url;
            this.connector = new ParallelConnector(player, url);
        }


        public function connect(connectedCallback:Function, disconnectedCallback:Function):void {

            connector.connect(function (conn:NetConnection):void {

                // listener for successful FCSubscribe
                conn.client = {
                    onFCSubscribe: function (info:Object):void {

                        player.debug("FCSubscribe successful, connection established");
                        connectedCallback(conn);
                    }
                };

                player.debug("Calling FCSubscribe");
                conn.call("FCSubscribe", null, url);

            }, disconnectedCallback);
        }

        public function close():void {
            connector.close();
        }
    }
}