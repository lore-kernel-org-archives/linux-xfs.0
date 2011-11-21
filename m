Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAL6hAPB240581 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 00:43:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E55F2669D0
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 22:43:06 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	b79ubpNWTNyhuxSU for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 22:43:06 -0800 (PST)
Date: Mon, 21 Nov 2011 01:43:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 254: disable space cache
Message-ID: <20111121064300.GA10644@infradead.org>
References: <4EC61AC3.6010806@cn.fujitsu.com> <4EC9AD92.6020000@jp.fujitsu.com>
	<4EC9BA7C.20907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EC9BA7C.20907@cn.fujitsu.com>
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
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Nov 21, 2011 at 10:42:04AM +0800, Li Zefan wrote:
> This is an alternative fix:

I have already applied your previous one.  Can you rediff it ontop of
the current xfstests-dev tree?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
