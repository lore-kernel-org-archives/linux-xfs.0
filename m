Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M4EsOq043187
	for <linux-xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:14:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C9AF14F99EC
	for <linux-xfs@oss.sgi.com>; Tue, 21 Sep 2010 21:28:14 -0700 (PDT)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id 5A5NVbSlBR6oBdcp for
	<linux-xfs@oss.sgi.com>; Tue, 21 Sep 2010 21:28:14 -0700 (PDT)
Message-ID: <4C9982F0.6010902@sandeen.net>
Date: Tue, 21 Sep 2010 23:15:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: System partially unusable after power loss...
References: <i6ttq6$41d$1@dough.gmane.org> <4C928424.1020409@sandeen.net>
	<i7b8ao$erp$1@dough.gmane.org>
In-Reply-To: <i7b8ao$erp$1@dough.gmane.org>
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
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-xfs@oss.sgi.com

Manuel Reimer wrote:

> But why did xfs_repair restore files... For me it seems like xfs_repair
> restored an *old* version of openssl, which has been replaced by the
> system update process. This would mean: xfs_repair made a deleted file
> visible. Is this possible?

I don't know what to make of that; if you mean the openssl files got replaced
by older versions, it sounds very unlikely.

Sadly without repair output I can't say what repair did, but resurrecting
overwritten files from the past would be unexpected to say the least...

-Eric
 
> Yours
> 
> Manuel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
