Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9NKFXVM061812 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 15:15:33 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1394B84D85
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 13:32:05 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id yPjKNI21hFVtaxFX for
	<xfs@oss.sgi.com>; Sat, 23 Oct 2010 13:32:05 -0700 (PDT)
Date: Sat, 23 Oct 2010 22:16:39 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Best filesystems ?
Message-ID: <20101023221639.5ac29ad9@galadriel.home>
In-Reply-To: <19651.9652.631329.903552@tree.ty.sabi.co.uk>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<19646.55189.843933.481529@tree.ty.sabi.co.uk>
	<20101021020009.GG12506@dastard>
	<19648.27859.799400.168394@tree.ty.sabi.co.uk>
	<Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
	<19651.9652.631329.903552@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

Le Sat, 23 Oct 2010 19:13:08 +0100 vous =E9criviez:

> Its major limitation are internal complexity and should
>   only be used on 64b systems. It can support single filesystems
>   larger than 10-15TB, but that's stretching things.

I currently take care of 100 servers with 20 to 80 TB XFS filesystems.
Most are under heavy use, 95% filled for more than 3 years in a row,
etc. I can safely affirm that XFS is definitely safe for anything up to
80 TB.

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
