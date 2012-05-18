Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IHUlOm231604 for <xfs@oss.sgi.com>; Fri, 18 May 2012 12:30:48 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uZSRZx6bDzb7RJay for
	<xfs@oss.sgi.com>; Fri, 18 May 2012 10:30:46 -0700 (PDT)
Message-ID: <4FB68744.1090304@redhat.com>
Date: Fri, 18 May 2012 12:30:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: Lost patch fixing test 273?
References: <20120515124654.GE22359@quack.suse.cz>
In-Reply-To: <20120515124654.GE22359@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On 5/15/12 7:46 AM, Jan Kara wrote:
>   Hi,
> 
>   I'm still getting failures for test 273 among other reasons because
> http://oss.sgi.com/archives/xfs/2012-04/msg01029.html didn't get applied.
> Why so?
> 
> 								Honza


are you pulling from xfstests-dev.git on kernel.org or xfstests.git from oss.sgi.com?

The former is usually more up to date.

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=commitdiff;h=1fce0780f63ccdd308767e23fe39a18d30d973d6

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
