Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9C1VemK009572 for <xfs@oss.sgi.com>; Sun, 11 Oct 2009 20:31:42 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8511DD6B8AC
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2009 18:33:08 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id DnelBlpBxHHKv4Qc for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2009 18:33:08 -0700 (PDT)
Date: Mon, 12 Oct 2009 03:33:06 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091012013306.GH1656@one.firstfloor.org>
References: <20091006184758.GA4780@infradead.org>
	<20091007044215.GK9464@discord.disaster>
	<87iqerymu0.fsf@basil.nowhere.org>
	<20091009023022.GL9464@discord.disaster>
	<20091010162428.GA22720@infradead.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091010162428.GA22720@infradead.org>
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
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

On Sat, Oct 10, 2009 at 12:24:28PM -0400, Christoph Hellwig wrote:
> So does any of these means a positive review for the full patch, or just
> philosophical discussions?

It was in principle positive, except for the request to add a option
to turn it off to handle Dave's prefill use case.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
