Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA5BM4kY087338 for <xfs@oss.sgi.com>; Thu, 5 Nov 2009 05:22:05 -0600
Received: from mail.in-medias-res.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D022122E62F
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2009 03:22:17 -0800 (PST)
Received: from mail.in-medias-res.com (mail.in-medias-res.com [78.47.10.114])
	by cuda.sgi.com with ESMTP id 39RM7gICycAru5WY for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2009 03:22:17 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mail.in-medias-res.com (Postfix) with ESMTP id 2301224439F
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2009 12:22:17 +0100 (CET)
Received: from mail.in-medias-res.com ([127.0.0.1])
	by localhost (imr-web.in-medias-res.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 87jXyGTI5j5Z for <xfs@oss.sgi.com>;
	Thu,  5 Nov 2009 12:22:15 +0100 (CET)
Received: from imr-mail.services.in-medias-res.com
	(port-212-202-160-2.static.qsc.de [212.202.160.2])
	by mail.in-medias-res.com (Postfix) with ESMTP id AD3AB2071A1
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2009 12:22:15 +0100 (CET)
Received: from mytux.intra.in-medias-res.com ([192.168.2.128])
	by imr-mail.services.in-medias-res.com with esmtp (Exim 4.69)
	(envelope-from <mill@in-medias-res.com>) id 1N60Pv-0007Y7-Ib
	for xfs@oss.sgi.com; Thu, 05 Nov 2009 12:22:15 +0100
Date: Thu, 5 Nov 2009 12:22:15 +0100
From: mill / in-medias-res <mill@in-medias-res.com>
Subject: Re: xfs_repair breaks; xfs_metadump hangs
Message-ID: <20091105112215.GA3469@mytux.intra.in-medias-res.com>
MIME-Version: 1.0
Content-Disposition: inline
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

On Mittwoch 04 November 2009 mill / in-medias-res wrote:
> a RAID-5 Array which "was broken"
>
> Sounds like you fucked up the filesys very hard, I hope the devs can 
> help you. But there is information missing:
> - how big is sdc2?
The Partition is 2000GB with about 1400 GB used.

> - any chance you put it on a ftp server for download? Because if there's 
> no metadump, no one can tell where metadump hangs, so they'd need your 
> data to analyze.
Too big to upload and the data is too sensitive :(

FYI: im now subscribed to the list.


> Good luck.
Thanks,
Max

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
