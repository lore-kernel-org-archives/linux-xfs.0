Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BEYR25227639 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 09:34:27 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A0B95D2D3
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 07:34:25 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id AQPaj13AVEZTxnIl
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 07:34:25 -0700 (PDT)
Received: from dermichi-2-pt.tunnel.tserv23.zrh1.ipv6.he.net
	([2001:470:25:4f4::2])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76) (envelope-from <mw@dermichi.com>) id 1QgHZ2-0006ov-Hk
	for xfs@oss.sgi.com; Mon, 11 Jul 2011 16:34:24 +0200
Message-ID: <4E1B09EF.4010308@dermichi.com>
Date: Mon, 11 Jul 2011 16:34:23 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101227140750.GB24828@dastard>	<20101227171939.GA7759@pandora.simplex.ro>	<20101231001323.GD15179@dastard>	<20110120100143.GA2007@peter.simplex.ro>	<20110120234310.GV16267@dastard>	<20110210204254.GA10451@peter.simplex.ro>	<20110210221851.GG2559@dastard>	<loom.20110214T185310-606@post.gmane.org>	<loom.20110531T163459-953@post.gmane.org>	<4DE5064D.1010203@dermichi.com>
	<20110601233702.GJ561@dastard>
	<loom.20110711T055016-944@post.gmane.org>
In-Reply-To: <loom.20110711T055016-944@post.gmane.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Brian!
> Thanks Dave for the confirmation that this was patched.
> 
> Can anyone confirm that this patch is working within 2.6.39?
> 
> The post above Dave's last says the bug is still present in 2.6.39 from their
> own testing.. but I see in the changelog for 2.6.39 that Dave's patch/commit ID
> is listed as being part of that Kernel update.  
> 
> http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.39
> 
I can confirm that it works without problems on 2.6.39 - you can dismiss
my previous post.

hth,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
