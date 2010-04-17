Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3H7CGIc044677 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 02:12:16 -0500
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E22732CC374
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 00:14:11 -0700 (PDT)
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6]) by
	cuda.sgi.com with ESMTP id MC8FhDAFfz6Vuc6F for
	<xfs@oss.sgi.com>; Sat, 17 Apr 2010 00:14:11 -0700 (PDT)
Date: Sat, 17 Apr 2010 09:13:57 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_fsr question for improvement
Message-ID: <20100417091357.4e7ad1e0@galadriel.home>
In-Reply-To: <20100417012415.GE2493@dastard>
References: <201004161043.11243@zmi.at>
	<20100417012415.GE2493@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Le Sat, 17 Apr 2010 11:24:15 +1000 vous =E9criviez:

>  XFS resists fragmentation better than most other
> filesystems, so defragmentation, while possible, is generally not
> needed.

There two systems nevertheless where I need to use xfs_fsr regularly to
keep decent performance : my test VMware server (performance dropped
down to abysmal level until I set up a daily xfs_fsr cron job), and a
write-intensive video server.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
