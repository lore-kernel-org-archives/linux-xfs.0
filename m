Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6L7XIiE147072 for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 02:33:19 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DFAB37597C
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 00:34:01 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[83.64.48.195]) by cuda.sgi.com with ESMTP id EQVB8RIgSZJj2IQc
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 00:34:01 -0700 (PDT)
Message-ID: <4A656F65.3090606@dermichi.com>
Date: Tue, 21 Jul 2009 09:33:57 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: patch 2.6.30 and 2.6.30.1 xfs/nfs oops fix, radix tree
References: <20090721012455.GG3229@rlogin.dk>
In-Reply-To: <20090721012455.GG3229@rlogin.dk>
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
To: Michael Ole Olsen <gnu@gmx.net>
Cc: xfs <xfs@oss.sgi.com>

Hi!
> Eric has been very helpful in helping me downgrade xfs in 2.6.30.1 to 2.6.28.7
> version (getting 2.6.28.7 to compile in 2.6.30.1) which removed the oopses.
Thank you for posting this patch. I have a few production boxes too which i needed to downgrade back to 2.6.28 because of the "radix tree oops" problem. Will try if the patch fixes my problems in 2.6.30 too and report back here.

kind regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
