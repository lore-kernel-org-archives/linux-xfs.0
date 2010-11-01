Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1A6Rta199133 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 05:06:27 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50123141F32
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 03:07:47 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id TiBVKvkldr9tl7Gt for
	<xfs@oss.sgi.com>; Mon, 01 Nov 2010 03:07:47 -0700 (PDT)
Date: Mon, 1 Nov 2010 11:07:34 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair of critical volume
Message-ID: <20101101110734.3ce15556@galadriel.home>
In-Reply-To: <1A57C61E-463F-4CB4-967C-DD6B66857E28@ucsc.edu>
References: <C17C2CB6-A695-41B2-B12A-1CBF6DAD556F@ucsc.edu>
	<20101031214021.686f43b8@galadriel.home>
	<1A57C61E-463F-4CB4-967C-DD6B66857E28@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

Le Sun, 31 Oct 2010 20:40:20 -0700 vous =E9criviez:

> Thanks for your help. The RAID is a SCSI connected direct attached
> storage 16 bay unit made by Maxtronic. It is a Janus 6640, is case
> that helps anything.

Alas, never heard of it... Looks like a quite low end hardware, without
redundant controllers. Probably similar to Infortrend. The possibility
of an unreliable firmware cannot be excluded with these :)

> At the time of its problem, it was mounted
> read-only as I was trying to be careful of the data, since the main
> volume failed and this was our only copy. So maybe the cache isn't a
> big deal.

Indeed, nothing to lose in RO mode.

> I'll try the "dead" drives tomorrow with a WD utility. I'll
> give Spinrite a try, if the WD utility doesn't revive them.

Good luck.

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
