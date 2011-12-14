Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEIRqV4222972 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 12:27:53 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B1904D9431
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 10:27:51 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qrsdkpelxO6cznkF for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 10:27:51 -0800 (PST)
Date: Wed, 14 Dec 2011 10:27:50 -0800
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: xfs-trace-ilock-more
Message-ID: <20111214182750.GH11114@wotan.suse.de>
References: <20111214024040.GA17780@infradead.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111214024040.GA17780@infradead.org>
Reply-To: Mark Fasheh <mfasheh@suse.de>
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
Cc: Jeff Mahoney <jeffm@suse.com>, xfs@oss.sgi.com

Hey Christoph,

On Tue, Dec 13, 2011 at 09:40:40PM -0500, Christoph Hellwig wrote:
> Can you explain the story behid this patch in SLES11SP1?

We were looking at some performance issues and needed a bit more information
on the amount of time spent in ilock. I can give you more specifics if you
want, I just have to dig up the e-mails (it's been a while).

Regards, Mark

--
Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
