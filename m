Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6AE077F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 09:25:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 472FF8F8052
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 07:25:11 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	G1kYUyCHgnzIs5j2 for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 07:25:09 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 5119B1F00462
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:25:09 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id QLrWd3NMDGjl for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 10:25:05 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 276551F0053F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:24:45 -0400 (EDT)
Date: Mon, 29 Jul 2013 10:24:45 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <4422459.2522.1375107885083.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <20130729024105.GC13468@dastard>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
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

> The "version" of XFS that you are running is that of the
> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.

Those aren't kernel versions; those are kernel *package* versions.

Kernel versions are w.x.y or w.x.y.z.

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
