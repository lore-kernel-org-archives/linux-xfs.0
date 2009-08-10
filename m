Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AMtqCL087595 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 17:56:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8004B146DA86
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 15:56:28 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id IEfaYDX0Ky9WtEUL for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 15:56:28 -0700 (PDT)
Message-ID: <4A80A597.6050806@sandeen.net>
Date: Mon, 10 Aug 2009 17:56:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Best design docs for XFS
References: <4A808FC7.2020800@jquigley.com>
In-Reply-To: <4A808FC7.2020800@jquigley.com>
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
To: John Quigley <jquigley@jquigley.com>
Cc: XFS Development <xfs@oss.sgi.com>

John Quigley wrote:
> Hey Folks:
> 
> What are the best and most current technical design documents
> pertaining to (Linux port of) XFS, as a companion to reading the
> actual code?  Based upon what I've read on the community site:
> 
> http://xfs.org/index.php/XFS_Papers_and_Documentation
> 
> the most thorough technical documentation of the system lives at:
> 
> http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/
> 
> My only concern with the above is the age - are these sufficiently
> up-to-date from an architecture perspective?  Thanks very much.

It's pretty good still, the fundamental design is not substantially
changed; you're more likely to find missing bits than "wrong" bits I think.

http://oss.sgi.com/projects/xfs/training/index.html

has more info as well.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
