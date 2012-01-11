Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BBhcsl162174 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 05:43:38 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wxeu9y4GccclYAtY for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 03:43:37 -0800 (PST)
Date: Wed, 11 Jan 2012 06:43:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
Message-ID: <20120111114335.GD14423@infradead.org>
References: <BAB94DBB0E89D8409949BC28AC95914C6875A2@USMAExch1.tad.internal.tilera.com>
	<CAB4K4y7SmGKG1yVvxu5jSberYS8ayYiGHOGe81CNZHmOHi7ssg@mail.gmail.com>
	<CAB4K4y5W0o8mJ2koKgEZtRRB4k=UNjr3Ha1zq_ic+0LjFw-LpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAB4K4y5W0o8mJ2koKgEZtRRB4k=UNjr3Ha1zq_ic+0LjFw-LpQ@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Tony Lu <zlu@tilera.com>, xfs@oss.sgi.com

On Mon, Jan 09, 2012 at 12:58:22PM +0530, Ajeet Yadav wrote:
> Yes I implemented these definitions for MIPS, without them this
> problem will continue to occur.

Btw, Linux 3.2 finally has a version of the helpers in mainline.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
