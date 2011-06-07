Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57CwbFs025077 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 07:58:38 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA2551664109
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 05:58:35 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id U9jxHLv7WHOs9KBG
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2011 05:58:35 -0700 (PDT)
Message-ID: <4DEE2078.3010102@profihost.ag>
Date: Tue, 07 Jun 2011 14:58:32 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS: accounting of reclaimable inodes is incorrect
References: <4DEE0EA4.9090002@profihost.ag>
	<20110607115441.GA4653@infradead.org>
In-Reply-To: <20110607115441.GA4653@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

>> it seems that a bug was backported into the latest 2.6.32 longterm
>> stable kernel. Now the patch "XFS: accounting of reclaimable inodes
>> is incorrect" needs to get backported to 2.6.32.
>>
>> Who can help? Who is responsible?
>
> For -stable releases no one really is.  If you want to help you can
> backport it and send it to the stable mailinglist.
Sorry i can't. I'm not a kernel hacker. But i think a real bug / 
showstopper should be fixed in a longterm stable kernel.

Redhat seems to have fixed it on it's own:
https://bugzilla.redhat.com/show_bug.cgi?id=642680

Sadly they haven't provided a patch.

Greets Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
