Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VL5YLn236052 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 16:05:34 -0500
Date: Wed, 31 Oct 2012 17:07:24 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <125229458.20035186.1351717644017.JavaMail.root@redhat.com>
In-Reply-To: <20121031192546.066642460@sgi.com>
Subject: Re: [patch 3/4] xfsdump: update version and changelog
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com


----- Original Message -----
> Update the version and changelogs for xfsdump.
> ...
> Index: b/debian/changelog
> ===================================================================
> --- a/debian/changelog	2012-10-31 12:39:28.991322370 -0500
> +++ b/debian/changelog	2012-10-31 12:41:27.522005796 -0500
> @@ -1,3 +1,9 @@
> +xfsdump (3.1.1) unstable; urgency=low
> +
> +  * New upstream release

Actually, could you add the following line below the above please?

  * Add German translation from Chris Leick (closes: #576257)


thanks!

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
