Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KH38dB097091
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 12:03:08 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33C95373148
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 10:03:49 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	olpKdijgB88LkarR for <linux-xfs@oss.sgi.com>;
	Mon, 20 Jul 2009 10:03:49 -0700 (PDT)
Date: Mon, 20 Jul 2009 10:03:37 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH] don't fail if nslookup is not found (was: xfstests:
	nslookup not found)
In-Reply-To: <20090720093240.GA24549@infradead.org>
Message-ID: <alpine.DEB.2.01.0907201000510.6439@bogon>
References: <alpine.DEB.2.01.0907191050010.6439@bogon>
	<20090719182012.GA10936@infradead.org>
	<alpine.DEB.2.01.0907191653240.6439@bogon>
	<20090720001637.GA31674@infradead.org>
	<alpine.DEB.2.01.0907191840150.6439@bogon>
	<20090720093240.GA24549@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com

On Mon, 20 Jul 2009 at 05:32, Christoph Hellwig wrote:
> Thanks, I've put the patch in and pushed it to the kernel.org
> repository.

Thanks, Christoph. This reminds me to ask: why is there also a kernel.org 
repo, when there's one on oss.sgi.com too? (The latter being referenced in 
the XFS wiki)

Christian.
-- 
BOFH excuse #9:

doppler effect

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
