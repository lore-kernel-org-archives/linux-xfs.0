Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTB8E2o030517 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 05:08:14 -0600
Received: from pih-relay04.plus.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A97AE4E525
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:08:13 -0800 (PST)
Received: from pih-relay04.plus.net (pih-relay04.plus.net [212.159.14.17]) by
	cuda.sgi.com with ESMTP id wqVrDCaWrSHa0cbd for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:08:13 -0800 (PST)
Message-ID: <4958AF9E.7070005@yahoo.com>
Date: Mon, 29 Dec 2008 11:08:14 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
MIME-Version: 1.0
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest
	stable version of the Linux kernel is".
References: <fa.AyhwSGaa29qThLZ5OhBSbACDzmI@ifi.uio.no>
	<fa.O2INIKnSvQY5+2WFbCRxoh8xutg@ifi.uio.no>
	<fa.fGgFQweuOQlZ5w9soKo4267nPkc@ifi.uio.no>
In-Reply-To: <fa.fGgFQweuOQlZ5w9soKo4267nPkc@ifi.uio.no>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: for.poige+linux@gmail.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Igor Podlesny wrote:
> 	Yeah, I'll try to get backtraces, using null-modem cable, but alas, I

Have you tried compiling your kernel with extended checks 
(CONFIG_DEBUG_KERNEL in the Kernel hacking menu)? There are debug 
poisoning options too. Sometimes this can flush out problems before they 
become fatal...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
