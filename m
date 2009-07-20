Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KHu8x4099362
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 12:56:09 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24E4D3736CB
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 10:56:47 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 4CrKEZwkOE19fzi9 for <linux-xfs@oss.sgi.com>;
	Mon, 20 Jul 2009 10:56:47 -0700 (PDT)
Message-ID: <4A64AFD4.90407@sandeen.net>
Date: Mon, 20 Jul 2009 12:56:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] don't fail if nslookup is not found
References: <alpine.DEB.2.01.0907191050010.6439@bogon>	<20090719182012.GA10936@infradead.org>	<alpine.DEB.2.01.0907191653240.6439@bogon>	<20090720001637.GA31674@infradead.org>	<alpine.DEB.2.01.0907191840150.6439@bogon>	<20090720093240.GA24549@infradead.org>
	<alpine.DEB.2.01.0907201000510.6439@bogon>
In-Reply-To: <alpine.DEB.2.01.0907201000510.6439@bogon>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

Christian Kujau wrote:
> On Mon, 20 Jul 2009 at 05:32, Christoph Hellwig wrote:
>> Thanks, I've put the patch in and pushed it to the kernel.org
>> repository.
> 
> Thanks, Christoph. This reminds me to ask: why is there also a kernel.org 
> repo, when there's one on oss.sgi.com too? (The latter being referenced in 
> the XFS wiki)

outsiders can't commit to sgi's git repo, so those doing active
development can commit to the one on kernel.org, and then sgi
periodically pulls those in to oss.sgi.com.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
