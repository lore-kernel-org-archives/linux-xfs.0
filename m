Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALN85ml021548 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 17:08:06 -0600
Message-ID: <49273F36.7040302@sgi.com>
Date: Sat, 22 Nov 2008 10:07:34 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: Announce: XFS staging tree
References: <20081121212030.GA17816@infradead.org>
In-Reply-To: <20081121212030.GA17816@infradead.org>
Reply-To: markgw@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, xfs@oss.sgi.com



Christoph Hellwig wrote:
> I've created a new tree of all patches that have been reviewed, and
> properly QAed but haven't been merged into the SGI tree for reasons
> unknown to us patch submitters.

Lachlan has about 30 patches almost ready to push back out (mostly yours
Christoph). Sorry for the delays and the frustration this is causing. Just
waiting for some back-end constipation with ptools to resolve, which will
happen early next week.

> I'll add all patches that have gotten review on linux-xfs to it after
> they pass xfsqa for me.   Patches will be dropped as soon as they get
> into the xfs git tree.

On-going, this might be a better way to manage the patch queue, at least
possibly better in terms of front-line QA. Maybe an almost-open-access
git repository for incomming patches could work too. What do others think?

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
