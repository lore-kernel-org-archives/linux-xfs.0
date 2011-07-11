Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6B43D4N172460
	for <linux-xfs@oss.sgi.com>; Sun, 10 Jul 2011 23:03:17 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4605517AA7F0
	for <linux-xfs@oss.sgi.com>; Sun, 10 Jul 2011 21:03:12 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id 3qwZQNtfCFSuuHn0 for <linux-xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 21:03:12 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Qg7iA-00067v-OV
	for linux-xfs@oss.sgi.com; Mon, 11 Jul 2011 06:03:11 +0200
Received: from c-71-194-192-160.hsd1.il.comcast.net ([71.194.192.160])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 11 Jul 2011 06:03:10 +0200
Received: from brianmduncan by c-71-194-192-160.hsd1.il.comcast.net with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 11 Jul 2011 06:03:10 +0200
From: Brian Duncan <brianmduncan@gmail.com>
Subject: Re: xfssyncd and disk spin down
Date: Mon, 11 Jul 2011 04:02:59 +0000 (UTC)
Message-ID: <loom.20110711T055016-944@post.gmane.org>
References: <20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120234310.GV16267@dastard>
	<20110210204254.GA10451@peter.simplex.ro>
	<20110210221851.GG2559@dastard>
	<loom.20110214T185310-606@post.gmane.org>
	<loom.20110531T163459-953@post.gmane.org>
	<4DE5064D.1010203@dermichi.com> <20110601233702.GJ561@dastard>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Thanks Dave for the confirmation that this was patched.

Can anyone confirm that this patch is working within 2.6.39?

The post above Dave's last says the bug is still present in 2.6.39 from their
own testing.. but I see in the changelog for 2.6.39 that Dave's patch/commit ID
is listed as being part of that Kernel update.  

http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.39

Thanks




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
