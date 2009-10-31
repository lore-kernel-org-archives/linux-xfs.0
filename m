Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9VEbKTZ080256 for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 09:37:20 -0500
Received: from mxout-08.mxes.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B02824FB80
	for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 07:37:32 -0700 (PDT)
Received: from mxout-08.mxes.net (mxout-08.mxes.net [216.86.168.183]) by
	cuda.sgi.com with ESMTP id lBfkgLxSwQX1QIh8 for
	<xfs@oss.sgi.com>; Sat, 31 Oct 2009 07:37:32 -0700 (PDT)
Message-ID: <4AEC4BAA.20606@aol.com>
Date: Sat, 31 Oct 2009 10:37:30 -0400
From: "AndrewL733@aol.com" <AndrewL733@aol.com>
MIME-Version: 1.0
Subject: Re: XFS and DPX files
References: <4AEC2CF4.8040703@aol.com> <20091031151825.46210b6a@galadriel.home>
In-Reply-To: <20091031151825.46210b6a@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


> Maybe  you should try mounting the XFS filesystem with these options :
> nobarrier,noatime
>
>   
Thanks.  Already doing that -- 3ware controller does not support 
barriers, so that's automatically ruled out (you see a message in the 
syslog when mounting the filesystem that barriers will not be used).  
Already mounting with "noatime".  Also have been trying "filestreams".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
