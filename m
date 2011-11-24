Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAOCr1Rv019571
	for <linux-xfs@oss.sgi.com>; Thu, 24 Nov 2011 06:53:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BD0D16DEAA8
	for <linux-xfs@oss.sgi.com>; Thu, 24 Nov 2011 04:52:55 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xrAY8wM3iFBRqZ3i for <linux-xfs@oss.sgi.com>;
	Thu, 24 Nov 2011 04:52:55 -0800 (PST)
Date: Thu, 24 Nov 2011 07:52:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: validate inode numbers in file handles correctly
Message-ID: <20111124125253.GA26183@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<loom.20111123T134243-580@post.gmane.org>
	<20111123143045.GA20892@infradead.org>
	<SNT135-W7F5C64C2A3F67B48EFF3AA4CE0@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SNT135-W7F5C64C2A3F67B48EFF3AA4CE0@phx.gbl>
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
To: yangguoquan <ygq51@hotmail.com>
Cc: hch@infradead.org, linux-xfs@oss.sgi.com, pengxihan@gmail.com

On Thu, Nov 24, 2011 at 06:29:18PM +0800, yangguoquan wrote:
> 
> I have checked that Linux2.6.35.6 is up-to-date with the issue "xfs: fix untrusted inode number lookup"(you had mentioned in the former reply).
> What can I do.
> Look forward to your reply.

Can you please try a recent kernel (3.0-stable or 3.1)?  2.6.35 is so
old that we can't easily support it except for looking over the
list of commits.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
