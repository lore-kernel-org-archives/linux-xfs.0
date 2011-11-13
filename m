Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pADBqUlU109876
	for <linux-xfs@oss.sgi.com>; Sun, 13 Nov 2011 05:52:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 160481E99B09
	for <linux-xfs@oss.sgi.com>; Sun, 13 Nov 2011 03:52:26 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	slNPL2unBpS575Bb for <linux-xfs@oss.sgi.com>;
	Sun, 13 Nov 2011 03:52:26 -0800 (PST)
Date: Sun, 13 Nov 2011 06:52:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests/071 FAIL with XFS Assertion
Message-ID: <20111113115223.GA19435@infradead.org>
References: <4EBCC112.3020108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EBCC112.3020108@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-xfs@oss.sgi.com

On Fri, Nov 11, 2011 at 02:30:42PM +0800, Wanlong Gao wrote:
> v3.1.0-10325-g3155521

Hmm, this a is a test not run in the auto group.  Do you have tested
it on older kernels where it works, aka do you know if this is a
regresion?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
