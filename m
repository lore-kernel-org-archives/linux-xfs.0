Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81EJuKv179894 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 09:20:06 -0500
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E7504164FA
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 07:20:01 -0700 (PDT)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id 9I1GYpknkffHXbmB for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 07:20:01 -0700 (PDT)
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 1C8264B01D8
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 16:19:05 +0200 (CEST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 2C0B24B0143
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 16:19:02 +0200 (CEST)
Date: Tue, 1 Sep 2009 16:19:06 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: zero size file after power failure with kernel 2.6.30.5
Message-ID: <20090901161906.0a4ca1d1@harpe.intellique.com>
In-Reply-To: <19100.63566.98250.185404@tree.ty.sabi.co.uk>
References: <200908292102.21710@zmi.at> <4A99A80C.9010307@sandeen.net>
	<19100.22644.149019.555685@tree.ty.sabi.co.uk>
	<200909010918.37886@zmi.at>
	<19100.63566.98250.185404@tree.ty.sabi.co.uk>
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
To: Linux XFS <xfs@oss.sgi.com>

Le Tue, 1 Sep 2009 10:32:46 +0000
pg_xf2@xf2.sabi.co.UK (Peter Grandi) =E9crivait:

> If that and having good scalable performance at the same time
> requires having dual power supplies, redundant storage paths,
> and battery backup, that is the typical platform on which XFS is
> deployed.

To mitigate this, I used systems with XFS daily for the last 13 years,
(including IRIX workstations or PCs with only one drive) and had only
once a problem clearly related to XFS (a well known bug, long
corrected nowadays).

-- =

----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
