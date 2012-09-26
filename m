Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q6GZ0h165480 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 01:16:35 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EwnAjykd1G6uB8nL for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 23:17:52 -0700 (PDT)
Date: Wed, 26 Sep 2012 16:17:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair deleting realtime files.
Message-ID: <20120926061732.GI29154@dastard>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
	<CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
	<20120926024403.GH29154@dastard>
	<CAHt31__FPLsDdVCVwwLO0Sh9v_KK2pzU577nywFPAmf_C-gRcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHt31__FPLsDdVCVwwLO0Sh9v_KK2pzU577nywFPAmf_C-gRcQ@mail.gmail.com>
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
To: Anand Tiwari <tiwarikanand@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Sep 25, 2012 at 09:45:07PM -0600, Anand Tiwari wrote:
> thanks Dave for prompt reply, I meant to implement option 2 as you
> explained (option 3).  I will start working on it tomorrow. In the mean
> time, I also had  to put something in xfs_repair for the files which
> already exists on the disk. Would you guys willing to review/comment on
> that ?

Sure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
