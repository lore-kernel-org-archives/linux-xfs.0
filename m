Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IHN80Z012432 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:23:08 -0600
In-Reply-To: <20090118170241.GA21181@infradead.org>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090118170241.GA21181@infradead.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <9305FAB6-0189-4F82-9E12-22656A7ABF9F@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH 0/7] Remaining 2.6.29 queue
Date: Sun, 18 Jan 2009 11:22:42 -0600
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
Cc: xfs@oss.sgi.com

Hi Christoph,

On Jan 18, 2009, at 11:02 AM, Christoph Hellwig wrote:

> On Fri, Jan 09, 2009 at 05:11:04PM -0500, Christoph Hellwig wrote:
>> These are my current outstanding patches for 2.6.29, consisting of
>> small enough fixes and lockdep annotations, and an early warning
>> for a attr corruption frequently seen on kerneloops.org.
>
> Can we please get these pushed out to Linus?  Thanks.

IIRC, Lachlan had problem applying your patches.
I'll check it myself and let you know where we're
here.

Felix


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
