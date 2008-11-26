Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQEk2Nk022897 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 08:46:02 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B1FD1BE49C3
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 06:46:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id nghFNOkCUcETexZW for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2008 06:46:00 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 86EDDAC6272
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 08:40:27 -0600 (CST)
Message-ID: <492D5FDB.3000208@sandeen.net>
Date: Wed, 26 Nov 2008 08:40:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch 00/12] [PATCH V2]: compat ioctl fixes/cleanups/additions
References: <20081126032005.639750968@sandeen.net>
In-Reply-To: <20081126032005.639750968@sandeen.net>
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
To: xfs@oss.sgi.com

sandeen@sandeen.net wrote:
> Latest installation, incorporating hch's comments.
> 
> Which is to say, a lot changed.  :)
> 
> -Eric

Just a note, Christoph reviewed & acked all these after I posted them.

The list ate the replies, it seems, so it'd be hard for anyone to know.
 At best they are delayed by 4 hours.

I checked the archives at
http://oss.sgi.com/archives/xfs/2008-11/index.html but even my original
thread is missing there (no email past Nov 24).

Same for here, http://oss.sgi.com/pipermail/xfs/2008-November/ ends on
Nov 12.  So it's hard to know if it made it anywhere.

Is the best practice now to cc: LKML or linux-fsdevel so that email is
more certain to be delivered to some endpoint?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
