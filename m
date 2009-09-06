Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8643wUX110174 for <xfs@oss.sgi.com>; Sat, 5 Sep 2009 23:04:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38AE142DB2B
	for <xfs@oss.sgi.com>; Sat,  5 Sep 2009 21:04:28 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id XAV9x1Ty4yuYFy5H for
	<xfs@oss.sgi.com>; Sat, 05 Sep 2009 21:04:28 -0700 (PDT)
Message-ID: <4AA334AA.9050908@sandeen.net>
Date: Sat, 05 Sep 2009 23:03:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: reservation ran out?
References: <20090905161102.GQ22496@outrider>
In-Reply-To: <20090905161102.GQ22496@outrider>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gavin Peters <gpeters@deepsky.com>
Cc: xfs@oss.sgi.com

Gavin Peters wrote:
> I just created bug 849, about a reservation problem I'm seeing
> on my x86_64 system on ubuntu jaunty (2.6.28-15-generic).
> 
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=849
> 
> Am I doin' something wrong, or is this a real problem?

Sounds like a real problem.

Any reproducible testcase?

-Eric

> - Gavin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
