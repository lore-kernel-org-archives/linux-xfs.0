Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AKfRpS078500 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 14:41:27 -0600
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 313641C32F9
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 12:42:38 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id IAuqKAgI8Zy3NMk3 for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 12:42:38 -0800 (PST)
Date: Wed, 10 Feb 2010 21:42:16 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: [PATCH] enable inode64 by default when possible
Message-ID: <20100210214216.0ab263fd@galadriel.home>
In-Reply-To: <4B7313D9.9020603@sandeen.net>
References: <4B7309D7.5090800@sandeen.net>
	<20100210210448.36f16aba@galadriel.home>
	<4B7313D9.9020603@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Le Wed, 10 Feb 2010 14:15:21 -0600 vous =E9criviez:

> > But doesn't it cause problems specially for NFS sharing ?
> >   =

> =

> For some clients, yes - as do other NFS servers.

It would be nice to mention which one... At least it would be good to
know at least approximately which releases of the main Unix clients
(Linux, Solaris, OS X, BSDs, HP/UX, AIX) are compatible.

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
