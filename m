Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 063567F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 23:41:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86C0BAC004
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 21:41:17 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	6FCtyKJuaienFZAE for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 21:41:15 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 4E7F71F00575
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 00:41:15 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 0Z8trqiGhO+N for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 00:41:11 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 1080D1F0057C
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 00:41:11 -0400 (EDT)
Date: Mon, 15 Jul 2013 00:41:11 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <20537712.1400.1373863270994.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <20130715000748.GD5228@dastard>
Subject: Re: XFS filesystem triggering assert in _repair 3.1.11
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>

> > > xfs_db> type bmapbt
> >
> > Well, the manpage says that's a type, but my xfs_db, v 3.1.11, says
> > it's not. Huh?
> 
> bmapbtd. "d" mens data fork. bmapbta is for the attribute fork....

Oddly, the manpage I was looking at listed just the one, without the suffixes.

> > I hate power supplies.
> 
> I'd be spending a few dollars to get a new one ;)

The old one was a $100 Antec 650 that lasted nearly 7 solid years; I'm
not feeling too badly about it.  It's been replaced by a Corsair; we'll see
how that plays in Peoria.

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
